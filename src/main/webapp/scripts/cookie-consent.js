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

  function hasConsent() {
    return readStoredConsent() === 'accepted';
  }

  if (hasConsent()) {
    hideBanner();
  }

  acceptBtn.addEventListener('click', function () {
    writeStoredConsent(true);
    hideBanner();
  });

  declineBtn.addEventListener('click', function () {
    writeStoredConsent(false);
    hideBanner();
  });
})();
