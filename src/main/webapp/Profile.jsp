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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css?v=163">
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  <style>
  .page-heading h1 {
    margin: 0;
    font-size: clamp(1.6rem, 2.6vw, 2.2rem);
  }
  .page-subtitle {
    margin-top: 0.65rem;
    color: var(--muted);
    max-width: 48rem;
  }
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
            <span>Perfil institucional</span>
          </div>
        </div>
        <div class="tb-right">
          <div class="tb-cell"><b>Usuario</b>${sessionScope.user.fullName}</div>
          <div class="tb-cell"><b>Especialidad</b><span>${sessionScope.siaSpecialty}</span></div>
          <div class="tb-cell"><b>Rol</b><span>${sessionScope.user.level == 1 ? 'Profesor' : sessionScope.user.level == 2 ? 'Administrador' : sessionScope.user.level == 4 ? 'Padre' : ''}</span></div>
          <div class="tb-cell"><b>Fecha</b><c:out value="${nowFormatted}" /></div>
        </div>
      </div>
      <div class="info-bar">
        <span>Bienvenido/a ${sessionScope.user.fullName}</span>
        <span>
          <c:out value="${nowFormatted}" />
        </span>
      </div>
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
        <c:remove var="flashErrors" scope="session"/>
      </c:if>

      <div class="profile-layout">
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
                  <div class="table-card card">
                    <div class="table-header">Datos del Profesor</div>
                    <div class="cell"><strong>Nombre</strong></div>
                    <div class="cell">${profesor.fullName}</div>
                    <div class="cell"><strong>Cédula</strong></div>
                    <div class="cell">${profesor.ci}</div>
                    <div class="cell"><strong>Correo</strong></div>
                    <div class="cell">
                      <input type="email" name="correo" value="${profesor.correo}" />
                    </div>
                    <div class="cell"><strong>Teléfono</strong></div>
                    <div class="cell">
                      <input class="no-spinner" type="number" name="telefono" value="${profesor.telefono}" />
                    </div>
                    <div class="cell"><strong>Celular</strong></div>
                    <div class="cell">
                      <input class="no-spinner" type="number" name="celular" value="${profesor.celular}" />
                    </div>
                    <div class="cell"><strong>Usuario</strong></div>
                    <div class="cell">
                      <input type="text" name="usuario" value="${profesor.usuario}" />
                    </div>
                  </div>
                  <div class="table-card card">
                    <div class="table-header">Google Classroom</div>
                    <c:url var="googleConnectUrl" value="/GoogleLoginServlet" />
                    <c:url var="googleDisconnectUrl" value="/GoogleDisconnectServlet" />
                    <c:choose>
                      <c:when test="${not empty profesor.googleEmail or not empty profesor.gcAccessToken}">
                        <div class="google-connected">Conectado como <strong><c:out value="${profesor.googleEmail}"/></strong></div>
                        <div class="google-help selection-hint">Puedes reconectar o desconectar tu cuenta.</div>
                        <div class="action-row">
                          <a class="btn-primary google-connect-button" href="${pageContext.request.contextPath}${googleConnectUrl}">Reconectar Classroom</a>
                          <button class="btn-danger google-disconnect-button" type="submit" form="googleDisconnectForm">Desconectar</button>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="google-disconnected selection-hint">No conectado a Google Classroom.</div>
                        <a class="btn-primary google-connect-button" href="${pageContext.request.contextPath}${googleConnectUrl}">Conectar Classroom</a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="table-card table-card--wide card">
                    <div class="table-header">Acciones</div>
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
          <form id="subjectForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" class="subject-list" data-status-target="subjectSaveStatus">
            <input type="hidden" name="action" value="saveManualSubjects" />
            <div class="table-card table-card--wide card">
              <div class="table-header">Cargar materia</div>
              <div class="subject-form-grid">
                <div class="cell subject-form-cell">
                  <label for="materiaNombre" class="selection-hint">Nombre de la materia</label>
                  <input id="materiaNombre" name="materiaNombre" type="text" placeholder="Ej. Programación" autocomplete="off" maxlength="120" required style="width:100%;" />
                </div>
                <div class="cell subject-form-cell">
                  <label for="categoria" class="selection-hint">Categoría</label>
                  <select id="categoria" name="categoria" style="width:100%;">
                    <option value="comun">Común</option>
                    <option value="especifico">Específica</option>
                  </select>
                </div>
                <div class="cell subject-form-cell subject-form-cell--wide">
                  <label class="selection-hint">Especialidades</label>
                  <div id="especialidadesContainer" class="checkbox-grid">
                    <c:forEach var="especialidad" items="${especialidades}">
                      <label class="checkbox-item">
                        <input type="checkbox" name="especialidades" value="${especialidad.id}" />
                        <span><c:out value="${especialidad.nombre}" /></span>
                      </label>
                    </c:forEach>
                  </div>
                  <div class="selection-hint">Si la materia es común, selecciona al menos una especialidad.</div>
                </div>
                <div class="cell subject-form-cell subject-form-cell--actions">
                  <button class="btn-primary save-button" type="submit">Guardar materia</button>
                  <span id="subjectSaveStatus" class="save-status" aria-live="polite">Listo para guardar.</span>
                </div>
              </div>
            </div>
            <div class="table-card table-card--wide card">
              <div class="table-header">Materias disponibles</div>
              <div id="teacherMateriaList" class="subject-list-grid">
                <c:choose>
                  <c:when test="${empty teacherMaterias}">
                    <p class="empty-state">Todavía no hay materias registradas.</p>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="subject" items="${teacherMaterias}">
                      <div class="subject-item">
                        <span><c:out value="${subject.nombre}" /></span>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </form>
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

  button.addEventListener('click', function (e) {
    e.stopPropagation();
    if (dropdown.classList.contains('open')) closeMenu();
    else openMenu();
  });

  document.addEventListener('click', function (e) {
    if (!dropdown.contains(e.target)) closeMenu();
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeMenu();
  });

  menu.addEventListener('click', function (e) {
    const t = e.target;
    if (t.matches('a')) {
      closeMenu();
    }
  });
})();
</script>

<script>
(function () {
  const tabs = document.querySelectorAll('.profile-tab');
  const panels = document.querySelectorAll('.profile-panel');

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
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
    });
  });
})();
</script>

<script>
(function () {
  const profileForm = document.getElementById('profileForm');
  const subjectForm = document.getElementById('subjectForm');

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

  function normalizeSubjectName(value) {
    return (value || '').trim().replace(/\s+/g, ' ');
  }

  function validateSubjectForm(form) {
    const materiaInput = form.querySelector('#materiaNombre');
    const categoriaSelect = form.querySelector('#categoria');
    const materiaNombre = normalizeSubjectName(materiaInput ? materiaInput.value : '');
    if (!materiaNombre) {
      return 'Completa el nombre de la materia antes de guardar.';
    }
    if (materiaNombre.length < 2) {
      return 'El nombre de la materia es demasiado corto.';
    }
    if (!/^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 .\-]+$/.test(materiaNombre)) {
      return 'El nombre de la materia solo puede contener letras, números, espacios y guiones.';
    }

    const isCommon = categoriaSelect && categoriaSelect.value === 'comun';
    const selectedSpecialties = Array.from(form.querySelectorAll('input[name="especialidades"]:checked'));
    if (isCommon && selectedSpecialties.length < 1) {
      return 'Las materias comunes deben tener al menos una especialidad asociada.';
    }
    if (!isCommon && selectedSpecialties.length !== 1) {
      return 'Las materias específicas deben tener exactamente una especialidad asociada.';
    }

    return '';
  }

  function syncSubjectFormState(form) {
    const categoriaSelect = form.querySelector('#categoria');
    const isCommon = categoriaSelect && categoriaSelect.value === 'comun';
    const specialtyChecks = Array.from(form.querySelectorAll('input[name="especialidades"]'));

    specialtyChecks.forEach(function (checkbox) {
      checkbox.disabled = false;
      if (!isCommon && checkbox.checked) {
        const checkedNodes = specialtyChecks.filter(function (item) {
          return item.checked;
        });
        if (checkedNodes.length > 1) {
          checkbox.checked = false;
        }
      }
    });
  }

  function submitWithFetch(form, statusId, successMessage, isSubjectForm) {
    const statusEl = document.getElementById(statusId);
    if (isSubjectForm) {
      const validationError = validateSubjectForm(form);
      if (validationError) {
        setStatus(statusEl, validationError, 'is-error');
        return;
      }
    }

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

      if (isSubjectForm) {
        const materiaInput = document.getElementById('materiaNombre');
        const materiaNombre = normalizeSubjectName(materiaInput ? materiaInput.value : '');
        if (materiaNombre) {
          const container = document.getElementById('teacherMateriaList');
          if (container) {
            const emptyMessage = container.querySelector('.empty-state');
            if (emptyMessage) emptyMessage.remove();
            const existing = Array.from(container.querySelectorAll('.subject-item span')).some(function (node) {
              return node.textContent.trim().toLowerCase() === materiaNombre.toLowerCase();
            });
            if (!existing) {
              const subjectItem = document.createElement('div');
              subjectItem.className = 'subject-item';
              subjectItem.innerHTML = '<span>' + materiaNombre.replace(/[<>]/g, '') + '</span>';
              container.appendChild(subjectItem);
            }
          }
        }
        subjectForm.reset();
        syncSubjectFormState(subjectForm);
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
      if (!['correo', 'telefono', 'celular', 'usuario'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileForm.addEventListener('change', function (event) {
      if (!['correo', 'telefono', 'celular', 'usuario'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileStatus && setStatus(profileStatus, 'Guardado automático activo.', 'is-success');
  }

  if (subjectForm) {
    const subjectStatus = document.getElementById('subjectSaveStatus');
    syncSubjectFormState(subjectForm);

    subjectForm.addEventListener('change', function (event) {
      if (event.target && event.target.id === 'categoria') {
        syncSubjectFormState(subjectForm);
      }
    });

    subjectForm.addEventListener('submit', function (event) {
      event.preventDefault();
      submitWithFetch(subjectForm, 'subjectSaveStatus', 'Materia guardada.', true);
    });

    subjectStatus && setStatus(subjectStatus, 'Listo para guardar.', 'is-success');
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

<script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>
</body>

</html>