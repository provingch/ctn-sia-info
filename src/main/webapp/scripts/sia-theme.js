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

  function ensureThemeToggle() {
    const existing = document.querySelector('.theme-toggle-button');
    if (existing) return existing;
    const rightSection = document.querySelector('.right-section');
    if (rightSection) {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'theme-toggle-button';
      button.setAttribute('aria-pressed', 'false');
      button.textContent = 'Tema';
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
      toggle.textContent = isDark ? 'Claro' : 'Oscuro';
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
