/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ctn.informatica.sia;

import ctn.informatica.sia.dao.UserDao;
import ctn.informatica.sia.model.User;
import java.io.IOException;
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
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

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
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                // forward to home.jsp

                int level = user.getLevel();
                switch (level) {
                    case 1:
                        response.sendRedirect(request.getContextPath() + "/HomeServlet");
                        break;
                    case 2:
                        response.sendRedirect(request.getContextPath() + "/AdminServlet");
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
}
