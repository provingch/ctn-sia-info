// planilla.js — robust, DOM-ready, defensive
(function () {

  function ready(fn) {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', fn);
    else fn();
  }

  ready(function init() {
    // global flag
    window.planillaDirty = false;

    // helper: check ignore marker
    function isIgnoreTarget(target) {
      if (!target) return false;
      if (target.dataset && target.dataset.ignoreDirty !== undefined) return true;
      if (target.closest && target.closest('[data-ignore-dirty]')) return true;
      return false;
    }

    // --------------- form dirty tracking ---------------
    const form = document.querySelector('form[action$="/PlanillaServlet"]') || document.querySelector('form');
    if (form) {
      form.addEventListener('input', function (e) {
        if (isIgnoreTarget(e.target)) return;
        window.planillaDirty = true;
      });

      form.addEventListener('change', function (e) {
        if (isIgnoreTarget(e.target)) return;
        window.planillaDirty = true;
      });

      form.addEventListener('submit', function () { window.planillaDirty = false; });
    }

    // back button guard
    const backBtn = document.getElementById('backBtn');
    if (backBtn) {
      backBtn.addEventListener('click', function (e) {
        if (window.planillaDirty) {
          const leave = confirm('Hay cambios sin guardar. ¿Deseas salir sin guardar?');
          if (!leave) e.preventDefault();
        }
      });
    }

    // beforeunload
    window.addEventListener('beforeunload', function (e) {
      if (window.planillaDirty) {
        e.preventDefault();
        e.returnValue = '';
      }
    });

    // --------------- flash messages ---------------
    (function flashHandler() {
      const nodes = document.querySelectorAll('.flash, .flash-errors');
      if (!nodes || !nodes.length) return;

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

    // --------------- download button guard (may not exist) ---------------
    const downloadBtn = document.getElementById('downloadBtn');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', function (e) {
        if (window.planillaDirty) {
          const cont = confirm('Hay cambios sin guardar. Es recomendable guardar antes de descargar. ¿Desea descargar de todas formas?');
          if (!cont) e.preventDefault();
        }
      });
    }

    // --------------- freeze checkbox / localStorage ---------------
    (function freezeToggle() {
      const checkbox = document.getElementById('freezeCheckbox');
      const tableResp = document.querySelector('.table-responsive');

      function setFreeze(enabled) {
        if (!tableResp) return;
        tableResp.classList.toggle('freeze-alumnos', !!enabled);
      }

      try {
        const saved = localStorage.getItem('ctn.freezeAlumnos');
        if (saved === '1' && checkbox) {
          checkbox.checked = true;
          setFreeze(true);
        }
      } catch (e) {}

      if (checkbox) {
        checkbox.addEventListener('change', function () {
          setFreeze(this.checked);
          try {
            localStorage.setItem('ctn.freezeAlumnos', this.checked ? '1' : '0');
          } catch (e) {}
        });
      }
    })();

    // --------------- horizontal drag for table-responsive ---------------
    (function horizontalDrag() {
      const wrap = document.querySelector('.table-responsive');
      if (!wrap) return;

      let isDown = false;
      let startX = 0;
      let scrollLeft = 0;
      let dragStarted = false;

      function isInteractiveTarget(target) {
        return !!(target && target.closest && target.closest('input, textarea, select, button, a, label'));
      }

      wrap.addEventListener('pointerdown', function (e) {
        if (isInteractiveTarget(e.target)) return;

        isDown = true;
        dragStarted = false;
        startX = e.clientX;
        scrollLeft = wrap.scrollLeft;
        wrap.classList.add('dragging');

        if (e.pointerType !== 'mouse') {
          try { e.target.setPointerCapture(e.pointerId); } catch (err) {}
        }
      });

      wrap.addEventListener('pointermove', function (e) {
        if (!isDown) return;
        const dx = e.clientX - startX;
        wrap.scrollLeft = scrollLeft - dx;
      });

      function stopDrag(e) {
        if (!isDown) return;
        isDown = false;
        wrap.classList.remove('dragging');
        try { e.target && e.target.releasePointerCapture && e.target.releasePointerCapture(e.pointerId); } catch (err) {}
      }

      wrap.addEventListener('pointerup', stopDrag);
      wrap.addEventListener('pointercancel', stopDrag);
      wrap.addEventListener('pointerleave', function (e) {
        if (isDown && e.pointerType === 'mouse') stopDrag(e);
      });

      window.addEventListener('blur', function () { isDown = false; wrap.classList.remove('dragging'); });
    })();

    // --------------- session dropdown ---------------
    (function sessionDropdown() {
      const dropdown = document.getElementById('sessionDropdown');
      if (!dropdown) return;
      const button = document.getElementById('sessionButton');
      const menu = document.getElementById('sessionMenu');
      if (!button) return;

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

      if (menu) {
        menu.addEventListener('click', function (e) {
          const t = e.target;
          if (t.matches && t.matches('a')) closeMenu();
        });
      }
    })();

  }); // ready/init
})();
