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
  <title>CTNPortal - Evaluación</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=206">
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
        <span>
          <c:out value="${nowFormatted}" />
        </span>
      </div>
      <div class="top-section planilla-hero hero-shell">
        <div class="planilla-hero__header">
          <div class="planilla-hero__info">
            <span class="badge"><span class="dot"></span>Evaluación</span>
            <h1>Descargar planillas</h1>
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
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
</body>

</html>
