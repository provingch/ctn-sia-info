<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html data-theme="light">
<head>
  <title>CTNPortal - Administrador</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=200">
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
</head>
<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
  <c:url var="profileUrl" value="/ProfileServlet" />
  <c:url var="logoutUrl" value="/LogoutServlet" />
  <header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#ctnNavbarMenu" aria-expanded="false">
          <span class="sr-only">Abrir navegación</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand ctn-navbar-brand" href="${pageContext.request.contextPath}/HomeServlet" aria-label="Ir a inicio">
          <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg" alt="CTN">
          <span>Colegio Técnico Nacional</span>
        </a>
      </div>
      <div class="collapse navbar-collapse" id="ctnNavbarMenu">
        <ul class="nav navbar-nav navbar-right ctn-navbar-actions">
          <li class="ctn-theme-item"></li>
          <li><a class="manual-link" href="${pageContext.request.contextPath}/pdfs/manual.pdf" target="_blank" rel="noopener noreferrer">Manual</a></li>
          <li class="dropdown">
            <a href="#" id="sessionButton" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sesión <span class="caret"></span></a>
            <ul class="dropdown-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
              <li><a role="menuitem" href="${profileUrl}">Mi Perfil</a></li>
              <li><a role="menuitem" class="session-logout" href="${logoutUrl}">Cerrar Sesión</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </header>
  <main>
    <section class="container page-shell">
      <div class="info-bar">
        <span>Bienvenido/a ${sessionScope.user.fullName}</span>
      </div>
      <div class="table-card card tareas-grid">
        <div class="table-header">Métrica</div>
        <div class="table-header">Valor</div>
        <div class="cell">Profesores</div>
        <div class="cell"><c:out value="${profesorCount}" /></div>
        <div class="cell">Cursos</div>
        <div class="cell"><c:out value="${cursoCount}" /></div>
        <div class="cell">Especialidades</div>
        <div class="cell"><c:out value="${especialidadCount}" /></div>
      </div>
        <div style="margin-top:1rem">
        <a class="btn-primary" href="${pageContext.request.contextPath}/AdminMateriasServlet">Gestionar Materias</a>
        <a class="btn-primary" href="${pageContext.request.contextPath}/AdminUsuariosServlet">Gestionar Usuarios</a>
        <a class="btn-primary" href="${pageContext.request.contextPath}/AdminAsignacionesServlet">Gestionar Asignaciones</a>
      </div>
    </section>
    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
  </main>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>
  </body>
</html>
