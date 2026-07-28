<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html data-theme="light">
<head>
  <title>CTNPortal - Ingresantes</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=235" />
  <style>
    .capacity-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; margin: 16px 0 24px; }
    .capacity-card { border: 1px solid #dfe5ed; border-radius: 12px; padding: 12px 14px; background: #fff; }
    .capacity-card.ideal { border-color: #1abc9c; background: #f0fffa; }
    .capacity-card.warning { border-color: #f0c36d; background: #fff8e8; }
    .capacity-card.over { border-color: #e74c3c; background: #fff2f0; }
    .capacity-v { font-size: 1.1rem; font-weight: 700; }
    .muted { color: #6b7280; }
    .filter-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 12px 0 16px; }
    .filter-row .form-group { flex: 1 1 220px; margin-bottom: 0; }
    .student-card.hidden { display: none; }
    .capacity-groups { display: grid; gap: 18px; margin: 18px 0 26px; }
    .capacity-specialty {
      overflow: hidden;
      border: 1px solid var(--line);
      border-radius: 10px;
      background: var(--paper);
    }
    .capacity-specialty__header {
      margin: 0;
      padding: 12px 16px;
      border-left: 4px solid var(--accent);
      border-bottom: 1px solid var(--line);
      background: color-mix(in srgb, var(--paper) 88%, var(--accent) 7%);
      color: var(--ink);
      font-size: 1.15rem;
      font-weight: 900;
    }
    .capacity-course-group { padding: 14px 16px 16px; }
    .capacity-course-group + .capacity-course-group { border-top: 1px solid var(--line); }
    .capacity-course-group__title {
      margin: 0 0 10px;
      color: color-mix(in srgb, var(--ink) 82%, var(--muted));
      font-size: 0.82rem;
      font-weight: 900;
      letter-spacing: 0.04em;
      text-transform: uppercase;
    }
    .capacity-section-grid {
      display: grid;
      gap: 12px;
      margin: 0;
    }
    .capacity-section-grid.sections-1 { grid-template-columns: minmax(0, 1fr); }
    .capacity-section-grid.sections-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    .capacity-section-grid.sections-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
    .capacity-section-grid .capacity-card {
      min-width: 0;
      height: 100%;
      background: color-mix(in srgb, var(--paper) 94%, var(--line) 6%);
      border-color: var(--line);
      color: var(--ink);
    }
    .capacity-section-grid .capacity-card.ideal {
      border-color: #1abc9c;
      background: color-mix(in srgb, var(--paper) 91%, #1abc9c 9%);
    }
    .capacity-section-grid .capacity-card.warning {
      border-color: #d9a441;
      background: color-mix(in srgb, var(--paper) 91%, #f0c36d 9%);
    }
    .capacity-section-grid .capacity-card.over {
      border-color: #e74c3c;
      background: color-mix(in srgb, var(--paper) 91%, #e74c3c 9%);
    }
    .capacity-section-grid .capacity-v { color: var(--ink); line-height: 1.3; }
    .capacity-section-grid .muted { color: var(--muted); }
    @media (max-width: 820px) {
      .capacity-section-grid.sections-3 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }
    @media (max-width: 560px) {
      .capacity-section-grid.sections-2,
      .capacity-section-grid.sections-3 { grid-template-columns: minmax(0, 1fr); }
      .capacity-specialty__header,
      .capacity-course-group { padding-right: 12px; padding-left: 12px; }
    }
  </style>
</head>
<body class="admin-page">
  <c:url var="backUrl" value="/AdminServlet" />
  <header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <a class="navbar-brand ctn-navbar-brand" href="${backUrl}">CTN Portal</a>
      </div>
    </div>
  </header>
  <main>
    <section class="container page-shell">
      <div class="admin-hero">
        <div>
          <span class="admin-eyebrow">Administración</span>
          <h1>Carga de ingresantes</h1>
          <p>Alta de nuevos alumnos por curso/sección con una meta orientativa de ${targetCapacity} alumnos.</p>
        </div>
        <a class="btn-secondary" href="${backUrl}">Volver al panel</a>
      </div>

      <c:if test="${not empty sessionScope.flashMessage}">
        <div class="alert alert-success">${sessionScope.flashMessage}</div>
        <c:remove var="flashMessage" scope="session" />
      </c:if>
      <c:if test="${not empty sessionScope.errors}">
        <div class="alert alert-danger">${sessionScope.errors[0]}</div>
        <c:remove var="errors" scope="session" />
      </c:if>
      <c:if test="${not empty sessionScope.warnings}">
        <div class="alert alert-warning">${sessionScope.warnings[0]}</div>
        <c:remove var="warnings" scope="session" />
      </c:if>

      <div class="capacity-groups">
        <c:forEach var="especialidadGroup" items="${cursosAgrupados}">
          <section class="capacity-specialty">
            <h2 class="capacity-specialty__header">
              <c:out value="${especialidadGroup.key}" />
            </h2>
            <c:forEach var="cursoGroup" items="${especialidadGroup.value}">
              <div class="capacity-course-group">
                <h3 class="capacity-course-group__title"><c:out value="${cursoGroup.key}" /> curso</h3>
                <div class="capacity-section-grid sections-${fn:length(cursoGroup.value) >= 3 ? '3' : fn:length(cursoGroup.value)}">
                  <c:forEach var="curso" items="${cursoGroup.value}">
                    <c:set var="status" value="${statusByCurso[curso.id]}" />
                    <article class="capacity-card ${status}">
                      <div class="capacity-v">
                        <c:out value="${curso.especialidad}" /> ·
                        <c:out value="${curso.cursoOrdinal}" /> ·
                        Sección <c:out value="${curso.seccion}" />
                      </div>
                      <div><strong><c:out value="${countsByCurso[curso.id]}" /></strong> alumnos cargados</div>
                      <div class="muted"><c:out value="${messageByCurso[curso.id]}" /></div>
                    </article>
                  </c:forEach>
                </div>
              </div>
            </c:forEach>
          </section>
        </c:forEach>
      </div>

      <form class="admin-card admin-form" method="post" action="${pageContext.request.contextPath}/AdminIngresantesServlet">
        <input type="hidden" name="action" value="crear" />
        <div class="form-group">
          <label for="nombre">Nombre</label>
          <input id="nombre" name="nombre" required class="form-control" />
        </div>
        <div class="form-group">
          <label for="apellido">Apellido</label>
          <input id="apellido" name="apellido" required class="form-control" />
        </div>
        <div class="form-group">
          <label for="ci">CI</label>
          <input id="ci" name="ci" class="form-control" />
        </div>
        <div class="form-group">
          <label for="cursoId">Curso / Sección</label>
          <select id="cursoId" name="cursoId" class="form-control" required>
            <option value="">Seleccionar</option>
            <c:forEach var="curso" items="${cursos}">
              <option value="${curso.id}">${curso.especialidad} · ${curso.cursoOrdinal} · Sección ${curso.seccion}</option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group">
          <label for="correoEncargado">Correo del encargado</label>
          <input id="correoEncargado" name="correoEncargado" class="form-control" />
        </div>
        <div class="form-group">
          <label for="correoEncargado2">Correo alternativo</label>
          <input id="correoEncargado2" name="correoEncargado2" class="form-control" />
        </div>
        <button class="btn btn-primary" type="submit">Crear alumno</button>
      </form>

      <div class="admin-card">
        <h3>Alumnos existentes</h3>
        <p class="muted">Podés editar nombre, apellido, CI, curso y correos directamente desde aquí.</p>
        <div class="filter-row">
          <div class="form-group">
            <label for="studentSearch">Buscar por nombre o apellido</label>
            <input id="studentSearch" class="form-control" placeholder="Ej. Ana" />
          </div>
          <div class="form-group">
            <label for="courseFilter">Filtrar por curso</label>
            <select id="courseFilter" class="form-control">
              <option value="">Todos los cursos</option>
              <c:forEach var="curso" items="${cursos}">
                <option value="${curso.id}">${curso.especialidad} · ${curso.cursoOrdinal} · Sección ${curso.seccion}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="capacity-grid" id="studentList">
          <c:forEach var="alumno" items="${alumnos}">
            <form class="capacity-card student-card" data-name="${alumno.apellido} ${alumno.nombre}" data-course="${alumno.cursoId}" method="post" action="${pageContext.request.contextPath}/AdminIngresantesServlet">
              <input type="hidden" name="action" value="editar" />
              <input type="hidden" name="alumnoId" value="${alumno.id}" />
              <div class="capacity-v">${alumno.apellido}, ${alumno.nombre}</div>
              <div class="form-group">
                <label>Nombre</label>
                <input name="nombre" class="form-control" value="${alumno.nombre}" required />
              </div>
              <div class="form-group">
                <label>Apellido</label>
                <input name="apellido" class="form-control" value="${alumno.apellido}" required />
              </div>
              <div class="form-group">
                <label>CI</label>
                <input name="ci" class="form-control" value="${alumno.ci}" />
              </div>
              <div class="form-group">
                <label>Curso / Sección</label>
                <select name="cursoId" class="form-control" required>
                  <c:forEach var="curso" items="${cursos}">
                    <option value="${curso.id}" ${curso.id == alumno.cursoId ? 'selected' : ''}>${curso.especialidad} · ${curso.cursoOrdinal} · Sección ${curso.seccion}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <label>Correo del encargado</label>
                <input name="correoEncargado" class="form-control" value="${alumno.correoEncargado}" />
              </div>
              <div class="form-group">
                <label>Correo alternativo</label>
                <input name="correoEncargado2" class="form-control" value="${alumno.correoEncargado2}" />
              </div>
              <button class="btn btn-primary" type="submit">Guardar</button>
            </form>
          </c:forEach>
        </div>
      </div>
    </section>
  </main>
  <script>
    const studentSearch = document.getElementById('studentSearch');
    const courseFilter = document.getElementById('courseFilter');
    const studentCards = Array.from(document.querySelectorAll('.student-card'));

    function applyStudentFilters() {
      const query = (studentSearch?.value || '').trim().toLowerCase();
      const courseValue = courseFilter?.value || '';

      studentCards.forEach(card => {
        const name = (card.dataset.name || '').toLowerCase();
        const course = card.dataset.course || '';
        const matchesQuery = !query || name.includes(query);
        const matchesCourse = !courseValue || course === courseValue;
        card.classList.toggle('hidden', !(matchesQuery && matchesCourse));
      });
    }

    studentSearch?.addEventListener('input', applyStudentFilters);
    courseFilter?.addEventListener('change', applyStudentFilters);
  </script>
</body>
</html>
