/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ctn.informatica.sia.servlets;

import ctn.informatica.sia.dao.CursoDao;
import ctn.informatica.sia.dao.EspecialidadDao;
import ctn.informatica.sia.dao.MateriaDao;
import ctn.informatica.sia.dao.ProfesorDao;
import ctn.informatica.sia.google.GoogleClassroomService;
import ctn.informatica.sia.model.Curso;
import ctn.informatica.sia.model.Especialidad;
import ctn.informatica.sia.model.Materia;
import ctn.informatica.sia.model.Profesor;
import ctn.informatica.sia.model.User;
import com.google.api.services.classroom.model.Course;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author jonat
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    private String normalizeManualSubjects(String raw) {
        if (raw == null) {
            return "";
        }
        List<String> subjects = new ArrayList<>();
        for (String token : raw.split("[,\r\n;]+")) {
            String normalized = token == null ? "" : token.trim().replaceAll("\\s+", " ");
            if (!normalized.isEmpty() && !subjects.contains(normalized)) {
                subjects.add(normalized);
            }
        }
        return String.join(", ", subjects);
    }

    private String sanitizeMateriaNombre(String raw) {
        if (raw == null) {
            return "";
        }
        return raw.trim().replaceAll("\\s+", " ");
    }

    /**
     * Materias asociadas al profesor a partir de sus planillas activas.
     */
    private List<Materia> loadTeacherMaterias(Profesor profesor) throws SQLException {
        if (profesor == null) {
            return Collections.emptyList();
        }
        return new MateriaDao().listByProfesor(profesor.getId());
    }

    private List<Materia> mergeManualTeacherMaterias(List<Materia> teacherMaterias, String manualTeacherSubjectsText) {
        if (manualTeacherSubjectsText == null || manualTeacherSubjectsText.trim().isEmpty()) {
            return teacherMaterias == null ? Collections.emptyList() : teacherMaterias;
        }

        List<Materia> merged = new ArrayList<>();
        if (teacherMaterias != null) {
            merged.addAll(teacherMaterias);
        }

        for (String rawSubject : manualTeacherSubjectsText.split("[,\r\n;]+")) {
            String normalized = rawSubject == null ? "" : rawSubject.trim();
            if (normalized.isEmpty()) {
                continue;
            }
            boolean exists = false;
            for (Materia existing : merged) {
                if (existing != null && normalized.equalsIgnoreCase(existing.getNombre())) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                merged.add(new Materia(0, normalized, "comun"));
            }
        }
        return merged;
    }

    private List<Integer> parseEspecialidadIds(String[] values) {
        List<Integer> ids = new ArrayList<>();
        if (values == null) {
            return ids;
        }
        for (String value : values) {
            if (value == null || value.trim().isEmpty()) {
                continue;
            }
            try {
                ids.add(Integer.parseInt(value.trim()));
            } catch (NumberFormatException ignored) {
                // ignore malformed ids
            }
        }
        return ids;
    }

    private String normalizeCategoria(String raw) {
        if (raw == null) {
            return "especifico";
        }
        String normalized = raw.trim().toLowerCase();
        return "comun".equals(normalized) ? "comun" : "especifico";
    }

    private boolean isAjaxRequest(HttpServletRequest req) {
        return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
    }

    private void writeJsonResponse(HttpServletResponse resp, boolean success, String message) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            out.write("{\"success\":" + success + ",\"message\":" + quoteJson(message) + "}");
        }
    }

    private String quoteJson(String input) {
        if (input == null) {
            return "\"\"";
        }
        String escaped = input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }

    private List<String> materiaNames(List<Materia> materias) {
        List<String> names = new ArrayList<>();
        for (Materia m : materias) {
            names.add(m.getNombre());
        }
        return names;
    }

    @SuppressWarnings("unchecked")
    private void appendActivityLog(HttpSession session, String entry) {
        if (session == null) {
            return;
        }

        List<String> activityLog = (List<String>) session.getAttribute("activityLog");
        if (activityLog == null) {
            activityLog = new ArrayList<>();
            session.setAttribute("activityLog", activityLog);
        }
        activityLog.add(entry);
        if (activityLog.size() > 20) {
            activityLog.remove(0);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        Profesor profesor = null;
        if (user != null) {
            profesor = new ProfesorDao().findById(user.getId());
        }

        List<Course> googleClassroomCourses = Collections.emptyList();
        boolean googleClassroomConnected = false;
        List<Materia> teacherMaterias = Collections.emptyList();
        List<Materia> availableMaterias = Collections.emptyList();
        List<Especialidad> especialidades = Collections.emptyList();
        String manualTeacherSubjectsText = "";
        if (session != null) {
            Object manualSubjects = session.getAttribute("manualTeacherSubjects");
            if (manualSubjects instanceof String) {
                manualTeacherSubjectsText = (String) manualSubjects;
            }
        }
        if (profesor != null && manualTeacherSubjectsText.isEmpty()) {
            manualTeacherSubjectsText = new ProfesorDao().findManualSubjectsText(profesor.getId());
        }
        try {
            teacherMaterias = loadTeacherMaterias(profesor);
            teacherMaterias = mergeManualTeacherMaterias(teacherMaterias, manualTeacherSubjectsText);
            if (profesor != null) {
                availableMaterias = new MateriaDao().listAvailableForProfesor(profesor.getId());
            }
            especialidades = new EspecialidadDao().findAll();
        } catch (SQLException ex) {
            log("Error loading teacher materias for profile user " + (user != null ? user.getId() : -1), ex);
        } catch (Exception ex) {
            log("Error loading specialty catalog for profile user " + (user != null ? user.getId() : -1), ex);
        }

        if (profesor != null && GoogleClassroomService.isGoogleConnected(profesor)) {
            googleClassroomConnected = true;
            try {
                List<Curso> cursos = user == null ? Collections.emptyList() : new CursoDao().consultarCursos(user.getId());
                googleClassroomCourses = GoogleClassroomService.listAllowedCourses(profesor, cursos, materiaNames(teacherMaterias));
            } catch (SQLException | IOException ex) {
                log("Error consulting Google Classroom courses for profile user " + (user != null ? user.getId() : -1), ex);
            }
        }

        req.setAttribute("profesor", profesor);
        req.setAttribute("googleClassroomConnected", googleClassroomConnected);
        req.setAttribute("googleClassroomCourses", googleClassroomCourses);
        req.setAttribute("teacherMaterias", teacherMaterias);
        req.setAttribute("availableMaterias", availableMaterias);
        req.setAttribute("especialidades", especialidades);
        req.setAttribute("manualTeacherSubjectsText", manualTeacherSubjectsText);
        req.setAttribute("activityLog", session != null ? session.getAttribute("activityLog") : Collections.emptyList());

        req.getRequestDispatcher("/Profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        String action = req.getParameter("action");
        
        if ("changePassword".equals(action)) {
            List<String> errors = new ArrayList<>();
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                errors.add("La contraseña actual es requerida.");
            }
            if (newPassword == null || newPassword.trim().isEmpty()) {
                errors.add("La nueva contraseña es requerida.");
            } else if (newPassword.length() < 6) {
                errors.add("La nueva contraseña debe tener al menos 6 caracteres.");
            }
            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                errors.add("La confirmación de contraseña es requerida.");
            } else if (!newPassword.equals(confirmPassword)) {
                errors.add("Las contraseñas no coinciden.");
            }
            
            if (errors.isEmpty() && user != null) {
                try {
                    Profesor profesor = new ProfesorDao().findById(user.getId());
                    if (profesor != null && profesor.getContrasenia().equals(currentPassword)) {
                        profesor.setContrasenia(newPassword);
                        new ProfesorDao().update(profesor);
                        session.setAttribute("flashMessage", "Contraseña actualizada exitosamente.");
                        appendActivityLog(session, "Contraseña actualizada.");
                    } else {
                        errors.add("La contraseña actual es incorrecta.");
                    }
                } catch (Exception ex) {
                    errors.add("Error al actualizar la contraseña: " + ex.getMessage());
                    log("Error updating password for user " + (user != null ? user.getId() : -1), ex);
                }
            }
            
            if (!errors.isEmpty()) {
                session.setAttribute("errors", errors);
            }
            
            resp.sendRedirect(req.getContextPath() + "/ProfileServlet");
            return;
        }
        
        if ("saveManualSubjects".equals(action)) {
            List<String> errors = new ArrayList<>();
            String materiaNombre = sanitizeMateriaNombre(req.getParameter("materiaNombre"));
            String categoria = normalizeCategoria(req.getParameter("categoria"));
            List<Integer> especialidadIds = parseEspecialidadIds(req.getParameterValues("especialidades"));
            if ("especifico".equals(categoria) && especialidadIds.size() > 1) {
                especialidadIds = new ArrayList<>(especialidadIds.subList(0, 1));
            }

            if (materiaNombre.isEmpty()) {
                String manualSubjects = req.getParameter("manualSubjects");
                if (manualSubjects == null || manualSubjects.trim().isEmpty()) {
                    errors.add("Debes ingresar el nombre de la materia antes de guardar.");
                }
            } else if (materiaNombre.length() < 2) {
                errors.add("El nombre de la materia es demasiado corto.");
            } else if (!materiaNombre.matches("^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 .\\-]+$")) {
                errors.add("El nombre de la materia solo puede contener letras, números, espacios y guiones.");
            }

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                if (isAjaxRequest(req)) {
                    writeJsonResponse(resp, false, String.join("; ", errors));
                    return;
                }
                doGet(req, resp);
                return;
            }

            if ("comun".equals(categoria) && especialidadIds.isEmpty()) {
                errors.add("Las materias comunes deben tener al menos una especialidad asociada.");
            }
            if ("especifico".equals(categoria) && especialidadIds.isEmpty()) {
                errors.add("Las materias específicas deben tener una especialidad asociada.");
            }

            if (errors.isEmpty()) {
                try {
                    MateriaDao materiaDao = new MateriaDao();
                    Materia materia = materiaDao.findByNombre(materiaNombre);
                    if (materia == null) {
                        int createdId = materiaDao.create(materiaNombre, categoria);
                        if (createdId > 0) {
                            materia = materiaDao.findById(createdId);
                        }
                    } else {
                        materiaDao.updateCategoria(materia.getId(), categoria);
                    }

                    if (materia != null) {
                        List<Integer> persistedEspecialidadIds = "comun".equals(categoria)
                                ? especialidadIds
                                : especialidadIds.isEmpty() ? Collections.emptyList() : List.of(especialidadIds.get(0));
                        materiaDao.replaceEspecialidades(materia.getId(), persistedEspecialidadIds);
                        if (user != null) {
                            materiaDao.linkProfesorMateria(user.getId(), materia.getId());
                        }
                    }

                    String existingManualText = "";
                    if (session != null) {
                        Object storedManualSubjects = session.getAttribute("manualTeacherSubjects");
                        if (storedManualSubjects instanceof String) {
                            existingManualText = (String) storedManualSubjects;
                        }
                    }
                    if (user != null && existingManualText.isBlank()) {
                        existingManualText = new ProfesorDao().findManualSubjectsText(user.getId());
                    }
                    String normalizedManualSubjects = normalizeManualSubjects(existingManualText + ", " + materiaNombre);
                    if (session != null) {
                        session.setAttribute("manualTeacherSubjects", normalizedManualSubjects);
                    }
                    if (user != null) {
                        new ProfesorDao().updateManualSubjectsText(user.getId(), normalizedManualSubjects);
                    }
                    if (session != null) {
                        session.setAttribute("flashMessage", "Materia guardada correctamente.");
                    }
                    if (isAjaxRequest(req)) {
                        writeJsonResponse(resp, true, "Materia guardada correctamente.");
                        return;
                    }
                    doGet(req, resp);
                    return;
                } catch (SQLException ex) {
                    errors.add("No se pudo guardar la materia. Intente de nuevo más tarde.");
                }
            }

            req.setAttribute("errors", errors);
            if (isAjaxRequest(req)) {
                writeJsonResponse(resp, false, String.join("; ", errors));
                return;
            }
            doGet(req, resp);
            return;
        }

        ProfesorDao profesorDao = new ProfesorDao();
        Profesor profesor = null;
        if (user != null) {
            profesor = profesorDao.findById(user.getId());
        }

        List<String> errors = new ArrayList<>();
        if (profesor == null) {
            errors.add("No se pudo cargar el perfil del profesor.");
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/Profile.jsp").forward(req, resp);
            return;
        }

        String correo = req.getParameter("correo");
        String telefono = req.getParameter("telefono");
        String celular = req.getParameter("celular");
        String usuario = req.getParameter("usuario");

        if (usuario == null || usuario.trim().isEmpty()) {
            errors.add("El nombre de usuario no puede estar vacío.");
        }

        try {
            if (telefono != null && !telefono.trim().isEmpty()) {
                profesor.setTelefono(Integer.valueOf(telefono.trim()));
            }
        } catch (NumberFormatException ex) {
            errors.add("Teléfono inválido: debe contener sólo dígitos.");
        }
        try {
            if (celular != null && !celular.trim().isEmpty()) {
                profesor.setCelular(Integer.valueOf(celular.trim()));
            }
        } catch (NumberFormatException ex) {
            errors.add("Celular inválido: debe contener sólo dígitos.");
        }

        profesor.setUsuario(usuario);
        if (correo != null) {
            profesor.setCorreo(correo);
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("profesor", profesor);
            req.getRequestDispatcher("/Profile.jsp").forward(req, resp);
            return;
        }

        boolean ok = profesorDao.update(profesor);
        if (ok) {
            if (session != null) {
                appendActivityLog(session, "Datos del perfil actualizados");
                session.setAttribute("flashMessage", "Datos guardados correctamente.");
            }
            if (isAjaxRequest(req)) {
                writeJsonResponse(resp, true, "Datos guardados correctamente.");
                return;
            }
            doGet(req, resp);
        } else {
            errors.add("No se pudieron guardar los datos. Intente de nuevo más tarde.");
            req.setAttribute("errors", errors);
            if (isAjaxRequest(req)) {
                writeJsonResponse(resp, false, String.join("; ", errors));
                return;
            }
            req.getRequestDispatcher("/Profile.jsp").forward(req, resp);
        }
    }
}