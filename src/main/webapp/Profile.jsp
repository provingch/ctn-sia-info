<%-- 
    Document   : Profile
    Created on : Sep 15, 2025, 6:08:05 PM
    Author     : jonat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>

<head>
  <title>Mi Perfil</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <link rel="stylesheet" href="styles/header.css">
  <link rel="stylesheet" href="styles/home-header.css">
  <link rel="stylesheet" href="styles/general.css">
  <link rel="stylesheet" href="styles/tareas-general.css">
  <link rel="stylesheet" href="styles/top-section.css">
  <link rel="stylesheet" href="styles/tareas-grid.css">
  <link rel="stylesheet" href="styles/buttons.css">
  <link rel="stylesheet" href="styles/flash.css">
  <link rel="stylesheet" href="styles/profile-grid.css">
  <link rel="icon" type="image/x-icon" href="images/ctn-logo.svg">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
    rel="stylesheet">
</head>

<body>
  <header><!-- TODO turn this into navbar -->
    <div class="header-logo-container">
      <img class="header-logo" src="images/ctn-logo.svg">
    </div>
    <div class="header-school-name">
      Colegio Técnico Nacional
    </div>
    <c:url var="profileUrl" value="/ProfileServlet" />
    <c:url var="logoutUrl" value="/LogoutServlet" />

    <div class="right-section">
      <div class="manual-container">
        <a class="manual-link" href="pdfs/manual.pdf" target="_blank">Manual</a>
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
    <section class="container">
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

      <h1>Mis Datos</h1>

      <form id="profileForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post">

        <div class="profile-grid">
          <div class="table-header">${sessionScope.user.fullName}</div>
          <div class="cell">
            ${profesor.fullName}
          </div>

          <div class="table-header">Cédula</div>
          <div class="cell">
            ${profesor.ci}
          </div>

          <div class="table-header">Correo</div>
          <div class="cell">
            <input
              type="email"
              name="correo"
              value="${profesor.correo}" />
          </div>

          <div class="table-header">Telefono</div>
          <div class="cell">
            <input
              class="no-spinner"
              type="number"
              name="telefono"
              value="${profesor.telefono}" />
          </div>

          <div class="table-header">Celular</div>
          <div class="cell">
            <input
              class="no-spinner"
              type="number"
              name="celular"
              value="${profesor.celular}" />
          </div>

          <div class="table-header">Usuario del Sistema</div>
          <div class="cell">
            <input type="text" name="usuario" value="${profesor.usuario}" />
          </div>

          <div class="table-header">Google Classroom</div>
          <div class="cell">
            <c:url var="googleConnectUrl" value="/GoogleLoginServlet" />
            <c:choose>
              <c:when test="${not empty profesor.googleEmail}">
                <div class="google-connected">
                  Conectado como <strong><c:out value="${profesor.googleEmail}"/></strong>
                </div>
                <div class="google-help">Para reconectar, haga clic en el botón de abajo.</div>
                <a class="google-connect-button" href="${pageContext.request.contextPath}${googleConnectUrl}">
                  Reconectar Google Classroom
                </a>
              </c:when>
              <c:otherwise>
                <div class="google-disconnected">No conectado a Google Classroom.</div>
                <a class="google-connect-button" href="${pageContext.request.contextPath}${googleConnectUrl}">
                  Conectar con Google Classroom
                </a>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="buttons-row table-header">

            <c:url var="HomeUrl" value="/HomeServlet" />

            <div class="button-group">
              <!-- Back link (anchor) — not a form submit -->
              <a id="backBtn" class="back-button" href="${HomeUrl}">
                <img class="back-icon" src="${pageContext.request.contextPath}/icons/back-arrow.svg" alt="Atrás">
                Atrás
              </a>

              <button class="save-button" id="saveBtn" type="submit">
                <img class="save-icon" src="${pageContext.request.contextPath}/icons/add.svg">
                Grabar
              </button>

            </div>

          </div>
        </div>
      </form>


    </section>
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

<script>
  (function () {
    // Find the main planilla form. Adjust selector if necessary.
    const form = document.querySelector('form[action$="/ProfileServlet"]') || document.querySelector('form');
    let dirty = false;

    if (form) {
      // Mark dirty when inputs change
      form.addEventListener('input', () => { dirty = true; });
      form.addEventListener('change', () => { dirty = true; });

      // When the user submits (saves), clear dirty
      form.addEventListener('submit', () => { dirty = false; });
    }

    const backBtn = document.getElementById('backBtn');
    if (backBtn) {
      backBtn.addEventListener('click', function (e) {
        if (dirty) {
          // warn and optionally block navigation
          const leave = confirm('Hay cambios sin guardar. ¿Deseas salir sin guardar?');
          if (!leave) {
            e.preventDefault();
          }
        }
      });
    }

    // Prevent accidental tab/window close if dirty
    window.addEventListener('beforeunload', function (e) {
      if (dirty) {
        e.preventDefault();
        // modern browsers ignore the custom message, returning non-empty value is enough
        e.returnValue = '';
      }
    });
  })();
</script>

<script>
(function () {
  const nodes = document.querySelectorAll('.flash, .flash-errors');
  if (!nodes.length) return;

  nodes.forEach(function (el) {
    let timeoutMs = parseInt(el.dataset.timeout, 10);
    if (!Number.isFinite(timeoutMs)) timeoutMs = 4000;

    // start timer
    let timer = setTimeout(() => {
      if (el.classList.contains('flash')) el.classList.add('flash--hide');
      else el.classList.add('flash-errors--hide');
    }, timeoutMs);

    // cleanup after transition
    el.addEventListener('transitionend', function (ev) {
      if (ev.propertyName === 'opacity' || ev.propertyName === 'max-height') {
        try { el.remove(); } catch (e) {}
      }
    });

    // pause on hover (optional nicety)
    el.addEventListener('mouseenter', () => clearTimeout(timer));

    // close button
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

<script>
document.getElementById("saveBtn").addEventListener("click", function(){
    document.getElementById("profileForm").className="submitted";
});
</script>


</body>

</html>