/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package ctn.informatica.sia.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import ctn.informatica.sia.dao.EspecialidadDao;
import ctn.informatica.sia.dao.UserDao;
import ctn.informatica.sia.model.Especialidad;
import ctn.informatica.sia.model.Padre;
import ctn.informatica.sia.model.Profesor;
import ctn.informatica.sia.model.User;
import ctn.informatica.sia.util.SiaUiContext;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author jonat
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/HomeServlet", "/PlanillaServlet", "/TareaServlet", "/ProfileServlet", "/AdminServlet", "/ParentServlet"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String ctx = request.getContextPath();

        HttpSession session = request.getSession(false);
        Object user = (session == null) ? null : session.getAttribute("user");

        if (user == null) {
            User restoredUser = restoreUserFromRememberCookie(request, response);
            if (restoredUser != null) {
                session = request.getSession(true);
                session.setMaxInactiveInterval(60 * 60 * 24 * 7);
                session.setAttribute("user", restoredUser);
                try {
                    Profesor profesor = new ctn.informatica.sia.dao.ProfesorDao().findById(restoredUser.getId());
                    session.setAttribute("profesor", profesor);
                    String specialty = "informatica";
                    if (profesor != null && profesor.getEspecialidadId() != null) {
                        try {
                            Especialidad especialidad = new EspecialidadDao().findById(profesor.getEspecialidadId());
                            if (especialidad != null && especialidad.getNombre() != null && !especialidad.getNombre().isBlank()) {
                                specialty = SiaUiContext.normalizeSpecialty(especialidad.getNombre());
                            }
                        } catch (Exception ignoredEspecialidad) {
                            specialty = "informatica";
                        }
                    }
                    session.setAttribute("siaSpecialty", specialty);
                } catch (Exception ignored) {
                    // no-op
                }
                try {
                    Padre padre = new ctn.informatica.sia.dao.PadreDao().findById(restoredUser.getId());
                    if (padre != null) {
                        session.setAttribute("padre", padre);
                    }
                } catch (Exception ignored) {
                    // no-op
                }
                user = restoredUser;
            } else {
                response.sendRedirect(ctx + "/index.jsp");
                return; // stop processing
            }
        }

        // prevent caching of protected pages (helps with Back after logout)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        chain.doFilter(req, res);
    }

    private User restoreUserFromRememberCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if ("SIA_REMEMBER".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().isBlank()) {
                try {
                    int userId = Integer.parseInt(cookie.getValue().trim());
                    User user = new UserDao().findById(userId);
                    if (user != null) {
                        Cookie refreshedCookie = new Cookie("SIA_REMEMBER", String.valueOf(user.getId()));
                        refreshedCookie.setMaxAge(60 * 60 * 24 * 30);
                        refreshedCookie.setPath(request.getContextPath().isBlank() ? "/" : request.getContextPath());
                        refreshedCookie.setHttpOnly(true);
                        refreshedCookie.setSecure(request.isSecure());
                        response.addCookie(refreshedCookie);
                        return user;
                    }
                } catch (Exception ex) {
                    System.err.println("Unable to restore user session from remember-me cookie: " + ex.getMessage());
                }
            }
        }
        return null;
    }

    @Override
    public void destroy() { /* no-op */ }

}
