/* Smartisan OS UI — optional behaviour helpers for smartisan.css (no dependencies).
   <script src="smartisan.js" defer></script>

   - .s-slider          keeps the --p custom property (filled track) in sync with the value
   - [data-s-open="id"] opens the .s-overlay with that id; [data-s-close] closes the overlay it sits in
   - .s-overlay          tapping the scrim or pressing Esc closes it (unless data-s-modal is set)
   - Smartisan.toast(text, ms)   shows a toast in .s-toast-host (created on demand)
   - Smartisan.open(el|id) / Smartisan.close(el|id)
*/
(function () {
  'use strict';
  var $ = function (x) { return typeof x === 'string' ? document.getElementById(x) : x; };

  function syncSlider(el) {
    var min = +el.min || 0, max = el.max === '' ? 100 : +el.max, v = +el.value;
    el.style.setProperty('--p', max > min ? ((v - min) / (max - min)) * 100 : 0);
  }

  function open(el) {
    el = $(el); if (!el) return;
    el.hidden = false;
    var f = el.querySelector('[data-primary], button'); if (f) f.focus({ preventScroll: true });
    el.dispatchEvent(new CustomEvent('s-open'));
  }
  function close(el) {
    el = $(el); if (!el) return;
    el.hidden = true;
    el.dispatchEvent(new CustomEvent('s-close'));
  }

  var toastTimer;
  function toast(text, ms) {
    var host = document.querySelector('.s-toast-host');
    if (!host) {
      host = document.createElement('div');
      host.className = 's-toast-host';
      host.setAttribute('role', 'status');
      host.innerHTML = '<span class="s-toast"></span>';
      (document.querySelector('.s-page, .s-root') || document.body).appendChild(host);
    }
    var t = host.querySelector('.s-toast') || host.appendChild(Object.assign(document.createElement('span'), { className: 's-toast' }));
    t.textContent = text;
    host.hidden = false;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { host.hidden = true; }, ms || 1800);
  }

  document.addEventListener('input', function (e) {
    if (e.target.classList && e.target.classList.contains('s-slider')) syncSlider(e.target);
  });
  document.addEventListener('click', function (e) {
    var opener = e.target.closest('[data-s-open]');
    if (opener) { open(opener.getAttribute('data-s-open')); return; }
    var closer = e.target.closest('[data-s-close]');
    if (closer) { close(closer.closest('.s-overlay')); return; }
    if (e.target.classList.contains('s-overlay') && !e.target.hasAttribute('data-s-modal')) close(e.target);
  });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    var list = document.querySelectorAll('.s-overlay:not([hidden]):not([data-s-modal])');
    if (list.length) close(list[list.length - 1]);
  });
  function init() { document.querySelectorAll('.s-slider').forEach(syncSlider); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();

  window.Smartisan = { open: open, close: close, toast: toast, syncSlider: syncSlider };
})();
