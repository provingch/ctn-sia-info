<%-- 
    Document   : Profile
    Created on : Sep 15, 2025, 6:08:05 PM
    Author     : jonat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html data-theme="light">

<head>
  <title>Mi Perfil</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=204">
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  <style>
  .inline-form {
    display: inline-block;
    margin: 0;
  }
  .activity-log ul {
    margin: 0;
    padding-left: 1.2rem;
    display: grid;
    gap: 0.6rem;
  }
  @media (max-width: 900px) {
    .profile-tabs {
      flex-direction: row;
      overflow-x: auto;
      gap: 0.75rem;
      padding-bottom: 0.5rem;
    }
    .profile-tab {
      flex: 1 0 auto;
      border-radius: var(--radius);
      border: 1px solid var(--line);
    }
  }
  </style>
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

      <c:if test="${not empty sessionScope.flashMessage}">
        <div class="flash" data-timeout="4000">
          ${sessionScope.flashMessage}
          <button type="button" class="flash-close" aria-label="Cerrar mensaje">&times;</button>
        </div>
        <c:remove var="flashMessage" scope="session"/>
      </c:if>

      <c:if test="${not empty errors}">
        <c:forEach var="err" items="${errors}">
            <div class="flash-errors" data-timeout="4000">
              <c:out value="${err}" />
              <button type="button" class="flash-close" aria-label="Cerrar mensajes de error">&times;</button>
            </div>
        </c:forEach>
        <c:remove var="errors" scope="session"/>
      </c:if>

      <div class="profile-layout">
        <div class="profile-shell">
          <aside class="profile-sidebar" aria-label="Navegación de perfil">
            <div class="profile-tabs" role="tablist" aria-label="Secciones del perfil">
              <button type="button" class="profile-tab active" data-target="perfil-panel">Perfil</button>
              <button type="button" class="profile-tab" data-target="seguridad-panel">Seguridad</button>
              <button type="button" class="profile-tab" data-target="materias-panel">Materias</button>
              <button type="button" class="profile-tab" data-target="registros-panel">Registros</button>
            </div>
          </aside>
          <div class="profile-content">
          <div class="profile-panels">
            <section id="perfil-panel" class="profile-panel active">
              <form id="profileForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" data-status-target="profileSaveStatus">
                <input type="hidden" name="action" value="saveProfile" />
                <div class="profile-grid profile-grid-layout">
                  <div class="form-card card">
                    <div class="form-card-header">Información Personal</div>
                    <div class="form-field">
                      <label for="profesorName">Nombre</label>
                      <input type="text" id="profesorName" value="${profesor.fullName}" disabled />
                    </div>
                    <div class="form-field">
                      <label for="profesorCI">Cédula</label>
                      <input type="text" id="profesorCI" value="${profesor.ci}" disabled />
                    </div>
                  </div>
                  <div class="form-card card">
                    <div class="form-card-header">Contacto</div>
                    <div class="form-field">
                      <label for="correo">Correo electrónico</label>
                      <input type="email" id="correo" name="correo" value="${profesor.correo}" />
                    </div>
                    <div class="form-field">
                      <label for="telefono">Teléfono</label>
                      <input class="no-spinner" type="number" id="telefono" name="telefono" value="${profesor.telefono}" />
                    </div>
                    <div class="form-field">
                      <label for="celular">Celular</label>
                      <input class="no-spinner" type="number" id="celular" name="celular" value="${profesor.celular}" />
                    </div>
                  </div>
                  <div class="form-card card">
                    <div class="form-card-header">Cuenta</div>
                    <div class="form-field">
                      <label for="usuario">Usuario</label>
                      <input type="text" id="usuario" name="usuario" value="${profesor.usuario}" />
                    </div>
                    <div class="form-field">
                      <label for="especialidadId">Especialidad personal</label>
                      <select id="especialidadId" name="especialidadId">
                        <option value="">-- Sin especialidad --</option>
                        <c:forEach var="e" items="${especialidades}">
                          <option value="${e.id}" ${profesor.especialidadId != null && profesor.especialidadId == e.id ? 'selected' : ''}>
                            <c:out value="${e.nombre}" />
                          </option>
                        </c:forEach>
                      </select>
                    </div>
                  </div>
                  <div class="form-card card">
                    <div class="form-card-header">Google Classroom</div>
                    <c:url var="googleConnectUrl" value="/GoogleLoginServlet" />
                    <c:url var="googleDisconnectUrl" value="/GoogleDisconnectServlet" />
                    <c:choose>
                      <c:when test="${not empty profesor.googleEmail or not empty profesor.gcAccessToken}">
                        <div class="classroom-status classroom-status--connected">Conectado como <strong><c:out value="${profesor.googleEmail}"/></strong></div>
                        <div class="classroom-actions">
                          <a class="btn-primary" href="${pageContext.request.contextPath}${googleConnectUrl}">Reconectar</a>
                          <button class="btn-danger" type="submit" form="googleDisconnectForm">Desconectar</button>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="classroom-status classroom-status--disconnected">No conectado a Google Classroom</div>
                        <a class="btn-primary" href="${pageContext.request.contextPath}${googleConnectUrl}">Conectar ahora</a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="form-card form-card--actions card">
                    <div class="action-row">
                      <c:url var="HomeUrl" value="/HomeServlet" />
                      <a id="backBtn" class="back-button" href="${HomeUrl}">
                        <img class="back-icon" src="${pageContext.request.contextPath}/icons/back-arrow.svg" alt="Atrás">
                        Volver al inicio
                      </a>
                      <span id="profileSaveStatus" class="save-status" aria-live="polite">Guardado automático activo.</span>
                    </div>
                  </div>
                </div>
              </form>
              <form id="googleDisconnectForm" action="${pageContext.request.contextPath}${googleDisconnectUrl}" method="post" style="display:none;"></form>
            </section>

            <section id="seguridad-panel" class="profile-panel">
              <form id="securityForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" data-status-target="securitySaveStatus">
                <input type="hidden" name="action" value="changePassword" />
                <div class="profile-grid profile-grid-layout">
                  <div class="table-card card">
                    <div class="table-header">Cambiar Contraseña</div>
                    <div class="cell"><strong>Contraseña Actual</strong></div>
                    <div class="cell">
                      <input type="password" name="currentPassword" id="currentPassword" required />
                    </div>
                    <div class="cell"><strong>Nueva Contraseña</strong></div>
                    <div class="cell">
                      <input type="password" name="newPassword" id="newPassword" required />
                    </div>
                    <div class="cell"><strong>Confirmar Contraseña</strong></div>
                    <div class="cell">
                      <input type="password" name="confirmPassword" id="confirmPassword" required />
                    </div>
                    <div class="cell selection-hint" style="grid-column: 1 / -1;">
                      La contraseña debe tener al menos 6 caracteres.
                    </div>
                    <div class="cell" style="grid-column: 1 / -1;">
                      <button class="btn-primary save-button" type="submit">Cambiar Contraseña</button>
                      <span id="securitySaveStatus" class="save-status" aria-live="polite">Listo.</span>
                    </div>
                  </div>
                </div>
              </form>
            </section>

        <section id="materias-panel" class="profile-panel">
          <div class="table-card table-card--wide card">
            <div class="table-header">Asignaciones de materias</div>
            <div class="subject-list-grid">
              <c:choose>
                <c:when test="${empty misAsignaciones}">
                  <p class="empty-state">No hay asignaciones de materias registradas.</p>
                </c:when>
                <c:otherwise>
                  <div class="subject-list-header" style="display:grid;grid-template-columns:1.5fr 1fr;gap:1rem;font-weight:600;padding:0.75rem 1rem;border-bottom:1px solid var(--line);">
                    <span>Materia</span>
                    <span>Curso</span>
                  </div>
                  <c:forEach var="asignacion" items="${misAsignaciones}">
                    <div class="subject-item" style="display:grid;grid-template-columns:1.5fr 1fr;gap:1rem;align-items:center;padding:0.9rem 1rem;border-bottom:1px solid var(--line);">
                      <span><c:out value="${asignacion.materiaNombre}" /></span>
                      <span><c:out value="${asignacion.cursoDescripcion}" /></span>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </section>

        <section id="registros-panel" class="profile-panel">
          <div class="activity-log">
            <c:choose>
              <c:when test="${empty activityLog}">
                <p class="empty-state">Aún no hay movimientos registrados.</p>
              </c:when>
              <c:otherwise>
                <ul>
                  <c:forEach var="entry" items="${activityLog}">
                    <li><c:out value="${entry}" /></li>
                  </c:forEach>
                </ul>
              </c:otherwise>
            </c:choose>
          </div>
        </section>
      </div>
    </div>
  </div>
  </div>


    </section>

    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
  </main>

<script>
(function () {
  const tabs = document.querySelectorAll('.profile-tab');
  const panels = document.querySelectorAll('.profile-panel');
  const storageKey = 'ctn-profile-active-tab';

  function activateTab(tab) {
    tabs.forEach(function (item) {
      item.classList.remove('active');
    });
    panels.forEach(function (panel) {
      panel.classList.remove('active');
    });
    tab.classList.add('active');
    const target = document.getElementById(tab.dataset.target);
    if (target) {
      target.classList.add('active');
    }
    try {
      localStorage.setItem(storageKey, tab.dataset.target);
    } catch (e) {
      // ignore localStorage failures
    }
  }

  const savedTarget = (() => {
    try {
      return localStorage.getItem(storageKey);
    } catch (e) {
      return null;
    }
  })();
  const initialTab = Array.from(tabs).find(function (t) {
    return t.dataset.target === savedTarget;
  }) || tabs[0];
  if (initialTab) {
    activateTab(initialTab);
  }

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
      activateTab(tab);
    });
  });
})();
</script>

<script>
(function () {
  const profileForm = document.getElementById('profileForm');
  const securityForm = document.getElementById('securityForm');

  function resolveAjaxPayload(responseText, response) {
    const contentType = response.headers.get('content-type') || '';
    if (contentType.includes('application/json')) {
      try {
        return JSON.parse(responseText);
      } catch (e) {
        return { success: response.ok, message: responseText || 'Operación completada.' };
      }
    }
    return { success: response.ok, message: responseText || 'Operación completada.' };
  }

  function setStatus(el, message, tone) {
    if (!el) return;
    el.textContent = message;
    el.className = 'save-status ' + tone;
  }

  function submitWithFetch(form, statusId, successMessage, isSecurityForm) {
    const statusEl = document.getElementById(statusId);

    const formData = new FormData(form);
    const body = new URLSearchParams();
    for (const [key, value] of formData.entries()) {
      body.append(key, value);
    }
    setStatus(statusEl, 'Guardando...', 'is-saving');

    fetch(form.getAttribute('action'), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: body
    }).then(async function (response) {
      const responseText = await response.text();
      const payload = resolveAjaxPayload(responseText, response);
      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'No se pudo guardar la información.');
      }

      if (isSecurityForm) {
        ['currentPassword', 'newPassword', 'confirmPassword'].forEach(function (id) {
          const input = document.getElementById(id);
          if (input) input.value = '';
        });
      }

      setStatus(statusEl, payload.message || successMessage, 'is-success');
    }).catch(function (error) {
      setStatus(statusEl, error.message || 'No se pudo guardar.', 'is-error');
    });
  }

  if (profileForm) {
    let autoSaveTimer;
    const profileStatus = document.getElementById('profileSaveStatus');
    function scheduleProfileSave() {
      clearTimeout(autoSaveTimer);
      autoSaveTimer = setTimeout(function () {
        submitWithFetch(profileForm, 'profileSaveStatus', 'Datos guardados.', false);
      }, 800);
    }

    profileForm.addEventListener('input', function (event) {
      if (!['correo', 'telefono', 'celular', 'usuario', 'especialidadId'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileForm.addEventListener('change', function (event) {
      if (!['correo', 'telefono', 'celular', 'usuario', 'especialidadId'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileStatus && setStatus(profileStatus, 'Guardado automático activo.', 'is-success');
  }

  if (securityForm) {
    const securityStatus = document.getElementById('securitySaveStatus');
    securityForm.addEventListener('submit', function (event) {
      event.preventDefault();
      submitWithFetch(securityForm, 'securitySaveStatus', 'Contraseña actualizada.', true);
    });
    securityStatus && setStatus(securityStatus, 'Listo para guardar.', 'is-success');
  }
})();
</script>

<script>
(function () {
  const nodes = document.querySelectorAll('.flash, .flash-errors');
  if (!nodes.length) return;

  nodes.forEach(function (el) {
    let timeoutMs = parseInt(el.dataset.timeout, 10);
    if (!Number.isFinite(timeoutMs)) timeoutMs = 4000;

    let timer = setTimeout(() => {
      if (el.classList.contains('flash')) el.classList.add('flash--hide');
      else el.classList.add('flash-errors--hide');
    }, timeoutMs);

    el.addEventListener('transitionend', function (ev) {
      if (ev.propertyName === 'opacity' || ev.propertyName === 'max-height') {
        try { el.remove(); } catch (e) {}
      }
    });

    el.addEventListener('mouseenter', () => clearTimeout(timer));

    const closeBtn = el.querySelector('.flash-close');
    if (closeBtn) {
      closeBtn.addEventListener('click', function (e) {
        e.preventDefault();
        clearTimeout(timer);
        if (el.classList.contains('flash')) el.classList.add('flash--hide');
        else el.classList.add('flash-errors--hide');
      });
    }
  });
})();
</script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
</body>

</html>
