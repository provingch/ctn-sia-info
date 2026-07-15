/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ctn.informatica.sia.servlets;

import ctn.informatica.sia.dao.PadreDao;
import ctn.informatica.sia.dao.UserDao;
import ctn.informatica.sia.model.Padre;
import ctn.informatica.sia.model.Profesor;
import ctn.informatica.sia.model.User;
import ctn.informatica.sia.util.SiaUiContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author jonat
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private static final String REMEMBER_COOKIE_NAME = "SIA_REMEMBER";
    private static final int REMEMBER_MAX_AGE_SECONDS = 60 * 60 * 24 * 30;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDao userDao = new UserDao();
        try {
            User user = userDao.findByUsernameAndPassword(username, password);
            if (user != null) {
                // store user in session
                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(60 * 60 * 24 * 7);
                session.setAttribute("user", user);
                try {
                    Profesor profesor = new ctn.informatica.sia.dao.ProfesorDao().findById(user.getId());
                    session.setAttribute("profesor", profesor);
                    String specialty = SiaUiContext.normalizeSpecialty(
                            profesor != null && profesor.getNombre() != null && !profesor.getNombre().isBlank()
                                    ? profesor.getNombre()
                                    : user.getUsername()
                    );
                    session.setAttribute("siaSpecialty", specialty);
                } catch (Exception ignored) {
                    // no-op: the planilla pages can recover by loading the professor from the DB later
                }
                try {
                    Padre padre = new PadreDao().findById(user.getId());
                    if (padre != null) {
                        session.setAttribute("padre", padre);
                    }
                } catch (Exception ignored) {
                    // no-op: parent page can recover by loading the parent from the DB later
                }
                setRememberMeCookie(request, response, user);

                int level = user.getLevel();
                switch (level) {
                    case 1:
                        response.sendRedirect(request.getContextPath() + "/HomeServlet");
                        break;
                    case 2:
                        response.sendRedirect(request.getContextPath() + "/AdminServlet");
                        break;
                    case 4:
                        response.sendRedirect(request.getContextPath() + "/ParentServlet");
                        break;
                    default:
                        request.setAttribute("loginError", true);
                        request.getRequestDispatcher("/index.jsp").forward(request, response);
                }

            } else {
                // login failed: send back to login with error flag
                request.setAttribute("loginError", true);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("DB error during login", e);
        }
    }

    private void setRememberMeCookie(HttpServletRequest request, HttpServletResponse response, User user) {
        Cookie cookie = new Cookie(REMEMBER_COOKIE_NAME, String.valueOf(user.getId()));
        cookie.setMaxAge(REMEMBER_MAX_AGE_SECONDS);
        cookie.setPath(request.getContextPath().isBlank() ? "/" : request.getContextPath());
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        response.addCookie(cookie);
    }
}
