(() => {
  const $ = (s, c = document) => c.querySelector(s);
  const IMG = 'assets/img/';
  const fmt = n => n.toLocaleString('ru-RU').replace(/ /g, ' ') + ' ₽';

  const PRODUCTS = [
    { id: 1, name: 'iPhone 15 Black 128Gb ( без RuStore )', price: 56990, img: 'apple/iphone15/i15black-400x280.png', url: 'apple/iphone/iphone-15/128gb-21/iphone-15-black-128gb-bez-rustore' },
    { id: 2, name: 'Блок USB-C 20W iPhone', price: 2990, img: 'iphone/aksessuary/blok-usb-c-20w-iphone-400x280.png', url: 'apple/aksessuary-1/blok-pitaniya/apple-10/blok-usb-c-20w-iphone' },
    { id: 3, name: 'iPhone 17 Pro Deep Blue 256Gb ( без RuStore)', price: 98990, img: 'apple/17pro/iphone-17-pro-deepblue-400x280.png', url: 'apple/iphone/iphone-17-pro-1/256gb-55/iphone-17-pro-deep-blue-256gb-bez' },
    { id: 4, name: 'AirPods 4', price: 10490, img: 'airpods4/airpods_4-400x280.png', url: 'apple/airpods/airpods-4/airpods-4-1' },
    { id: 5, name: 'iPhone 15 Blue 128Gb ( без Rustore )', price: 56990, img: 'apple/iphone15/i15blue-400x280.png', url: 'apple/iphone/iphone-15/128gb-21/iphone-15-blue-128gb-bez-rustore' },
    { id: 6, name: 'iPhone 17 Pro Silver 256Gb ( без RuStore)', price: 99990, img: 'apple/17pro/iphone-17-pro-silver-400x280.png', url: 'apple/iphone/iphone-17-pro-1/256gb-55/iphone-17-pro-silver-256gb-bez-ru' },
    { id: 7, name: 'iPhone 16 Black 128Gb ( без RuStore )', price: 65990, img: 'iphone16/black/iphone_16_black-transformed-400x280.png', url: 'apple/iphone/iphone-16/128gb-7/iphone-16-black-128gb-bez-rustore' },
    { id: 8, name: 'AirPods 4 с активным шумоподавлением', price: 13490, img: 'airpods4/airpods_4_noise-400x280.png', url: 'apple/airpods/airpods-4/airpods-4-s-aktivnym-shumopodavleniem' },
    { id: 9, name: 'iPhone 17 Black 256Gb ( без RuStore)', price: 78990, img: 'apple/iphone17/08ed48e6-8718-4703-91bd-35e0c0490348-400x280.png', url: 'apple/iphone/iphone-17-1/256gb-24/iphone-17-black-256gb-bez-rustore' },
    { id: 10, name: 'Sony PlayStation 5 Slim DVD', price: 71990, img: 'sony/a6d2fe363c2044d784357374213b0218-400x280.png', url: 'sony/playstation-1/ps5/sony-playstation-5-slim-dvd' },
    { id: 11, name: 'iPhone 17 Pro Max Silver 256Gb ( без RuStore)', price: 106990, img: 'apple/17pro/iphone-17-pro-silver-400x280.png', url: 'apple/iphone/iphone-17-pro-max-1/256gb-56/iphone-17-pro-max-silver-256g' },
    { id: 12, name: 'iPhone 15 Black 256Gb ( без RuStore )', price: 66990, img: 'apple/iphone15/i15black-400x280.png', url: 'apple/iphone/iphone-15/256gb-25/iphone-15-black-256gb-bez-rustore' },
    { id: 13, name: 'iPhone 18 Pro Max 256Gb Burgundy ( без RuStore )', price: 149990, img: 'apple/18pro/burgundy.png', url: 'apple/iphone/iphone-18-pro-max/iphone-18-pro-max-256gb-burgundy-bez-rustore' },
    { id: 14, name: 'iPhone 18 Pro Max 256Gb Silver ( без RuStore )', price: 137990, img: 'apple/18pro/silver.png', url: 'apple/iphone/iphone-18-pro-max/iphone-18-pro-max-256gb-silver-bez-rustore' },
    { id: 15, name: 'iPhone 18 Pro 256Gb Burgundy ( без RuStore )', price: 125990, img: 'apple/18pro/burgundy.png', url: 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-burgundy-bez-rustore' },
    { id: 16, name: 'iPhone 18 Pro 256Gb Glacier ( без RuStore )', price: 118990, img: 'apple/18pro/glacier.png', url: 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-glacier-bez-rustore' },
    { id: 17, name: 'iPhone 18 Pro 256Gb Black ( без RuStore )', price: 118990, img: 'apple/18pro/black.png', url: 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-black-bez-rustore' },
  ];
  const byId = id => PRODUCTS.find(p => p.id === id);
  const link = p => 'https://jjstore.ru/' + p.url;

  /* Product scrollers: Новинки / Популярное */
  const NEW_IDS = [13, 15, 16, 14, 17, 11, 6, 3, 9];
  const POP_IDS = [1, 2, 4, 8, 7, 5, 10, 12];
  const card = (p, isNew) => `
    <article class="card">
      ${isNew ? '<span class="badge-new">Новинка</span>' : ''}
      <a class="img" href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt="${p.name}" loading="lazy"></a>
      <h4>${p.name}</h4>
      <div class="price">${fmt(p.price)}</div>
      <div class="slot" data-id="${p.id}"></div>
    </article>`;
  $('#trackNew').innerHTML = NEW_IDS.map(id => card(byId(id), true)).join('');
  $('#trackPop').innerHTML = POP_IDS.map(id => card(byId(id), false)).join('');
  document.querySelectorAll('.scroller').forEach(sc => {
    const tr = sc.querySelector('.track'), pv = sc.querySelector('.prev'), nx = sc.querySelector('.next');
    if (!pv) return;
    const step = () => Math.max(tr.clientWidth * .8, 240);
    pv.onclick = () => tr.scrollBy({ left: -step(), behavior: 'smooth' });
    nx.onclick = () => tr.scrollBy({ left: step(), behavior: 'smooth' });
    const upd = () => { pv.classList.toggle('off', tr.scrollLeft < 8); nx.classList.toggle('off', tr.scrollLeft + tr.clientWidth > tr.scrollWidth - 8); };
    tr.addEventListener('scroll', upd, { passive: true }); upd();
  });

  /* Hero banners: snap scroller, dots, arrows, autoplay */
  (function () {
    const box = $('#slides'), slides = [...box.children], dots = $('#dots');
    dots.innerHTML = slides.map((_, i) => `<button aria-label="Слайд ${i + 1}"></button>`).join('');
    const ds = [...dots.children];
    let cur = 0, timer;
    const go = i => { cur = (i + slides.length) % slides.length; box.scrollTo({ left: slides[cur].offsetLeft - box.offsetLeft - (box.clientWidth - slides[cur].clientWidth) / 2, behavior: 'smooth' }); };
    const mark = () => {
      const c = box.scrollLeft + box.clientWidth / 2;
      let best = 0, d = 1e9;
      slides.forEach((s, i) => { const m = Math.abs(s.offsetLeft - box.offsetLeft + s.clientWidth / 2 - c); if (m < d) { d = m; best = i; } });
      cur = best; slides.forEach((s, i) => s.classList.toggle('active', i === best));
    };
    box.addEventListener('scroll', mark, { passive: true });
    ds.forEach((x, i) => x.onclick = () => { go(i); play(); });
    $('#hPrev').onclick = () => { go(cur - 1); play(); };
    $('#hNext').onclick = () => { go(cur + 1); play(); };
    const DUR = 6000;
    const play = () => { clearTimeout(timer); box.classList.remove('paused'); timer = setTimeout(() => go(cur + 1), DUR); };
    const stop = () => { clearTimeout(timer); box.classList.add('paused'); };
    ['pointerenter', 'touchstart'].forEach(ev => box.addEventListener(ev, stop, { passive: true }));
    ['pointerleave', 'touchend'].forEach(ev => box.addEventListener(ev, play, { passive: true }));
    let last = -1;
    const onChange = () => { if (cur !== last) { last = cur; ds.forEach(x => { x.classList.remove('on'); }); void dots.offsetWidth; ds[cur].classList.add('on'); if (!box.classList.contains('paused')) play(); } };
    box.addEventListener('scroll', () => requestAnimationFrame(onChange), { passive: true });
    /* subtle parallax on the banner photo */
    if (matchMedia('(hover:hover) and (pointer:fine)').matches) slides.forEach(s => {
      const im = s.querySelector('img');
      s.addEventListener('pointermove', e => { const r = s.getBoundingClientRect(); im.style.translate = `${((e.clientX - r.left) / r.width - .5) * -18}px ${((e.clientY - r.top) / r.height - .5) * -12}px`; });
      s.addEventListener('pointerleave', () => { im.style.translate = ''; });
    });
    mark(); onChange(); play();
  })();

  /* Cart: { id: qty } */
  let cart = {};
  try {
    const raw = JSON.parse(localStorage.getItem('jj-cart2') || 'null');
    if (raw && typeof raw === 'object') cart = raw;
    else { (JSON.parse(localStorage.getItem('jj-cart') || '[]')).forEach(id => { cart[id] = (cart[id] || 0) + 1; }); }
  } catch (e) {}
  const TRASH = '<svg viewBox="0 0 24 24"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-12M9 7V4h6v3"/></svg>';
  const save = () => { try { localStorage.setItem('jj-cart2', JSON.stringify(cart)); } catch (e) {} };
  const qtyOf = id => cart[id] || 0;
  const totalQty = () => Object.values(cart).reduce((s, n) => s + n, 0);
  const totalSum = () => Object.entries(cart).reduce((s, [id, n]) => s + (byId(+id)?.price || 0) * n, 0);
  const plural = (n, a, b, c) => { const m = n % 100, d = n % 10; return (m > 10 && m < 20) ? c : d === 1 ? a : (d > 1 && d < 5) ? b : c; };
  const stepper = id => `<div class="step" data-id="${id}"><button data-act="dec" aria-label="Меньше">−</button><b>${qtyOf(id)}</b><button data-act="inc" aria-label="Больше">+</button></div>`;

  /* card buttons turn into steppers once an item is in the cart */
  function syncCards() {
    document.querySelectorAll('.slot').forEach(s => {
      const id = +s.dataset.id, n = qtyOf(id);
      s.innerHTML = n ? stepper(id) : `<button class="buy" data-act="inc" data-id="${id}">В корзину</button>`;
    });
  }
  let renderCart = function () {
    const ids = Object.keys(cart).map(Number).filter(id => byId(id));
    const qty = totalQty(), box = $('#cartItems');
    $('#cartModal').classList.toggle('is-empty', !ids.length);
    box.innerHTML = ids.length ? ids.map(id => {
      const p = byId(id);
      return `<article class="ci" data-id="${id}">
        <a class="ci-img" href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt=""></a>
        <div class="ci-main"><b>${p.name}</b><small>${fmt(p.price)} за шт.</small>
          <div class="ci-row">${stepper(id)}<span class="ci-sum">${fmt(p.price * qtyOf(id))}</span></div></div>
        <button class="ci-del" data-act="del" aria-label="Удалить" title="Удалить">${TRASH}</button>
      </article>`;
    }).join('') : `<div class="empty">
        <span class="e-ico"><svg viewBox="0 0 24 24"><path d="M6 7h12l-1 12H7L6 7Z"/><path d="M9 7a3 3 0 0 1 6 0"/></svg></span>
        <b>В корзине пока пусто</b><p>Добавьте товары, и они появятся здесь</p>
        <button class="btn" data-close>К покупкам</button></div>`;
    $('#sumQty').textContent = qty;
    $('#cartTotal').textContent = fmt(totalSum());
    $('#cartMeta').textContent = qty ? `${qty} ${plural(qty, 'товар', 'товара', 'товаров')}` : '';
    const c = $('#cartCount'); c.textContent = qty; c.classList.toggle('on', qty > 0);
    syncCards();
  };
  function bump() { const c = $('#cartCount'); c.classList.remove('bump'); void c.offsetWidth; c.classList.add('bump'); }

  const modal = $('#cartModal');
  const openCart = () => { modal.classList.add('on'); modal.setAttribute('aria-hidden', 'false'); document.body.classList.add('lock'); };
  const closeCart = () => { modal.classList.remove('on'); modal.setAttribute('aria-hidden', 'true'); document.body.classList.remove('lock'); };
  $('#openCart').onclick = openCart;
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeCart(); });
  $('#cartClear').onclick = () => { cart = {}; save(); renderCart(); };

  document.addEventListener('click', e => {
    if (e.target.closest('[data-close]') && modal.contains(e.target)) { closeCart(); return; }
    const a = e.target.closest('[data-act]'); if (!a) return;
    const holder = a.closest('[data-id]'); const id = +(a.dataset.id || holder?.dataset.id);
    if (!id) return;
    const act = a.dataset.act;
    if (act === 'inc') { cart[id] = Math.min(99, qtyOf(id) + 1); bump(); }
    else if (act === 'dec') { cart[id] = qtyOf(id) - 1; if (cart[id] <= 0) delete cart[id]; }
    else if (act === 'del') { delete cart[id]; }
    save(); renderCart();
  });

  /* Search */
  const input = $('#search'), res = $('#results');
  input.addEventListener('input', () => {
    const q = input.value.trim().toLowerCase();
    if (!q) { res.classList.remove('on'); return; }
    const found = PRODUCTS.filter(p => p.name.toLowerCase().includes(q));
    res.innerHTML = found.length
      ? found.map(p => `<a href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt=""><b>${p.name}</b><span>${fmt(p.price)}</span></a>`).join('')
      : '<em>Ничего не найдено</em>';
    res.classList.add('on');
  });
  document.addEventListener('click', e => { if (!e.target.closest('.search')) res.classList.remove('on'); });

  /* specular light follows the cursor on glass surfaces */
  if (matchMedia('(hover:hover) and (pointer:fine)').matches) {
    document.addEventListener('pointermove', e => {
      const g = e.target.closest && e.target.closest('.glass'); if (!g) return;
      const r = g.getBoundingClientRect();
      g.style.setProperty('--mx', (e.clientX - r.left) + 'px'); g.style.setProperty('--my', (e.clientY - r.top) + 'px');
    }, { passive: true });
  }


  /* ---------- UX polish ---------- */
  /* reveal on scroll (starts once the intro is done) */
  function startReveal() {
    document.querySelectorAll('.wall .tile').forEach((t, i) => { t.dataset.reveal = ''; t.style.setProperty('--d', (i % 6) * 55 + 'ms'); });
    const all = document.querySelectorAll('[data-reveal]');
    if (!('IntersectionObserver' in window)) { all.forEach(e => e.classList.add('in')); return; }
    const io = new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } }), { threshold: .08, rootMargin: '0px 0px -4% 0px' });
    all.forEach(el => io.observe(el));
  }

  /* intro loader */
  (function () {
    const root = document.documentElement, loader = $('#loader'), t0 = performance.now();
    let done = false;
    const finish = () => {
      if (done) return; done = true;
      const rm = matchMedia('(prefers-reduced-motion:reduce)').matches;
      if (loader) { loader.classList.add('done'); setTimeout(() => loader.remove(), rm ? 0 : 900); }
      root.classList.add('ready'); startReveal();
    };
    const go = () => setTimeout(finish, Math.max(0, 1100 - (performance.now() - t0)));
    if (!loader) { finish(); return; }
    if (document.readyState === 'complete') go(); else addEventListener('load', go);
    setTimeout(finish, 3500);
  })();

  /* sliding highlight under the brand menu (segmented-control feel) */
  (function () {
    const nav = $('.brands'); if (!nav || !matchMedia('(hover:hover)').matches) return;
    const ind = document.createElement('i'); ind.className = 'ind'; nav.prepend(ind);
    nav.querySelectorAll('a').forEach(a => {
      a.addEventListener('pointerenter', () => { ind.style.cssText = `opacity:1;width:${a.offsetWidth}px;height:${a.offsetHeight}px;transform:translate(${a.offsetLeft}px,${a.offsetTop}px)`; });
    });
    nav.addEventListener('pointerleave', () => { ind.style.opacity = 0; });
  })();

  /* header condenses on scroll down, expands on scroll up */
  (function () {
    const head = $('#head'); let y = scrollY, ticking = false;
    addEventListener('scroll', () => {
      if (ticking) return; ticking = true;
      requestAnimationFrame(() => {
        const ny = scrollY, dy = ny - y, max = document.documentElement.scrollHeight - innerHeight;
        if (ny <= 0 || ny >= max - 2) { y = Math.max(0, Math.min(ny, max)); ticking = false; return; }
        if (ny < 120) head.classList.remove('compact'); else if (dy > 6) head.classList.add('compact'); else if (dy < -6) head.classList.remove('compact');
        y = ny; ticking = false;
      });
    }, { passive: true });
  })();

  /* mini cart bar */
  const mini = $('#miniCart');
  function syncMini() {
    const q = totalQty(); mini.classList.toggle('on', q > 0 && !modal.classList.contains('on'));
    $('#mcQty').textContent = q; $('#mcSum').textContent = fmt(totalSum());
    $('#mcLabel').textContent = `${q} ${plural(q, 'товар', 'товара', 'товаров')}`;
  }
  mini.onclick = openCart;
  const _render = renderCart; renderCart = function () { _render(); syncMini(); };
  new MutationObserver(syncMini).observe(modal, { attributes: true, attributeFilter: ['class'] });
  syncMini();

  /* search: "/" focuses, suggestions on empty focus */
  (function () {
    const sugg = ['iPhone 17', 'AirPods', 'PlayStation', 'iPhone 15'];
    const show = () => { if (input.value.trim()) return; res.innerHTML = '<div class="sugg"><small>Популярные запросы</small>' + sugg.map(s => `<button type="button" data-q="${s}">${s}</button>`).join('') + '</div>'; res.classList.add('on'); };
    input.addEventListener('focus', show);
    res.addEventListener('click', e => { const b = e.target.closest('[data-q]'); if (!b) return; input.value = b.dataset.q; input.dispatchEvent(new Event('input')); input.focus(); });
    document.addEventListener('keydown', e => { if (e.key === '/' && !/INPUT|TEXTAREA/.test(document.activeElement.tagName)) { e.preventDefault(); input.focus(); } });
  })();

  /* cookie notice (remembered) */
  (function () {
    const c = $('#cookie'); let ok = false;
    try { ok = localStorage.getItem('jj-cookie') === '1'; } catch (e) {}
    if (!ok) c.hidden = false;
    $('#cookieOk').onclick = () => { c.hidden = true; try { localStorage.setItem('jj-cookie', '1'); } catch (e) {} };
  })();

  /* help button */
  (function () {
    const h = $('#help'), b = $('#helpBtn'), p = $('#helpPanel');
    const set = on => { h.classList.toggle('open', on); b.setAttribute('aria-expanded', on); p.setAttribute('aria-hidden', !on); };
    b.onclick = () => set(!h.classList.contains('open'));
    document.addEventListener('click', e => { if (!e.target.closest('#help')) set(false); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') set(false); });
  })();

  renderCart();
})();
