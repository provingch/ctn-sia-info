<%-- 
    Document   : Home
    Created on : Aug 3, 2025, 4:39:40 PM
    Author     : jonat
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>



<html data-theme="light">

<head>
  <title>CTNPortal - Profesores</title>
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
            <h1>Panel de materias</h1>
            <span>Acceso a planillas y tareas</span>
          </div>
        </div>
        <div class="tb-right">
          <div class="tb-cell"><b>Curso</b> ${selCurso.getCurso()}.<sup>o</sup> "${selCurso.seccion}"</div>
          <div class="tb-cell"><b>Especialidad</b> ${selCurso.especialidad}</div>
          <div class="tb-cell"><b>Docente</b> ${sessionScope.user.fullName}</div>
          <div class="tb-cell"><b>Fecha</b> <c:out value="${nowFormatted}" /></div>
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
            <span class="badge"><span class="dot"></span>${selCurso.especialidad}</span>
            <h1>Materias de ${selCurso.especialidad} ${selCurso.getCurso()}.<sup>o</sup> "${selCurso.seccion}"</h1>
            <p class="planilla-subtitle">Panel principal para abrir planillas, revisar cursos y gestionar tareas.</p>
          </div>
          <div class="planilla-hero__actions">
            <div class="btn-row hero-actions">
              <a class="btn-primary hero-action-button" href="${pageContext.request.contextPath}/ProfileServlet">Perfil institucional</a>
            </div>
          </div>
        </div>
        <div class="menu-container">
          <form action="HomeServlet" method="get">
            <select class="selCurso" name="cursoId" onchange="this.form.submit()">
              <option value="">--Seleccione un curso--</option>
              <c:forEach var="c" items="${cursos}">
                  <option value="${c.id}"
                          ${c.id == selCurso.id ? 'selected="selected"' : ''}>
                    ${c.toString()}
                  </option>
              </c:forEach>
            </select>
          </form>

          <p class="selection-hint">
            Curso seleccionado: <strong>${selCurso.especialidad} ${selCurso.getCurso()}.<sup>o</sup> "${selCurso.seccion}"</strong>
          </p>
          <span id="date-range"><i><b>Desde:</b> - <b>Hasta:</b></i></span>
        </div>
      </div>

      <c:if test="${not googleClassroomConnected and empty planillas}">
        <div class="empty-state-wrapper">
          <div class="empty-state empty-state-card empty-state-card--compact">
            <c:out value="${googleClassroomPlaceholder}" />
          </div>
        </div>
      </c:if>

      <div class="grid-container">
        <c:if test="${not empty googleClassroomError}">
          <div class="empty-state empty-state-card">
            <c:out value="${googleClassroomError}" />
          </div>
        </c:if>

        <c:if test="${googleClassroomConnected and not empty googleClassroomCourses}">
          <div class="section-block">
            <div class="section-heading">Cursos de Google Classroom</div>
            <div class="planilla-grid">
              <c:forEach var="course" items="${googleClassroomCourses}">
                <c:set var="targetMateriaId" value="${classroomPlanillaMateriaMap[course.id]}" />
                <c:set var="hasMatch" value="${not empty targetMateriaId}" />
                <a class="planilla-card-link" href="${pageContext.request.contextPath}/PlanillaServlet?cursoId=${selCurso.id}&materiaId=${targetMateriaId}&etapa=${selEtapa}">
                    <div class="planilla-card card">
                      <div class="head">
                        <div class="card-title-row">
                          <c:out value="${course.name}" />
                          <c:if test="${not hasMatch}">
                            <span class="badge-warning">Sin vincular</span>
                          </c:if>
                        </div>
                      </div>
                      <div class="body">
                        <div class="info-grid">
                          <span class="total-tareas label">Sección</span>
                          <span class="total-tareas colon">:</span>
                          <span class="total-tareas value"><c:out value="${empty course.section ? (empty course.room ? '-' : course.room) : course.section}" /></span>
                          <span class="total-tareas label">Sala</span>
                          <span class="total-tareas colon">:</span>
                          <span class="total-tareas value"><c:out value="${empty course.room ? '-' : course.room}" /></span>
                        </div>
                      </div>
                    </div>
                </a>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <c:choose>
          <c:when test="${showPlanillaCards}">
            <div class="section-block">
              <div class="section-heading">Planillas del curso</div>
              <div class="planilla-grid">
                <c:forEach var="planilla" items="${planillas}">
                  <a class="planilla-card-link" href="${pageContext.request.contextPath}/PlanillaServlet?planillaId=${planilla.id}&cursoId=${selCurso.id}&materiaId=${planilla.materiaId}&etapa=${selEtapa}">
                    <div class="planilla-card card">
                      <div class="head">
                        <c:out value="${planilla.nombre}" />
                      </div>
                      <div class="body">
                        <div class="info-grid">
                          <span class="total-tareas label">Periodo</span>
                          <span class="total-tareas colon">:</span>
                          <span class="total-tareas value"><c:out value="${planilla.periodo}" /></span>
                          <span class="total-tareas label">Tareas</span>
                          <span class="total-tareas colon">:</span>
                          <span class="total-tareas value"><c:out value="${planilla.tareasCount}" /></span>
                        </div>
                      </div>
                    </div>
                  </a>
                </c:forEach>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <c:if test="${googleClassroomConnected and empty googleClassroomCourses}">
              <div class="empty-state empty-state-card">
                No hay planillas para este curso y etapa. Los bloques de Google Classroom aparecerán cuando haya conexión activa.
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
      </div>

    </section>



    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>


  </main>

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
<script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>

</body>

</html>
