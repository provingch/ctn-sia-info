(function () {
  function normalizeSpecialty(value) {
    return String(value || '').trim().toLowerCase();
  }

  function getBodySpecialty() {
    return normalizeSpecialty(document.body ? document.body.getAttribute('data-specialty') : '');
  }

  function applyThemeFromAttr() {
    const html = document.documentElement;
    const body = document.body;
    const theme = html.getAttribute('data-theme') || (body && body.classList.contains('dark-mode') ? 'dark' : 'light');
    html.setAttribute('data-theme', theme);
    body && body.classList.toggle('dark-mode', theme === 'dark');
  }

  function getToggleIcon(isDark) {
    return isDark
      ? '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 3.75a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0V4.5A.75.75 0 0 1 12 3.75Zm0 14.5a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 12 18.25Zm8.25-6.25a.75.75 0 0 1 .75.75.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5Zm-14.5 0a.75.75 0 0 1 .75.75.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5Zm10.6-4.6a.75.75 0 0 1 1.06 0l1.06 1.06a.75.75 0 1 1-1.06 1.06l-1.06-1.06a.75.75 0 0 1 0-1.06Zm-9.4 9.4a.75.75 0 0 1 1.06 0l1.06 1.06a.75.75 0 1 1-1.06 1.06l-1.06-1.06a.75.75 0 0 1 0-1.06Zm0-9.4a.75.75 0 0 1 0 1.06l-1.06 1.06a.75.75 0 0 1-1.06-1.06l1.06-1.06a.75.75 0 0 1 1.06 0Zm9.4 9.4a.75.75 0 0 1 0 1.06l-1.06 1.06a.75.75 0 0 1-1.06-1.06l1.06-1.06a.75.75 0 0 1 1.06 0ZM12 7.5a4.5 4.5 0 1 0 0 9 4.5 4.5 0 0 0 0-9Z"/></svg>'
      : '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 0 0 9.79 9.79Z"/></svg>';
  }

  function ensureThemeToggle() {
    const existing = document.querySelector('.theme-toggle-button');
    if (existing) return existing;
    const rightSection = document.querySelector('.right-section');
    if (rightSection) {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'theme-toggle-button';
      button.setAttribute('aria-pressed', 'false');
      button.title = 'Cambiar tema';
      rightSection.insertBefore(button, rightSection.firstChild);
      return button;
    }
    return null;
  }

  function applyTheme(isDark) {
    document.documentElement.setAttribute('data-theme', isDark ? 'dark' : 'light');
    document.body.classList.toggle('dark-mode', isDark);
    const toggle = ensureThemeToggle();
    if (toggle) {
      toggle.setAttribute('aria-pressed', String(isDark));
      toggle.innerHTML = getToggleIcon(isDark);
      toggle.setAttribute('aria-label', isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro');
    }
  }

  const initial = (() => {
    const saved = localStorage.getItem('ctnDarkMode');
    if (saved === 'true') return true;
    if (saved === 'false') return false;
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  })();

  applyTheme(initial);
  const toggle = ensureThemeToggle();
  if (toggle) {
    toggle.addEventListener('click', function () {
      const next = document.documentElement.getAttribute('data-theme') !== 'dark';
      applyTheme(next);
      localStorage.setItem('ctnDarkMode', String(next));
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    const body = document.body;
    if (body) {
      const specialty = getBodySpecialty();
      if (specialty) {
        body.setAttribute('data-specialty', specialty);
      }
    }
    applyThemeFromAttr();
  });
})();
