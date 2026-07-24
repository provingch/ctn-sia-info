<%-- 
    Document   : Admin
    Created on : Oct 2, 2025, 6:45:45 AM
    Author     : jonat
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>

<html data-theme="light">

<head>
  <title>CTNPortal - Administradores</title>
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
        <button
          class="session-button"
          id="sessionButton"
          aria-haspopup="true"
          aria-expanded="false"
          aria-controls="sessionMenu">
          Sesión
          <svg class="dropdown-icon" viewBox="0 0 24 24" fill="currentColor">
            <path d="M7 10l5 5 5-5z"/>
          </svg>
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
            <h1>Colegio Técnico Nacional</h1>
            <span>Administración de informes</span>
          </div>
        </div>
        <div class="tb-right">
          <div class="tb-cell"><b>Usuario</b>${sessionScope.user.fullName}</div>
          <div class="tb-cell"><b>Sección</b>Administración</div>
          <div class="tb-cell"><b>Rol</b>Admin</div>
          <div class="tb-cell"><b>Fecha</b><c:out value="${nowFormatted}" /></div>
        </div>
      </div>
      <div class="info-bar">
        <span>Bienvenido/a ${sessionScope.user.fullName}</span>
        <span>
          <c:out value="${nowFormatted}" />
        </span>
      </div>
      <div class="top-section planilla-hero hero-shell">
        <div class="planilla-hero__header">
          <div class="planilla-hero__info">
            <span class="badge"><span class="dot"></span>Administración</span>
            <h1>Descargar Planillas</h1>
            <p class="planilla-subtitle">Exporta informes por especialidad, curso y periodo.</p>
          </div>
        </div>
      </div>

      <c:url var="exportUrl" value="/ExportCoursePlanillasServlet" />

      <form id="exportCourseForm" action="${exportUrl}" method="get">
        <div class="table-card card tareas-grid">
<!--          <div class="table-header">Etapa</div>
          <div class="cell">
            <select name="etapa" required>
              <option value="" selected disabled>--Seleccione una etapa--</option>
              <option value="primera">Primera etapa</option>
              <option value="segunda">Segunda etapa</option>
            </select>
          </div>-->

          <div class="table-header">Especialidad</div>
          <div class="cell">
            <select name="especialidad" required>
              <option value="" selected disabled>--Seleccione una especialidad--</option>
              <c:forEach var="e" items="${especialidades}">
                <option value="${e.id}"
                    <c:if test="${not empty selEspecialidad and e.id == selEspecialidad.id}">selected</c:if>>
                  <c:out value="${e}" />
                </option>
              </c:forEach>
            </select>
          </div>

          <div class="table-header">Curso</div>
          <div class="cell">
            <select name="curso" id="curso-select" required>
              <option value="" selected disabled>--Seleccione un curso--</option>
              <option value="1">Primero</option>
              <option value="2">Segundo</option>
              <option value="3">Tercero</option>
            </select>
          </div>

          <div class="table-header">Sección</div>
          <div class="cell">
            <select name="seccion" id="seccion-select" required>
              <option value="" selected disabled>--Seleccione una sección--</option>
              <option value="A">A</option>
              <option value="B">B</option>
              <option value="C">C</option>
            </select>
          </div>

          <div class="table-header">Periodo</div>
          <div class="cell">
            <!-- required: admin must enter periodo (used to compute promocion) -->
            <input type="number" name="periodo" id="periodo-input" placeholder="2025" min="2000" required />
          </div>

          <div class="buttons-row table-header">
            <c:url var="backUrl" value="/PlanillaServlet">
              <c:param name="planillaId" value="${planillaId}" />
            </c:url>

            <button type="submit" id="downloadCourseBtn" class="btn-primary" title="Descargar planillas del curso">
              <img class="download-icon" src="${pageContext.request.contextPath}/icons/download-icon.svg" alt="Descargar">
              Descargar
            </button>
          </div>
        </div>
      </form>

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

  function openMenu() {
    dropdown.classList.add('open');
    button.classList.add('open');
    button.setAttribute('aria-expanded', 'true');
  }
  function closeMenu() {
    dropdown.classList.remove('open');
    button.classList.remove('open');
    button.setAttribute('aria-expanded', 'false');
  }

  // toggle on click
  button.addEventListener('click', function (e) {
    e.stopPropagation();
    if (dropdown.classList.contains('open')) closeMenu();
    else openMenu();
  });

  // close when clicking anywhere else
  document.addEventListener('click', function (e) {
    if (!dropdown.contains(e.target)) closeMenu();
  });

  // close on escape
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeMenu();
  });

  // optionally close when choosing a menu item
  menu.addEventListener('click', function (e) {
    const t = e.target;
    if (t.matches('a')) {
      // allow link default navigation, but close the menu
      closeMenu();
    }
  });

})();
</script>

</body>

</html>
