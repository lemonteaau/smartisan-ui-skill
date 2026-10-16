/* Smartisan OS UI — behaviour for smartisan.css (no dependencies).
   <script src="smartisan.js" defer></script>

   Timings and gestures follow the Smartisan OS framework and the community 1:1 rewrites of
   Music / Weather / Clock; references/motion.md says where each number comes from.

   Pressed state     buttons stay visibly pressed >= 64ms after a quick tap; list rows press after a
                     100ms tap timeout and cancel when the finger starts scrolling (no blue flashes)
   .s-switch         tap toggles; the thumb can also be dragged (linear ~70ms settle)
   [data-s-open=id]  opens a .s-overlay or .s-modal-page; [data-s-close] closes the one it is in;
                     scrim tap / Esc close overlays unless data-s-modal is set
   .s-stack          [data-s-push=pageId] pushes, [data-s-back] pops; with data-s-appbar="barId"
                     the fixed bar runs the staged title / back-arrow animation
   .s-swipe[data-s-swipe]       swipe right to uncover the tray; [data-s-swipe-delete] removes the row
   .s-picker__col[data-s-wheel] real wheel: drag, fling, snap, mouse wheel, arrow keys; fires "change"
   .s-elastic        rubber-band overscroll on touch (needs a .s-elastic__content child)
   .s-quickbar       A–Z# index strip; fires "s-letter" with the letter in event.detail
   .s-slider         keeps --p (filled track) in sync with the value
   .s-swap           part choreography: [data-s-show=panelId] swaps .s-swap__panel layers — the old
                     panel's parts leave (300ms), then the new panel's [data-s-part]s enter on their own clocks

   API: Smartisan.open(el|id) / close / push(stack, page) / pop(stack) / show(panel) / toast(text, ms) / init(scope)
        Smartisan.haptics = true  → short navigator.vibrate() ticks on wheel steps, switch, quick bar
*/
(function () {
  'use strict';
  var root = document.documentElement;
  root.classList.add('s-js');
  var $ = function (x) { return typeof x === 'string' ? document.getElementById(x) : x; };
  var clamp = function (v, a, b) { return Math.max(a, Math.min(b, v)); };
  var SLOP = 8, TAP_TIMEOUT = 100, PRESSED_MIN = 64;
  var api = { haptics: false };
  function tick(ms) { if (api.haptics && navigator.vibrate) navigator.vibrate(ms || 8); }
  function emit(el, name, detail) { el.dispatchEvent(new CustomEvent(name, { bubbles: true, detail: detail })); }
  function after(el, ms, fn) {
    var done = false, go = function () { if (!done) { done = true; fn(); } };
    el.addEventListener('animationend', function h(e) { if (e.target === el) { el.removeEventListener('animationend', h); go(); } });
    setTimeout(go, ms + 50);
  }
  function animate(from, to, ms, ease, step) {
    var t0 = performance.now(), job = { stop: false };
    (function f(now) {
      if (job.stop) return;
      var t = clamp((now - t0) / ms, 0, 1); step(from + (to - from) * ease(t));
      if (t < 1) requestAnimationFrame(f);
    })(t0);
    return job;
  }
  var decel = function (t) { return 1 - Math.pow(1 - t, 3); };   // DecelerateInterpolator(1.5)

  /* ---------- pressed state ---------- */
  var PRESSABLE = 'button, a[href], [data-pressable], [role="button"], .s-chip';
  var press = null;
  function release(p, now) {
    if (!p) return; clearTimeout(p.timer);
    var wait = now || p.shownAt == null ? 0 : Math.max(0, PRESSED_MIN - (performance.now() - p.shownAt));
    setTimeout(function () { p.el.classList.remove('is-pressed'); }, wait);
  }
  document.addEventListener('pointerdown', function (e) {
    if (e.button > 0) return;
    var el = e.target.closest(PRESSABLE);
    if (!el || el.disabled || el.getAttribute('aria-disabled') === 'true') return;
    if (el.closest('[data-s-wheel], .s-quickbar') || el.matches('.s-switch, .s-check, .s-radio')) return;
    var p = press = { el: el, x: e.clientX, y: e.clientY, shownAt: null };
    var show = function () { if (press === p) { el.classList.add('is-pressed'); p.shownAt = performance.now(); } };
    if (el.matches('.s-list-item')) p.timer = setTimeout(show, TAP_TIMEOUT); else show();
  }, true);
  document.addEventListener('pointermove', function (e) {
    if (press && Math.hypot(e.clientX - press.x, e.clientY - press.y) > SLOP) { release(press, true); press = null; }
  }, true);
  document.addEventListener('pointerup', function () {
    var p = press; press = null; if (!p) return;
    if (p.shownAt == null) { clearTimeout(p.timer); p.el.classList.add('is-pressed'); p.shownAt = performance.now(); }
    release(p);
  }, true);
  ['pointercancel', 'scroll'].forEach(function (n) {
    document.addEventListener(n, function () { if (press) { release(press, true); press = null; } }, true);
  });

  /* ---------- overlays, full-screen pages, toast ---------- */
  function open(el) {
    el = $(el); if (!el) return;
    el.classList.remove('is-closing'); el.hidden = false;
    var f = el.querySelector('[data-primary], button'); if (f) f.focus({ preventScroll: true });
    emit(el, 's-open');
  }
  function close(el) {
    el = $(el); if (!el || el.hidden || el.classList.contains('is-closing')) return;
    el.classList.add('is-closing');
    after(el, el.classList.contains('s-modal-page') || el.classList.contains('s-overlay--sheet') ? 300 : 200, function () {
      el.hidden = true; el.classList.remove('is-closing'); emit(el, 's-close');
    });
  }
  var toastTimer;
  function toast(text, ms) {
    var host = document.querySelector('.s-toast-host');
    if (!host) {
      host = document.createElement('div'); host.className = 's-toast-host'; host.setAttribute('role', 'status');
      host.innerHTML = '<span class="s-toast"></span>';
      (document.querySelector('.s-page, .s-root') || document.body).appendChild(host);
    }
    var t = host.querySelector('.s-toast') || host.appendChild(Object.assign(document.createElement('span'), { className: 's-toast' }));
    t.textContent = text; host.hidden = false;
    clearTimeout(toastTimer); toastTimer = setTimeout(function () { host.hidden = true; }, ms || 1800);
  }

  /* ---------- switch: tap or drag (SwitchEx) ---------- */
  var sw = null;
  document.addEventListener('pointerdown', function (e) {
    var el = e.target.closest('.s-switch'); if (!el || el.disabled) return;
    var on = el.checked ? 1 : 0;
    sw = { el: el, x: e.clientX, t: performance.now(), from: on, pos: on, drag: false };
  });
  document.addEventListener('pointermove', function (e) {
    if (!sw) return;
    var dx = e.clientX - sw.x;
    if (!sw.drag && Math.abs(dx) < SLOP) return;
    if (!sw.drag) { sw.drag = true; sw.el.classList.add('is-dragging'); }
    sw.pos = clamp(sw.from + dx / (sw.el.clientWidth - 24), 0, 1);
    sw.el.style.setProperty('--pos', sw.pos);
  });
  document.addEventListener('pointerup', function () {
    var s = sw; sw = null; if (!s) return;
    if (!s.drag && performance.now() - s.t < 300) { s.el.style.setProperty('--travel', 1); return; }  // a tap: the native click toggles
    var target = s.drag ? s.pos > 0.5 : !!s.from;
    s.el.style.setProperty('--travel', Math.abs((target ? 1 : 0) - s.pos).toFixed(3));
    s.el.classList.remove('is-dragging'); s.el.style.removeProperty('--pos');
    s.el._skipClick = true;
    if (s.el.checked !== target) { s.el.checked = target; emit(s.el, 'input'); emit(s.el, 'change'); }
  });
  document.addEventListener('click', function (e) {
    var el = e.target.closest && e.target.closest('.s-switch');
    if (el && el._skipClick) { el._skipClick = false; e.preventDefault(); }
  }, true);
  document.addEventListener('change', function (e) {
    if (!e.target.matches) return;
    if (e.target.matches('.s-switch')) tick();
    if (e.target.matches('.s-check')) syncCheckRow(e.target);
  });
  // edit mode: a row holding an .s-check is tinted while it is checked
  function syncCheckRow(c) {
    var row = c.closest('.s-list-item'); if (!row) return;
    row.classList.toggle('is-selected', c.checked);
  }

  /* ---------- swipe-right rows ---------- */
  var openRow = null, swipe = null, swallow = false;   // swallow: eat the click of the current gesture
  function setRow(row, x, ms) {
    var item = row.querySelector(':scope > .s-list-item');
    if (item) item.style.transitionDuration = ms != null ? ms + 'ms' : '';
    row.style.setProperty('--x', x + 'px');
  }
  function closeRow(row) {
    if (!row) return; setRow(row, 0, 200); row.classList.remove('is-open');
    if (openRow === row) openRow = null; emit(row, 's-swipe-close');
  }
  document.addEventListener('pointerdown', function (e) {
    var row = e.target.closest('.s-swipe[data-s-swipe]'), onTray = !!e.target.closest('.s-swipe__actions');
    swallow = false;
    if (openRow && !(row === openRow && onTray)) {            // any touch elsewhere closes the open row and is used up
      closeRow(openRow); swallow = true;
      if (press) { release(press, true); press = null; }
      return;
    }
    if (!row || onTray || e.target.closest('.s-switch')) return;
    swipe = { row: row, x: e.clientX, y: e.clientY, mode: null, raw: 0, w: row.querySelector('.s-swipe__actions').offsetWidth };
  }, true);
  document.addEventListener('pointermove', function (e) {
    if (!swipe) return;
    var dx = e.clientX - swipe.x, dy = e.clientY - swipe.y;
    if (!swipe.mode) {
      if (Math.hypot(dx, dy) < 5) return;
      swipe.mode = Math.abs(dx) > Math.abs(dy) && dx > 0 ? 'swipe' : 'scroll';
      if (swipe.mode === 'scroll') { swipe = null; return; }
      swipe.row.classList.add('is-dragging');
      if (press) { release(press, true); press = null; }
    }
    var w = swipe.w, d = Math.max(0, dx);
    swipe.raw = d;
    setRow(swipe.row, d <= w ? d : w + Math.min(d - w, 360 - w) / 5, 0);   // direct, then 1/5 resistance
  });
  document.addEventListener('pointerup', function () {
    var s = swipe; swipe = null; if (!s || s.mode !== 'swipe') return;
    s.row.classList.remove('is-dragging'); swallow = true;
    if (s.raw > s.w / 4) {
      setRow(s.row, s.w, s.raw > s.w ? 200 : 150); s.row.classList.add('is-open'); openRow = s.row; emit(s.row, 's-swipe-open');
    } else closeRow(s.row);
  });
  document.addEventListener('click', function (e) {
    var del = e.target.closest('[data-s-swipe-delete]');
    if (del) {
      var row = del.closest('.s-swipe'); openRow = null;
      setRow(row, row.offsetWidth, 200);
      setTimeout(function () {
        row.style.height = row.offsetHeight + 'px'; void row.offsetHeight;      // then collapse in 200ms
        row.classList.add('is-removing'); emit(row, 's-delete');
        setTimeout(function () { row.remove(); }, 220);
      }, 200);
      return;
    }
    if (swallow) { swallow = false; e.preventDefault(); e.stopPropagation(); }
  }, true);

  /* ---------- page stack ---------- */
  function stackOf(x) { x = $(x); return x && (x.classList.contains('s-stack') ? x : x.closest('.s-stack')); }
  function history(stack) {
    if (!stack._hist) {
      var ps = Array.prototype.filter.call(stack.children, function (c) { return c.classList.contains('s-stack__page'); });
      stack._hist = [ps.filter(function (p) { return !p.hidden; })[0] || ps[0]];
    }
    return stack._hist;
  }
  function swapBar(stack, from, to, backward) {
    var bar = $(stack.getAttribute('data-s-appbar')); if (!bar) return;
    var title = bar.querySelector('.s-appbar__title:not(.is-fading-out)');
    if (title && to.hasAttribute('data-title')) {
      var next = title.cloneNode(false); next.textContent = to.getAttribute('data-title');
      next.classList.add('is-fading-in'); title.classList.add('is-fading-out'); title.after(next);
      setTimeout(function () { title.remove(); next.classList.remove('is-fading-in'); }, 320);
    }
    bar.querySelectorAll('[data-s-page]').forEach(function (el) {
      var mine = el.getAttribute('data-s-page') === to.id, was = el.getAttribute('data-s-page') === from.id;
      if (was && !mine) { el.classList.add('is-fading-out'); setTimeout(function () { el.hidden = true; el.classList.remove('is-fading-out'); }, 160); }
      if (mine && !was) { el.hidden = false; el.classList.add('is-fading-in'); setTimeout(function () { el.classList.remove('is-fading-in'); }, 320); }
    });
    var back = bar.querySelector('[data-s-back]'), depth = history(stack).length; if (!back) return;
    if (!backward && depth === 2) { back.hidden = false; back.classList.add('is-back-in'); setTimeout(function () { back.classList.remove('is-back-in'); }, 320); }
    if (backward && depth === 1) { back.classList.add('is-back-out'); setTimeout(function () { back.hidden = true; back.classList.remove('is-back-out'); }, 300); }
  }
  function push(stack, page) {
    page = $(page); stack = stackOf(stack || page); if (!stack || !page || stack._busy) return;
    var hist = history(stack), from = hist[hist.length - 1]; if (from === page) return;
    stack._busy = true; hist.push(page); page.hidden = false; page.scrollTop = 0;
    page.classList.add('is-entering'); from.classList.add('is-leaving'); swapBar(stack, from, page, false);
    setTimeout(function () {
      page.classList.remove('is-entering'); from.classList.remove('is-leaving'); from.hidden = true;
      stack._busy = false; emit(page, 's-page');
    }, 300);
  }
  function pop(stack) {
    stack = stackOf(stack); if (!stack || stack._busy) return;
    var hist = history(stack); if (hist.length < 2) return;
    stack._busy = true; var from = hist.pop(), to = hist[hist.length - 1];
    to.hidden = false; from.classList.add('is-popping'); to.classList.add('is-returning'); swapBar(stack, from, to, true);
    setTimeout(function () {
      from.classList.remove('is-popping'); to.classList.remove('is-returning'); from.hidden = true;
      stack._busy = false; emit(to, 's-page');
    }, 270);
  }

  /* ---------- wheel picker (SmartisanTimePickerView) ---------- */
  function lerp(a, b, t) { return a + (b - a) * t; }
  function initWheel(col) {
    if (col._wheel) return;
    var items = Array.prototype.slice.call(col.children); if (!items.length) return;
    var loop = col.hasAttribute('data-s-loop'), n = items.length;
    var first = Math.max(0, items.findIndex(function (i) { return i.getAttribute('aria-selected') === 'true'; }));
    var w = col._wheel = { pos: first, job: null, last: first };
    if (col.tabIndex < 0) col.tabIndex = 0;
    col.setAttribute('role', 'listbox');
    var rowH = function () { return col.clientHeight / 5; };
    var index = function (p) { var i = Math.round(p); return loop ? ((i % n) + n) % n : clamp(i, 0, n - 1); };
    function draw() {
      var h = rowH(), c = col.clientHeight / 2; col.style.setProperty('--row', h + 'px');
      items.forEach(function (it, i) {
        var d = i - w.pos; if (loop) d = ((d % n) + n + n / 2) % n - n / 2;
        if (Math.abs(d) > 3) { it.style.visibility = 'hidden'; return; }
        var f = clamp(1 - Math.abs(d), 0, 1);
        it.style.visibility = ''; it.style.transform = 'translateY(' + (c - h / 2 + d * h) + 'px)';
        it.style.fontSize = lerp(16, 18, f) + 'px';
        it.style.color = 'rgb(' + [lerp(179, 85, f), lerp(179, 88, f), lerp(181, 92, f)].map(Math.round).join(',') + ')';
      });
      var cur = index(w.pos);
      if (cur !== w.last) {
        items[w.last].removeAttribute('aria-selected'); items[cur].setAttribute('aria-selected', 'true'); w.last = cur; tick(4);
        col.dispatchEvent(new CustomEvent('change', { bubbles: true, detail: { index: cur, value: items[cur].textContent.trim() } }));
      }
    }
    function settle(target, ms) {
      if (w.job) w.job.stop = true;
      if (!loop) target = clamp(target, 0, n - 1);
      w.job = animate(w.pos, target, ms, decel, function (v) { w.pos = v; draw(); });
    }
    var drag = null;
    col.addEventListener('pointerdown', function (e) {
      if (w.job) w.job.stop = true;
      col.setPointerCapture(e.pointerId); col.style.cursor = 'grabbing';
      drag = { y: e.clientY, p: w.pos, s: [{ t: e.timeStamp, y: e.clientY }] };
    });
    col.addEventListener('pointermove', function (e) {
      if (!drag) return;
      var p = drag.p - (e.clientY - drag.y) / rowH();
      if (!loop && (p < 0 || p > n - 1)) { var edge = p < 0 ? 0 : n - 1; p = edge + (p - edge) * 0.35; }
      w.pos = p; draw();
      drag.s.push({ t: e.timeStamp, y: e.clientY }); if (drag.s.length > 6) drag.s.shift();
    });
    function end() {
      if (!drag) return;
      var s = drag.s, a = s[0], b = s[s.length - 1]; drag = null; col.style.cursor = '';
      var v = b.t > a.t ? (b.y - a.y) / (b.t - a.t) : 0;          // px per ms
      if (Math.abs(v) > 0.3) { var delta = -v * 180 / rowH(); settle(Math.round(w.pos + delta), clamp(250 + Math.abs(delta) * 35, 250, 1100)); }
      else settle(Math.round(w.pos), 200);                       // snap: 200ms decelerate
    }
    col.addEventListener('pointerup', end); col.addEventListener('pointercancel', end);
    col.addEventListener('wheel', function (e) { e.preventDefault(); settle(Math.round(w.pos) + (e.deltaY > 0 ? 1 : -1), 200); }, { passive: false });
    col.addEventListener('keydown', function (e) {
      if (e.key !== 'ArrowDown' && e.key !== 'ArrowUp') return;
      e.preventDefault(); settle(Math.round(w.pos) + (e.key === 'ArrowDown' ? 1 : -1), 200);
    });
    col.sWheelTo = function (i) { settle(i, 200); };
    draw();
    if (window.ResizeObserver) new ResizeObserver(draw).observe(col);
  }

  /* ---------- elastic overscroll (Weather search list) ---------- */
  function initElastic(box) {
    var content = box.querySelector(':scope > .s-elastic__content'); if (box._elastic || !content) return;
    box._elastic = true;
    var y0 = 0, raw = 0, active = false;
    function offset(r) {           // offset = max * (1 - 100^(-dragged / R)), never more than the finger moved
      var dragged = Math.abs(r * 0.5), max = r > 0 ? 250 : 150, R = Math.max(window.innerHeight / 2, box.clientHeight);
      return Math.sign(r) * Math.min(max * (1 - Math.pow(100, -dragged / R)), dragged);
    }
    box.addEventListener('touchstart', function (e) { y0 = e.touches[0].clientY; raw = 0; active = false; box.classList.remove('is-returning'); }, { passive: true });
    box.addEventListener('touchmove', function (e) {
      var y = e.touches[0].clientY, dy = y - y0; y0 = y;
      var atTop = box.scrollTop <= 0, atEnd = box.scrollTop + box.clientHeight >= box.scrollHeight - 1;
      if (!active && !(atTop && dy > 0) && !(atEnd && dy < 0)) return;
      raw += dy; if ((raw > 0 && !atTop) || (raw < 0 && !atEnd)) raw = 0;
      active = raw !== 0;
      if (active) { e.preventDefault(); box.style.setProperty('--o', offset(raw) + 'px'); }
    }, { passive: false });
    box.addEventListener('touchend', function () {
      if (!active) return; active = false; raw = 0;
      box.classList.add('is-returning'); box.style.setProperty('--o', '0px');   // 250ms viscous return
    });
  }

  /* ---------- quick bar ---------- */
  function initQuickbar(bar) {
    if (bar._qb) return; bar._qb = true;
    if (!bar.querySelector('span')) 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('').forEach(function (c) {
      bar.appendChild(Object.assign(document.createElement('span'), { textContent: c }));
    });
    var spans = Array.prototype.slice.call(bar.querySelectorAll(':scope > span'));
    var bubble = bar.appendChild(Object.assign(document.createElement('div'), { className: 's-quickbar__bubble', hidden: true }));
    var cur = null, on = false;
    function at(y) {
      var r = bar.getBoundingClientRect(), i = clamp(Math.floor((y - r.top) / r.height * spans.length), 0, spans.length - 1);
      if (spans[i] === cur) return;
      if (cur) cur.classList.remove('is-current');
      cur = spans[i]; cur.classList.add('is-current');
      bubble.textContent = cur.textContent; bubble.style.top = (cur.offsetTop + cur.offsetHeight / 2) + 'px'; bubble.hidden = false;
      tick(4); emit(bar, 's-letter', cur.textContent);
    }
    bar.addEventListener('pointerdown', function (e) { on = true; bar.setPointerCapture(e.pointerId); bar.classList.add('is-active'); at(e.clientY); });
    bar.addEventListener('pointermove', function (e) { if (on) at(e.clientY); });
    function up() {
      on = false;
      setTimeout(function () { if (on) return; bar.classList.remove('is-active'); bubble.hidden = true; if (cur) cur.classList.remove('is-current'); cur = null; }, 200);
    }
    bar.addEventListener('pointerup', up); bar.addEventListener('pointercancel', up);
  }

  /* ---------- part choreography (Clock tab switch) ---------- */
  function longest(panel) {
    var max = 0;
    panel.querySelectorAll('[data-s-part]').forEach(function (p) {
      var cs = getComputedStyle(p);
      var d = parseFloat(cs.getPropertyValue('--d')) || 700, de = parseFloat(cs.getPropertyValue('--delay')) || 0;
      max = Math.max(max, d + de);
    });
    return Math.max(max, 450);
  }
  function show(panel) {
    panel = $(panel); if (!panel) return;
    var box = panel.closest('.s-swap'); if (!box || box._busy) return;
    var panels = Array.prototype.filter.call(box.children, function (c) { return c.classList.contains('s-swap__panel'); });
    var cur = panels.filter(function (p) { return !p.hidden; })[0];
    if (cur === panel) return;
    box._busy = true;
    document.querySelectorAll('[data-s-show]').forEach(function (b) {
      if (panels.indexOf($(b.getAttribute('data-s-show'))) < 0) return;
      if (b.getAttribute('data-s-show') === panel.id) b.setAttribute('aria-current', 'page'); else b.removeAttribute('aria-current');
    });
    var enter = function () {
      if (cur) { cur.hidden = true; cur.classList.remove('is-leaving'); }
      panel.hidden = false; panel.classList.add('is-entering'); box._busy = false;
      var ms = longest(panel);
      clearTimeout(panel._t); panel._t = setTimeout(function () { panel.classList.remove('is-entering'); }, ms + 50);
      emit(panel, 's-show');
    };
    if (cur) { cur.classList.add('is-leaving'); setTimeout(enter, 300); } else enter();
  }

  /* ---------- wiring ---------- */
  function syncSlider(el) {
    var min = +el.min || 0, max = el.max === '' ? 100 : +el.max, v = +el.value;
    el.style.setProperty('--p', max > min ? ((v - min) / (max - min)) * 100 : 0);
  }
  document.addEventListener('input', function (e) { if (e.target.classList && e.target.classList.contains('s-slider')) syncSlider(e.target); });
  document.addEventListener('click', function (e) {
    var sh = e.target.closest('[data-s-show]');
    if (sh) { show(sh.getAttribute('data-s-show')); return; }
    var t = e.target.closest('[data-s-open], [data-s-close], [data-s-push], [data-s-back]');
    if (t && t.hasAttribute('data-s-open')) { open(t.getAttribute('data-s-open')); return; }
    if (t && t.hasAttribute('data-s-close')) { close(t.getAttribute('data-s-close') || t.closest('.s-overlay, .s-modal-page')); return; }
    if (t && t.hasAttribute('data-s-push')) { push(null, t.getAttribute('data-s-push')); return; }
    if (t && t.hasAttribute('data-s-back')) {
      var bar = t.closest('.s-appbar');
      pop($(t.getAttribute('data-s-back')) || stackOf(t) || (bar && document.querySelector('.s-stack[data-s-appbar="' + bar.id + '"]')));
      return;
    }
    if (e.target.classList.contains('s-overlay') && !e.target.hasAttribute('data-s-modal')) close(e.target);
  });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    var list = document.querySelectorAll('.s-overlay:not([hidden]):not([data-s-modal])');
    if (list.length) close(list[list.length - 1]);
  });
  function init(scope) {
    scope = scope || document;
    scope.querySelectorAll('.s-slider').forEach(syncSlider);
    scope.querySelectorAll('.s-list-item .s-check').forEach(syncCheckRow);
    scope.querySelectorAll('.s-picker__col[data-s-wheel]').forEach(initWheel);
    scope.querySelectorAll('.s-elastic').forEach(initElastic);
    scope.querySelectorAll('.s-quickbar').forEach(initQuickbar);
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function () { init(); }); else init();

  api.open = open; api.close = close; api.toast = toast; api.push = push; api.pop = pop;
  api.syncSlider = syncSlider; api.init = init; api.show = show;
  window.Smartisan = api;
})();
