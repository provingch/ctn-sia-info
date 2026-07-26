(function () {
  const CONSENT_KEY = 'SIA_COOKIE_CONSENT';
  const banner = document.getElementById('cookieConsent');
  const acceptBtn = document.getElementById('acceptCookies');
  const declineBtn = document.getElementById('declineCookies');

  if (!banner || !acceptBtn || !declineBtn) {
    return;
  }

  function readCookie(name) {
    const match = document.cookie.match(new RegExp('(?:^|; )' + name.replace(/([.$?*|{}()[\]\\/+^])/g, '\\$1') + '=([^;]*)'));
    return match ? decodeURIComponent(match[1]) : null;
  }

  function readStoredConsent() {
    try {
      const stored = window.localStorage.getItem(CONSENT_KEY);
      if (stored === 'accepted' || stored === 'declined') {
        return stored;
      }
    } catch (error) {
      // Ignore storage access issues and fall back to cookies.
    }

    const cookieValue = readCookie(CONSENT_KEY);
    return cookieValue === 'accepted' || cookieValue === 'declined' ? cookieValue : null;
  }

  function writeStoredConsent(accepted) {
    const value = accepted ? 'accepted' : 'declined';
    try {
      window.localStorage.setItem(CONSENT_KEY, value);
    } catch (error) {
      // Ignore storage access issues and keep the cookie fallback.
    }

    document.cookie = `${CONSENT_KEY}=${encodeURIComponent(value)}; path=/; max-age=31536000; SameSite=Lax`;
  }

  function hideBanner() {
    banner.classList.add('hidden');
  }

  function showBanner() {
    banner.classList.remove('hidden');
  }

  function hasConsentDecision() {
    const stored = readStoredConsent();
    return stored === 'accepted' || stored === 'declined';
  }

  function hasConsent() {
    return readStoredConsent() === 'accepted';
  }

  function updateBannerVisibility() {
    const rememberInput = document.querySelector('input[name="rememberMe"]');
    if (!rememberInput) {
      hideBanner();
      return;
    }

    if (hasConsentDecision()) {
      hideBanner();
      return;
    }

    if (rememberInput.checked) {
      showBanner();
    } else {
      hideBanner();
    }
  }

  function disableRememberIfDeclined() {
    const rememberInput = document.querySelector('input[name="rememberMe"]');
    if (!rememberInput) {
      return;
    }
    if (readStoredConsent() === 'declined') {
      rememberInput.checked = false;
    }
  }

  updateBannerVisibility();
  disableRememberIfDeclined();

  const rememberInput = document.querySelector('input[name="rememberMe"]');
  if (rememberInput) {
    rememberInput.addEventListener('change', updateBannerVisibility);
  }

  const loginForm = document.querySelector('.login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', function (event) {
      if (rememberInput && rememberInput.checked && !hasConsentDecision()) {
        event.preventDefault();
        showBanner();
      }
      if (rememberInput && rememberInput.checked && readStoredConsent() === 'declined') {
        rememberInput.checked = false;
      }
    });
  }

  acceptBtn.addEventListener('click', function () {
    writeStoredConsent(true);
    hideBanner();
  });

  declineBtn.addEventListener('click', function () {
    writeStoredConsent(false);
    disableRememberIfDeclined();
    hideBanner();
  });
})();
