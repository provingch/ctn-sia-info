(function () {
  const storageKey = 'ctnDarkMode';

  const moonIcon =
    '<svg class="theme-icon theme-icon-moon" viewBox="0 0 24 24" aria-hidden="true">' +
    '<path d="M12 3a9 9 0 1 0 9 9c0-.46-.04-.92-.1-1.36a5.389 5.389 0 0 1-4.4 2.26 5.403 5.403 0 0 1-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/>' +
    '</svg>';

  const sunIcon =
    '<svg class="theme-icon theme-icon-sun" viewBox="0 0 24 24" aria-hidden="true">' +
    '<path d="M12 18a6 6 0 1 1 0-12 6 6 0 0 1 0 12zm0-2a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM11 1h2v3h-2V1zm0 19h2v3h-2v-3zM3.515 4.929l1.414-1.414L7.05 5.636 5.636 7.05 3.515 4.93zM16.95 18.364l1.414-1.414 2.121 2.121-1.414 1.414-2.121-2.121zm2.121-14.85l1.414 1.415-2.121 2.121-1.414-1.414 2.121-2.121zM7.05 16.95l1.414 1.414-2.121 2.121-1.414-1.414L7.05 16.95zM23 11v2h-3v-2h3zM4 11v2H1v-2h3z"/>' +
    '</svg>';

  function createToggleButton() {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'theme-toggle-button';
    button.setAttribute('aria-pressed', 'false');
    button.innerHTML = moonIcon + sunIcon;
    return button;
  }

  function ensureToggles() {
    const toggles = Array.from(document.querySelectorAll('.theme-toggle-button'));
    if (toggles.length > 0) {
      return toggles;
    }

    const rightSection = document.querySelector('.right-section');
    if (rightSection) {
      const toggle = createToggleButton();
      rightSection.insertBefore(toggle, rightSection.firstChild);
      return [toggle];
    }

    const header = document.querySelector('header');
    if (header) {
      const toggle = createToggleButton();
      header.appendChild(toggle);
      return [toggle];
    }

    return [];
  }

  function getInitialMode() {
    const savedMode = localStorage.getItem(storageKey);
    if (savedMode === 'true') return true;
    if (savedMode === 'false') return false;
    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  }

  function applyMode(isDark) {
    document.body.classList.toggle('dark-mode', isDark);
    const toggles = ensureToggles();
    toggles.forEach(function (toggle) {
      toggle.setAttribute('aria-pressed', String(isDark));
      toggle.setAttribute(
        'aria-label',
        isDark ? 'Activar modo claro' : 'Activar modo oscuro'
      );
      toggle.setAttribute('title', isDark ? 'Modo claro' : 'Modo oscuro');
    });
  }

  const toggles = ensureToggles();
  applyMode(getInitialMode());

  toggles.forEach(function (toggle) {
    toggle.addEventListener('click', function () {
      const nextMode = !document.body.classList.contains('dark-mode');
      applyMode(nextMode);
      localStorage.setItem(storageKey, String(nextMode));
    });
  });

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (event) {
    if (localStorage.getItem(storageKey) === null) {
      applyMode(event.matches);
    }
  });
})();
