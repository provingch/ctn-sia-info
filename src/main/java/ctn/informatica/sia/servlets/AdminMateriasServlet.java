package ctn.informatica.sia.servlets;

import ctn.informatica.sia.dao.MateriaDao;
import ctn.informatica.sia.model.Materia;
import ctn.informatica.sia.model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminMateriasServlet", urlPatterns = {"/AdminMateriasServlet"})
public class AdminMateriasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Materia> materias = new MateriaDao().listAll();
            req.setAttribute("materias", materias);
        } catch (SQLException ex) {
            log("Error loading materias for admin", ex);
            req.setAttribute("errors", java.util.List.of("No se pudo cargar el catálogo de materias."));
        }
        req.getRequestDispatcher("/AdminMaterias.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || user.getLevel() != 3) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("check".equals(action)) {
                int fromId = Integer.parseInt(req.getParameter("fromId"));
                int toId = Integer.parseInt(req.getParameter("toId"));
                MateriaDao dao = new MateriaDao();
                List<String> conflicts = dao.checkMergeConflicts(fromId, toId);
                req.setAttribute("conflicts", conflicts);
                req.setAttribute("fromId", fromId);
                req.setAttribute("toId", toId);
                // reload materias for display
                req.setAttribute("materias", new MateriaDao().listAll());
                req.getRequestDispatcher("/AdminMaterias.jsp").forward(req, resp);
                return;
            } else if ("merge".equals(action)) {
                int fromId = Integer.parseInt(req.getParameter("fromId"));
                int toId = Integer.parseInt(req.getParameter("toId"));
                // double-check conflicts before executing
                MateriaDao dao = new MateriaDao();
                List<String> conflicts = dao.checkMergeConflicts(fromId, toId);
                if (!conflicts.isEmpty()) {
                    session.setAttribute("errors", java.util.List.of("No se puede ejecutar merge: existen planillas en conflicto."));
                    resp.sendRedirect(req.getContextPath() + "/AdminMateriasServlet");
                    return;
                }
                dao.mergeMaterias(fromId, toId);
                // detailed admin activity log
                appendAdminActivity(session, "Merge materias: from=" + fromId + " to=" + toId);
                session.setAttribute("flashMessage", "Merge realizado correctamente.");
            }
        } catch (NumberFormatException ex) {
            session.setAttribute("errors", java.util.List.of("Ids inválidos para merge."));
        } catch (SQLException ex) {
            session.setAttribute("errors", java.util.List.of("No se pudo realizar el merge: " + ex.getMessage()));
        }
        resp.sendRedirect(req.getContextPath() + "/AdminMateriasServlet");
    }

    private void appendAdminActivity(HttpSession session, String entry) {
        if (session == null) return;
        java.util.List<String> log = (java.util.List<String>) session.getAttribute("adminActivityLog");
        if (log == null) {
            log = new java.util.ArrayList<>();
            session.setAttribute("adminActivityLog", log);
        }
        log.add(entry);
        if (log.size() > 50) log.remove(0);
    }

}
