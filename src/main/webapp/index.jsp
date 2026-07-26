<%-- 
    Document   : index
    Created on : Aug 5, 2025, 5:25:54 PM
    Author     : jonat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Optional"%>
<%@page import="jakarta.servlet.http.Cookie"%>
<%@page import="ctn.informatica.sia.dao.UserDao"%>
<%@page import="ctn.informatica.sia.dao.ProfesorDao"%>
<%@page import="ctn.informatica.sia.dao.PadreDao"%>
<%@page import="ctn.informatica.sia.dao.EspecialidadDao"%>
<%@page import="ctn.informatica.sia.model.User"%>
<%@page import="ctn.informatica.sia.model.Profesor"%>
<%@page import="ctn.informatica.sia.model.Padre"%>
<%@page import="ctn.informatica.sia.model.Especialidad"%>
<%@page import="ctn.informatica.sia.util.RememberMeTokenStore"%>
<%@page import="ctn.informatica.sia.util.SiaUiContext"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    HttpSession existingSession = request.getSession(false);
    User currentUser = existingSession == null ? null : (User) existingSession.getAttribute("user");
    if (currentUser == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("SIA_REMEMBER".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().isBlank()) {
                    String token = cookie.getValue().trim();
                    Integer userId = RememberMeTokenStore.resolveUserId(token).orElse(null);
                    if (userId != null) {
                        User restoredUser = new UserDao().findById(userId);
                        if (restoredUser != null) {
                            HttpSession restoredSession = request.getSession(true);
                            restoredSession.setMaxInactiveInterval(60 * 60 * 24 * 7);
                            restoredSession.setAttribute("user", restoredUser);
                            try {
                                Profesor profesor = new ProfesorDao().findById(restoredUser.getId());
                                restoredSession.setAttribute("profesor", profesor);
                                String specialty = "informatica";
                                if (profesor != null && profesor.getEspecialidadId() != null) {
                                    Especialidad especialidad = new EspecialidadDao().findById(profesor.getEspecialidadId());
                                    if (especialidad != null && especialidad.getNombre() != null && !especialidad.getNombre().isBlank()) {
                                        specialty = SiaUiContext.normalizeSpecialty(especialidad.getNombre());
                                    }
                                }
                                restoredSession.setAttribute("siaSpecialty", specialty);
                            } catch (Exception ignored) {
                                // no-op
                            }
                            try {
                                Padre padre = new PadreDao().findById(restoredUser.getId());
                                if (padre != null) {
                                    restoredSession.setAttribute("padre", padre);
                                }
                            } catch (Exception ignored) {
                                // no-op
                            }
                            String redirectTarget;
                            switch (restoredUser.getLevel()) {
                                case 1:
                                    redirectTarget = "/HomeServlet";
                                    break;
                                case 2:
                                    redirectTarget = "/EvaluacionServlet";
                                    break;
                                case 3:
                                    redirectTarget = "/AdminServlet";
                                    break;
                                case 4:
                                    redirectTarget = "/ParentServlet";
                                    break;
                                default:
                                    redirectTarget = "/index.jsp";
                            }
                            response.sendRedirect(request.getContextPath() + redirectTarget);
                            return;
                        }
                    }
                    Cookie expiredCookie = new Cookie("SIA_REMEMBER", "");
                    expiredCookie.setMaxAge(0);
                    expiredCookie.setPath(request.getContextPath().isBlank() ? "/" : request.getContextPath());
                    expiredCookie.setHttpOnly(true);
                    expiredCookie.setSecure(request.isSecure());
                    response.addCookie(expiredCookie);
                    break;
                }
            }
        }
    } else {
        String redirectTarget;
        switch (currentUser.getLevel()) {
            case 1:
                redirectTarget = "/HomeServlet";
                break;
            case 2:
                redirectTarget = "/EvaluacionServlet";
                break;
            case 3:
                redirectTarget = "/AdminServlet";
                break;
            case 4:
                redirectTarget = "/ParentServlet";
                break;
            default:
                redirectTarget = "/index.jsp";
        }
        response.sendRedirect(request.getContextPath() + redirectTarget);
        return;
    }
%>

<!DOCTYPE html>
<html data-theme="light">

  <head>
    <title>CTNPortal</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=210">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  </head>

  <!-- as convention the class names must be in english -->

  <body class="login-page" data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}" data-specialty-source="session">
    <header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#ctnNavbarMenu" aria-expanded="false">
          <span class="sr-only">Abrir navegación</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand ctn-navbar-brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Ir a inicio">
          <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg" alt="CTN">
          <span>Colegio Técnico Nacional</span>
        </a>
      </div>
      <div class="collapse navbar-collapse" id="ctnNavbarMenu">
        <ul class="nav navbar-nav navbar-right ctn-navbar-actions">
          <li class="ctn-theme-item"></li>
        </ul>
      </div>
    </div>
  </header>

    <main class="login-main">
      <div class="login-wrapper">
        <div class="login-card">
          <div class="login-logo-container">
            <img class="login-logo" src="${pageContext.request.contextPath}/images/ctn-logo-2.svg">
          </div>
          <div class="login-heading">
            <h1>Iniciar sesión</h1>
            <p>Sistema de informes académicos</p>
          </div>
          <c:if test="${loginError}">
              <div class="login-error">Nombre de usuario o contraseña incorrectos.</div>
          </c:if>
          <c:if test="${param.notice == 'login-required'}">
              <div class="login-info">Inicia sesión para ver tus planillas y cursos. Si estás corrigiendo la vinculación de alumnos, entra con tu usuario de integración tras iniciar sesión.</div>
          </c:if>
          <form class="login-form" action="LoginServlet" method="post">
            <input class="form-username" placeholder="Usuario" type="text" name="username">
            <input class="form-password" placeholder="Contraseña" type="password" name="password">
            <div class="login-remember">
              <label>
                <input type="checkbox" name="rememberMe" value="true">
                <span>Mantener sesión</span>
              </label>
            </div>
            <input class="form-submit" type="submit" value="Iniciar Sesión">
          </form>
        </div>
      </div>
    </main>

    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>

    <!-- Cookie Consent Banner -->
    <div id="cookieConsent" class="cookie-consent-banner" role="banner">
      <div class="cookie-consent-content">
        <div class="cookie-consent-text">
          <strong>Cookies funcionales</strong>
          <p>Usamos cookies necesarias para iniciar sesión, mantener la sesión activa y recordar tu preferencia de tema. Si marcás “Mantener sesión”, estas cookies son obligatorias.</p>
        </div>
        <div class="cookie-consent-actions">
          <button id="acceptCookies" class="cookie-consent-btn cookie-consent-btn-primary">Entendido</button>
        </div>
      </div>
    </div>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
    <script src="${pageContext.request.contextPath}/scripts/cookie-consent.js?v=164"></script>
  </body>

</html>
