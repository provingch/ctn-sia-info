(function () {
  const CONSENT_KEY = 'SIA_COOKIE_CONSENT';
  const banner = document.getElementById('cookieConsent');
  const acceptBtn = document.getElementById('acceptCookies');
  const declineBtn = document.getElementById('declineCookies');

  if (!banner || !acceptBtn || !declineBtn) {
    return; // Elements not found, skip
  }

  function hasConsent() {
    const stored = localStorage.getItem(CONSENT_KEY);
    return stored === 'accepted';
  }

  function hideBanner() {
    banner.classList.add('hidden');
  }

  function saveConsent(accepted) {
    localStorage.setItem(CONSENT_KEY, accepted ? 'accepted' : 'declined');
    hideBanner();
  }

  // Check if user has already given consent
  if (hasConsent()) {
    hideBanner();
  }

  acceptBtn.addEventListener('click', function () {
    saveConsent(true);
  });

  declineBtn.addEventListener('click', function () {
    saveConsent(false);
  });
})();
