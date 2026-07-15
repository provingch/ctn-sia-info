<%-- 
    Document   : index
    Created on : Aug 5, 2025, 5:25:54 PM
    Author     : jonat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html data-theme="light">

  <head>
    <title>CTNPortal</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  </head>

  <!-- as convention the class names must be in english -->

  <body class="login-page" data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}" data-specialty-source="session">
    <header class="site-header">
      <div class="header-logo-container">
        <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg">
      </div>
      <div class="header-school-name">
        Colegio Técnico Nacional
      </div>
      <div class="right-section"></div>
    </header>

    <main>
      <div class="login-wrapper">
        <div class="login-card">
          <div class="login-logo-container">
            <img class="login-logo" src="${pageContext.request.contextPath}/images/ctn-logo-2.svg">
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
            <input class="form-submit" type="submit" value="Iniciar Sesión">
          </form>
        </div>
      </div>
    </main>

    <!-- Cookie Consent Banner -->
    <div id="cookieConsent" class="cookie-consent-banner" role="banner">
      <div class="cookie-consent-content">
        <div class="cookie-consent-text">
          <strong>Política de Cookies</strong>
          <p>Este sitio utiliza cookies funcionales para mantener tu sesión y tu preferencia de tema. Las cookies son necesarias para que la aplicación funcione correctamente.</p>
        </div>
        <div class="cookie-consent-actions">
          <button id="acceptCookies" class="cookie-consent-btn cookie-consent-btn-primary">Aceptar</button>
          <button id="declineCookies" class="cookie-consent-btn cookie-consent-btn-secondary">Rechazar</button>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/scripts/sia-theme.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/cookie-consent.js"></script>
  </body>

</html>
