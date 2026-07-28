<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html data-theme="light">
<head>
  <title>CTNPortal - Ingresantes</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=233" />
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

      <div class="capacity-grid">
        <c:forEach var="curso" items="${cursos}">
          <c:set var="status" value="${statusByCurso[curso.id]}" />
          <div class="capacity-card ${status}">
            <div class="capacity-v">${curso.especialidad} · ${curso.cursoOrdinal} · Sección ${curso.seccion}</div>
            <div><strong>${countsByCurso[curso.id]}</strong> alumnos cargados</div>
            <div class="muted">${messageByCurso[curso.id]}</div>
          </div>
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
