<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html data-theme="light">
<head>
  <title>CTNPortal - Administrador</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css?v=163">
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
</head>
<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
  <header class="site-header">
    <div class="header-logo-container">
      <a href="${pageContext.request.contextPath}/HomeServlet" aria-label="Ir a inicio">
        <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg">
      </a>
    </div>
    <div class="header-school-name">
      Colegio Técnico Nacional
    </div>
    <c:url var="profileUrl" value="/ProfileServlet" />
    <c:url var="logoutUrl" value="/LogoutServlet" />
    <div class="right-section">
      <div class="manual-container">
        <a class="manual-link" href="${pageContext.request.contextPath}/pdfs/manual.pdf" target="_blank">Manual</a>
      </div>
      <div class="session-dropdown" id="sessionDropdown">
        <button class="session-button" id="sessionButton" aria-haspopup="true" aria-expanded="false" aria-controls="sessionMenu">
          Sesión
          <svg class="dropdown-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M7 10l5 5 5-5z"/></svg>
        </button>
        <nav class="session-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
          <a role="menuitem" class="session-item" href="${profileUrl}">Mi Perfil</a>
          <a role="menuitem" class="session-item session-logout" href="${logoutUrl}">Cerrar Sesión</a>
        </nav>
      </div>
    </div>
  </header>
  <main>
    <section class="container page-shell">
      <div class="titleblock">
        <div class="tb-left">
          <div class="tb-logo">CTN</div>
          <div class="tb-name">
            <h1>Panel de Administrador</h1>
            <span>Visión general del sistema</span>
          </div>
        </div>
        <div class="tb-right">
          <div class="tb-cell"><b>Usuario</b>${sessionScope.user.fullName}</div>
          <div class="tb-cell"><b>Sección</b>Administración</div>
          <div class="tb-cell"><b>Rol</b>Admin</div>
        </div>
      </div>
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
    </section>
    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
  </main>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>
  <script>
  (function () {
    const dropdown = document.getElementById('sessionDropdown');
    if (!dropdown) return;
    const button = document.getElementById('sessionButton');
    const menu = document.getElementById('sessionMenu');
    function openMenu() { dropdown.classList.add('open'); button.classList.add('open'); button.setAttribute('aria-expanded', 'true'); }
    function closeMenu() { dropdown.classList.remove('open'); button.classList.remove('open'); button.setAttribute('aria-expanded', 'false'); }
    button.addEventListener('click', function (e) { e.stopPropagation(); if (dropdown.classList.contains('open')) closeMenu(); else openMenu(); });
    document.addEventListener('click', function (e) { if (!dropdown.contains(e.target)) closeMenu(); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeMenu(); });
    menu.addEventListener('click', function (e) { if (e.target.matches('a')) closeMenu(); });
  })();
  </script>
</body>
</html>
