(() => {
  const $ = (s, c = document) => c.querySelector(s);
  const $$ = (s, c = document) => [...c.querySelectorAll(s)];
  const LOCAL = 'assets/img/', REMOTE = 'https://jjstore.ru/image/cache/catalog/';
  const fmt = n => n.toLocaleString('ru-RU').replace(/ /g, ' ') + ' ₽';
  const esc = s => String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const norm = s => s.toLowerCase().replace(/ё/g, 'е');
  const plural = (n, a, b, c) => { const m = n % 100, d = n % 10; return (m > 10 && m < 20) ? c : d === 1 ? a : (d > 1 && d < 5) ? b : c; };
  const PLACE = 'data:image/svg+xml;utf8,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 90"><rect x="38" y="14" width="44" height="62" rx="10" fill="#e6e9f2"/><rect x="46" y="22" width="28" height="40" rx="5" fill="#f6f7fa"/></svg>');
  const ICON = {
    trash: '<svg viewBox="0 0 24 24"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-12M9 7V4h6v3"/></svg>',
    heart: '<svg viewBox="0 0 24 24"><path d="M12 20s-7-4.400-7-10a4 4 0 0 1 7-2.600A4 4 0 0 1 19 10c0 5.600-7 10-7 10Z"/></svg>',
    ext: '<svg viewBox="0 0 24 24"><path d="M7 17 17 7M9 7h8v8"/></svg>',
    chev: '<svg viewBox="0 0 24 24"><path d="m9 6 6 6-6 6"/></svg>',
    bag: '<svg viewBox="0 0 24 24"><path d="M6 7h12l-1 12H7L6 7Z"/><path d="M9 7a3 3 0 0 1 6 0"/></svg>',
    pin: '<svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-11.5A7 7 0 0 0 5 9.500C5 14.800 12 21 12 21Z"/><circle cx="12" cy="9.500" r="2.500"/></svg>',
    truck: '<svg viewBox="0 0 24 24"><path d="M3 7h11v9H3zM14 10h4l3 3v3h-7"/><circle cx="7" cy="17" r="1.800"/><circle cx="17" cy="17" r="1.800"/></svg>',
    card: '<svg viewBox="0 0 24 24"><rect x="3" y="6" width="18" height="12" rx="3"/><path d="M3 10h18M7 15h3"/></svg>'
  };

  const DB = window.CATALOG || { c: {}, p: [] };
  const cats = DB.c;
  const kids = {};
  Object.keys(cats).forEach(k => { (kids[cats[k][1] || ''] = kids[cats[k][1] || ''] || []).push(k); });
  const products = DB.p.map(a => ({ id: a[2], name: a[0], price: a[1], url: a[2], img: a[3], cats: a[4], cat: a[4][0] }));

  const FEATURED = [
    [1, 'iPhone 15 Black 128Gb ( без RuStore )', 56990, 'apple/iphone15/i15black-400x280.png', 'apple/iphone/iphone-15/128gb-21/iphone-15-black-128gb-bez-rustore'],
    [2, 'Блок USB-C 20W iPhone', 2990, 'iphone/aksessuary/blok-usb-c-20w-iphone-400x280.png', 'apple/aksessuary-1/blok-pitaniya/apple-10/blok-usb-c-20w-iphone'],
    [3, 'iPhone 17 Pro Deep Blue 256Gb ( без RuStore)', 98990, 'apple/17pro/iphone-17-pro-deepblue-400x280.png', 'apple/iphone/iphone-17-pro-1/256gb-55/iphone-17-pro-deep-blue-256gb-bez'],
    [4, 'AirPods 4', 10490, 'airpods4/airpods_4-400x280.png', 'apple/airpods/airpods-4/airpods-4-1'],
    [5, 'iPhone 15 Blue 128Gb ( без Rustore )', 56990, 'apple/iphone15/i15blue-400x280.png', 'apple/iphone/iphone-15/128gb-21/iphone-15-blue-128gb-bez-rustore'],
    [6, 'iPhone 17 Pro Silver 256Gb ( без RuStore)', 99990, 'apple/17pro/iphone-17-pro-silver-400x280.png', 'apple/iphone/iphone-17-pro-1/256gb-55/iphone-17-pro-silver-256gb-bez-ru'],
    [7, 'iPhone 16 Black 128Gb ( без RuStore )', 65990, 'iphone16/black/iphone_16_black-transformed-400x280.png', 'apple/iphone/iphone-16/128gb-7/iphone-16-black-128gb-bez-rustore'],
    [8, 'AirPods 4 с активным шумоподавлением', 13490, 'airpods4/airpods_4_noise-400x280.png', 'apple/airpods/airpods-4/airpods-4-s-aktivnym-shumopodavleniem'],
    [9, 'iPhone 17 Black 256Gb ( без RuStore)', 78990, 'apple/iphone17/08ed48e6-8718-4703-91bd-35e0c0490348-400x280.png', 'apple/iphone/iphone-17-1/256gb-24/iphone-17-black-256gb-bez-rustore'],
    [10, 'Sony PlayStation 5 Slim DVD', 71990, 'sony/a6d2fe363c2044d784357374213b0218-400x280.png', 'sony/playstation-1/ps5/sony-playstation-5-slim-dvd'],
    [11, 'iPhone 17 Pro Max Silver 256Gb ( без RuStore)', 106990, 'apple/17pro/iphone-17-pro-silver-400x280.png', 'apple/iphone/iphone-17-pro-max-1/256gb-56/iphone-17-pro-max-silver-256g'],
    [12, 'iPhone 15 Black 256Gb ( без RuStore )', 66990, 'apple/iphone15/i15black-400x280.png', 'apple/iphone/iphone-15/256gb-25/iphone-15-black-256gb-bez-rustore'],
    [13, 'iPhone 18 Pro Max 256Gb Burgundy ( без RuStore )', 149990, 'apple/18pro/burgundy.png', 'apple/iphone/iphone-18-pro-max/iphone-18-pro-max-256gb-burgundy-bez-rustore'],
    [14, 'iPhone 18 Pro Max 256Gb Silver ( без RuStore )', 137990, 'apple/18pro/silver.png', 'apple/iphone/iphone-18-pro-max/iphone-18-pro-max-256gb-silver-bez-rustore'],
    [15, 'iPhone 18 Pro 256Gb Burgundy ( без RuStore )', 125990, 'apple/18pro/burgundy.png', 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-burgundy-bez-rustore'],
    [16, 'iPhone 18 Pro 256Gb Glacier ( без RuStore )', 118990, 'apple/18pro/glacier.png', 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-glacier-bez-rustore'],
    [17, 'iPhone 18 Pro 256Gb Black ( без RuStore )', 118990, 'apple/18pro/black.png', 'apple/iphone/iphone-18-pro/iphone-18-pro-256gb-black-bez-rustore']
  ].map(a => ({ n: a[0], id: a[4], name: a[1], price: a[2], local: a[3], url: a[4], cat: a[4].split('/').slice(0, 2).join('/'), cats: [a[4].split('/').slice(0, 2).join('/')] }));
  const byId = new Map(products.map(p => [p.id, p]));
  FEATURED.forEach(p => byId.set(p.id, p));
  const feat = n => FEATURED.find(p => p.n === n);
  const imgSrc = p => p.local ? LOCAL + p.local : REMOTE + p.img;
  const link = p => 'https://jjstore.ru/' + p.url;
  const rm = p => p.local ? '' : ' class="rm"';
  const catUrl = slug => 'https://jjstore.ru/' + slug;
  const isVariant = s => /^[\d.,\s]*(gb|tb|гб|тб|mm|мм|мл|"|дюйм)/i.test(cats[s][0].trim());
  const visKids = s => (kids[s] || []).filter(k => !isVariant(k) && catCount[k]);
  const chainOf = slug => { const chain = []; let c = slug; while (c && cats[c]) { chain.unshift(c); c = cats[c][1]; } return chain; };
  const descendants = slug => { const out = [slug]; (kids[slug] || []).forEach(k => out.push(...descendants(k))); return out; };
  const catCount = {};
  products.forEach(p => { const seen = new Set(); p.cats.forEach(c0 => { let c = c0; while (c && cats[c] && !seen.has(c)) { seen.add(c); catCount[c] = (catCount[c] || 0) + 1; c = cats[c][1]; } }); });
  const prodsOf = slug => { const set = new Set(descendants(slug)); return products.filter(p => p.cats.some(c => set.has(c))); };

  document.addEventListener('error', e => { const t = e.target; if (t && t.tagName === 'IMG') { if (t.dataset.hide) { t.remove(); return; } if (!t.dataset.fb) { t.dataset.fb = 1; t.src = PLACE; } } }, true);

  const card = (p, o = {}) => `
    <article class="card" data-id="${esc(p.id)}">
      ${o.isNew ? '<span class="badge-new">Новинка</span>' : ''}
      <button class="heart ${wish.has(p.id) ? 'on' : ''}" data-act="wish" data-id="${esc(p.id)}" aria-label="В закладки">${ICON.heart}</button>
      <button class="img" data-act="view" data-id="${esc(p.id)}" aria-label="Быстрый просмотр"><img${rm(p)} src="${esc(imgSrc(p))}" alt="${esc(p.name)}" loading="lazy"></button>
      <h4 data-act="view" data-id="${esc(p.id)}">${esc(p.name)}</h4>
      <div class="price">${fmt(p.price)}</div>
      <div class="slot" data-id="${esc(p.id)}"></div>
    </article>`;

  let wish = new Set();
  try { wish = new Set(JSON.parse(localStorage.getItem('jj-wish') || '[]')); } catch (e) {}
  const saveWish = () => { try { localStorage.setItem('jj-wish', JSON.stringify([...wish])); } catch (e) {} };

  let cart = {};
  try {
    const raw = JSON.parse(localStorage.getItem('jj-cart2') || 'null');
    if (raw && typeof raw === 'object') {
      Object.entries(raw).forEach(([k, n]) => { const id = /^\d+$/.test(k) ? feat(+k)?.id : k; if (id) cart[id] = (cart[id] || 0) + n; });
    }
  } catch (e) {}
  const saveCart = () => { try { localStorage.setItem('jj-cart2', JSON.stringify(cart)); } catch (e) {} };
  const qtyOf = id => cart[id] || 0;
  const totalQty = () => Object.values(cart).reduce((s, n) => s + n, 0);
  const totalSum = () => Object.entries(cart).reduce((s, [id, n]) => s + (byId.get(id)?.price || 0) * n, 0);
  const stepper = id => `<div class="step" data-id="${esc(id)}"><button data-act="dec" aria-label="Меньше">−</button><b>${qtyOf(id)}</b><button data-act="inc" aria-label="Больше">+</button></div>`;
  const syncSlots = only => $$('.slot').forEach(s => {
    const id = s.dataset.id; if (only && id !== only) return;
    const n = qtyOf(id), has = !!s.querySelector('.step');
    if (n && has) { s.querySelector('.step b').textContent = n; return; }
    s.innerHTML = n ? stepper(id) : `<button class="buy" data-act="inc" data-id="${esc(id)}">В корзину</button>`;
  });
  const syncHearts = () => $$('[data-act="wish"]').forEach(b => b.classList.toggle('on', wish.has(b.dataset.id)));

  const cartModal = $('#cartModal'), wModal = $('#wModal'), pModal = $('#pModal');
  const openModal = m => { $$('.modal.on').forEach(x => x.classList.remove('on')); m.classList.add('on'); m.setAttribute('aria-hidden', 'false'); document.body.classList.add('lock'); };
  const closeModals = () => { $$('.modal.on').forEach(x => { x.classList.remove('on'); x.setAttribute('aria-hidden', 'true'); }); document.body.classList.remove('lock'); };
  const openCart = () => { renderCart(); openModal(cartModal); };
  $('#openCart').onclick = openCart;
  $('#openWish').onclick = () => { renderWish(); openModal(wModal); };
  document.addEventListener('keydown', e => { if (e.key === 'Escape') { closeModals(); hideMega(); } });

  function renderCart(only) {
    const ids = Object.keys(cart).filter(id => byId.get(id));
    const qty = totalQty(), box = $('#cartItems');
    cartModal.classList.toggle('is-empty', !ids.length);
    box.innerHTML = ids.length ? ids.map(id => {
      const p = byId.get(id);
      return `<article class="ci" data-id="${esc(id)}">
        <button class="ci-img" data-act="view" data-id="${esc(id)}"><img${rm(p)} src="${esc(imgSrc(p))}" alt=""></button>
        <div class="ci-main"><b>${esc(p.name)}</b><small>${fmt(p.price)} за шт.</small>
          <div class="ci-row">${stepper(id)}<span class="ci-sum">${fmt(p.price * qtyOf(id))}</span></div></div>
        <button class="ci-del" data-act="del" aria-label="Удалить" title="Удалить">${ICON.trash}</button>
      </article>`;
    }).join('') : `<div class="empty">
        <span class="e-ico">${ICON.bag}</span>
        <b>В корзине пока пусто</b><p>Добавьте товары, и они появятся здесь</p>
        <button class="btn" data-close>К покупкам</button></div>`;
    $('#sumQty').textContent = qty;
    $('#cartTotal').textContent = fmt(totalSum());
    $('#cartMeta').textContent = qty ? `${qty} ${plural(qty, 'товар', 'товара', 'товаров')}` : '';
    const c = $('#cartCount'); c.textContent = qty; c.classList.toggle('on', qty > 0);
    syncSlots(only); syncMini();
  }
  function renderWish() {
    const ids = [...wish].filter(id => byId.get(id)), box = $('#wishItems');
    box.innerHTML = ids.length ? ids.map(id => {
      const p = byId.get(id);
      return `<article class="ci" data-id="${esc(id)}">
        <button class="ci-img" data-act="view" data-id="${esc(id)}"><img${rm(p)} src="${esc(imgSrc(p))}" alt=""></button>
        <div class="ci-main"><b>${esc(p.name)}</b><small>${fmt(p.price)}</small>
          <div class="ci-row"><div class="slot" data-id="${esc(id)}"></div></div></div>
        <button class="ci-del" data-act="wish" data-id="${esc(id)}" aria-label="Убрать из закладок" title="Убрать из закладок">${ICON.trash}</button>
      </article>`;
    }).join('') : `<div class="empty">
        <span class="e-ico">${ICON.heart}</span>
        <b>В закладках пока пусто</b><p>Нажмите на сердечко у товара, чтобы сохранить его</p>
        <button class="btn" data-close>К покупкам</button></div>`;
    $('#wishMeta').textContent = ids.length ? `${ids.length} ${plural(ids.length, 'товар', 'товара', 'товаров')}` : '';
    const c = $('#wishCount'); c.textContent = ids.length; c.classList.toggle('on', ids.length > 0);
    syncSlots();
  }
  function bump(sel) { const c = $(sel); c.classList.remove('bump'); void c.offsetWidth; c.classList.add('bump'); }

  const DESC = window.DESC || { c: {}, m: {}, d: {} };
  const nameKey = p => norm(p.name).replace(/\s+/g, ' ');
  const byName = new Map(products.map(p => [nameKey(p) + '|' + p.price, p]));
  function descFor(p) {
    const q = byName.get(nameKey(p) + '|' + p.price);
    const u = DESC.m[p.url] ? p.url : (q && DESC.m[q.url] ? q.url : null);
    return { code: DESC.c[p.url] || (q && DESC.c[q.url]) || '', d: u ? DESC.d[DESC.m[u]] : null };
  }
  function descHtml(p) {
    const { code, d } = descFor(p);
    if (!d && !code) return '';
    const [hl, paras, imgs] = d || [[], [], []];
    let text = '', buf = '';
    const flush = () => { if (buf) { text += `<p>${esc(buf)}</p>`; buf = ''; } };
    paras.forEach(t => {
      if (t.length <= 48 && !/[.!?,;:…]$/.test(t)) { flush(); text += `<h4>${esc(t)}</h4>`; }
      else { buf += (buf ? ' ' : '') + t; if (/[.!?]$/.test(t) && buf.length > 140) flush(); }
    });
    flush();
    return `<section class="pq-desc">
      <h3>Описание${code ? `<small>Код товара: ${esc(code)}</small>` : ''}</h3>
      ${hl.length ? `<ul class="hl">${hl.map(t => `<li>${esc(t)}</li>`).join('')}</ul>` : ''}
      ${text ? `<div class="txt" id="descTxt">${text}</div><button class="txt-more" id="descMore" type="button">Читать полностью</button>` : ''}
      ${imgs.length ? `<div class="d-imgs">${imgs.map(s => `<img src="https://${esc(s)}" alt="" loading="lazy" data-hide="1">`).join('')}</div>` : ''}
    </section>`;
  }

  function openProduct(id) {
    const p = byId.get(id); if (!p) return;
    const chain = chainOf(p.cat);
    const rel = products.filter(x => x.id !== p.id && x.cats.includes(p.cat)).slice(0, 4);
    $('#pBody').innerHTML = `
      <button class="m-x pq-x" data-close aria-label="Закрыть"><svg viewBox="0 0 24 24"><path d="M6 6l12 12M18 6 6 18"/></svg></button>
      <div class="pq-grid">
        <div class="pq-img"><img${rm(p)} src="${esc(imgSrc(p))}" alt="${esc(p.name)}"></div>
        <div class="pq-info">
          <small class="pq-cat">${chain.map(c => esc(cats[c][0])).join(' · ') || 'Каталог'}</small>
          <h2>${esc(p.name)}</h2>
          <div class="pq-price">${fmt(p.price)}</div>
          <div class="pq-actions">
            <div class="slot" data-id="${esc(p.id)}"></div>
            <button class="pq-wish ${wish.has(p.id) ? 'on' : ''}" data-act="wish" data-id="${esc(p.id)}">${ICON.heart}<span>В закладки</span></button>
          </div>
          <div class="info">
            <div class="info-b"><span class="i-ico">${ICON.pin}</span><div><b>Самовывоз</b><small>ул. Театральная, 19 · 11:00–20:00</small></div></div>
            <a class="info-b" href="https://jjstore.ru/delivery" target="_blank" rel="noopener"><span class="i-ico">${ICON.truck}</span><div><b>Доставка и оплата</b><small>Условия на сайте</small></div></a>
          </div>
          <a class="pq-ext" href="${esc(link(p))}" target="_blank" rel="noopener">Страница товара на jjstore.ru ${ICON.ext}</a>
        </div>
      </div>
      ${descHtml(p)}
      ${rel.length ? `<div class="pq-rel"><b>Ещё в этой категории</b><div class="rel-row">${rel.map(r => `<button class="rel" data-act="view" data-id="${esc(r.id)}"><img${rm(r)} src="${esc(imgSrc(r))}" alt="" loading="lazy"><span>${esc(r.name)}</span><em>${fmt(r.price)}</em></button>`).join('')}</div></div>` : ''}`;
    syncSlots(); openModal(pModal); $('#pBody').scrollTop = 0;
  }

  document.addEventListener('click', e => {
    if (e.target.closest('#descMore')) { const t = $('#descTxt'); const o = t.classList.toggle('open'); e.target.closest('#descMore').textContent = o ? 'Свернуть' : 'Читать полностью'; return; }
    const close = e.target.closest('[data-close]');
    if (close && close.closest('.modal')) { closeModals(); return; }
    const a = e.target.closest('[data-act]');
    if (a) {
      const holder = a.closest('[data-id]'); const id = a.dataset.id || holder?.dataset.id;
      const act = a.dataset.act;
      if (act === 'view') { openProduct(id); return; }
      if (!id) return;
      if (act === 'inc') { cart[id] = Math.min(99, qtyOf(id) + 1); bump('#cartCount'); }
      else if (act === 'dec') { cart[id] = qtyOf(id) - 1; if (cart[id] <= 0) delete cart[id]; }
      else if (act === 'del') { delete cart[id]; }
      else if (act === 'wish') {
        if (wish.has(id)) wish.delete(id); else { wish.add(id); bump('#wishCount'); }
        saveWish(); syncHearts();
        const wc = $('#wishCount'); wc.textContent = [...wish].filter(x => byId.get(x)).length; wc.classList.toggle('on', wish.size > 0);
        if (wModal.classList.contains('on')) renderWish();
        return;
      }
      saveCart(); renderCart(id);
      return;
    }

    const l = e.target.closest('a[href^="https://jjstore.ru/"]');
    if (l && !e.metaKey && !e.ctrlKey) {
      const path = l.getAttribute('href').replace('https://jjstore.ru/', '').split('?')[0].split('/').filter(Boolean).join('/');
      if (path && cats[path] && !l.hasAttribute('data-ext')) { e.preventDefault(); closeModals(); location.hash = '#/c/' + path; }
    }
  });
  $('#cartClear').onclick = () => { cart = {}; saveCart(); renderCart(); };

  const NEW_IDS = [13, 15, 16, 14, 17, 11, 6, 3, 9], POP_IDS = [1, 2, 4, 8, 7, 5, 10, 12];
  $('#trackNew').innerHTML = NEW_IDS.map(n => card(feat(n), { isNew: true })).join('');
  $('#trackPop').innerHTML = POP_IDS.map(n => card(feat(n))).join('');
  $$('.scroller').forEach(sc => {
    const tr = sc.querySelector('.track'), row = sc.closest('.row');
    const pv = row && row.querySelector('.pager .prev'), nx = row && row.querySelector('.pager .next');
    if (!pv) return;
    const step = () => Math.max(tr.clientWidth * .8, 240);
    pv.onclick = () => tr.scrollBy({ left: -step(), behavior: 'smooth' });
    nx.onclick = () => tr.scrollBy({ left: step(), behavior: 'smooth' });
    const upd = () => { pv.classList.toggle('off', tr.scrollLeft < 8); nx.classList.toggle('off', tr.scrollLeft + tr.clientWidth > tr.scrollWidth - 8); };
    tr.addEventListener('scroll', upd, { passive: true }); upd();
  });

  (function () {
    const tr = $('#trackNew'); if (!tr || matchMedia('(prefers-reduced-motion:reduce)').matches) return;
    const SPEED = 38;
    let pos = 0, dir = 1, last = 0, paused = false, resumeT, visible = false, raf = 0;
    const pause = () => { paused = true; clearTimeout(resumeT); };
    const resume = (ms = 1800) => { clearTimeout(resumeT); resumeT = setTimeout(() => { paused = false; pos = tr.scrollLeft; }, ms); };
    ['pointerenter', 'pointerdown', 'touchstart', 'focusin'].forEach(ev => tr.addEventListener(ev, pause, { passive: true }));
    ['pointerleave', 'touchend', 'focusout'].forEach(ev => tr.addEventListener(ev, () => resume(), { passive: true }));
    tr.addEventListener('wheel', () => { pause(); resume(2200); }, { passive: true });
    $('#trackNew').closest('.row').querySelectorAll('.pager button').forEach(b => b.addEventListener('click', () => { pause(); resume(2600); }));
    const tick = t => {
      raf = requestAnimationFrame(tick);
      const dt = Math.min(64, t - (last || t)); last = t;
      if (paused || !visible || !tr.offsetParent) return;
      const max = tr.scrollWidth - tr.clientWidth; if (max <= 0) return;
      if (Math.abs(tr.scrollLeft - pos) > 2) pos = tr.scrollLeft;
      pos += dir * SPEED * dt / 1000;
      if (pos >= max) { pos = max; dir = -1; } else if (pos <= 0) { pos = 0; dir = 1; }
      tr.scrollLeft = pos;
    };
    if ('IntersectionObserver' in window) new IntersectionObserver(es => { visible = es[0].isIntersecting; }, { threshold: .2 }).observe(tr); else visible = true;
    tr.classList.add('auto');
    raf = requestAnimationFrame(tick);
  })();

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

    if (matchMedia('(hover:hover) and (pointer:fine)').matches) slides.forEach(s => {
      const im = s.querySelector('img');
      s.addEventListener('pointermove', e => { const r = s.getBoundingClientRect(); im.style.translate = `${((e.clientX - r.left) / r.width - .5) * -18}px ${((e.clientY - r.top) / r.height - .5) * -12}px`; });
      s.addEventListener('pointerleave', () => { im.style.translate = ''; });
    });
    mark(); onChange(); play();
    window.addEventListener('homeshown', () => requestAnimationFrame(() => { go(cur); mark(); }));
  })();

  const home = $('#home'), catalog = $('#catalog');
  const PAGE = 24;
  function searchProducts(q) {
    const toks = norm(q).split(/\s+/).filter(Boolean); if (!toks.length) return [];
    const out = [];
    for (const p of products) {
      const n = norm(p.name); let score = 0, ok = true;
      for (const t of toks) { const i = n.indexOf(t); if (i < 0) { ok = false; break; } score += i === 0 ? 3 : (n[i - 1] === ' ' ? 2 : 1); }
      if (ok) out.push([score, p]);
    }
    return out.sort((a, b) => b[0] - a[0]).map(x => x[1]);
  }
  const SORTS = [['pop', 'Популярные'], ['asc', 'Дешевле'], ['desc', 'Дороже'], ['az', 'А–Я']];
  let CS = null;
  function showCatalog(route) {
    home.hidden = true; catalog.hidden = false; document.body.classList.add('in-catalog');
    catalog.classList.remove('view-in'); void catalog.offsetWidth; catalog.classList.add('view-in');
    hideMega();
    const isSearch = route.q != null;
    const slug = route.cat;
    const base = isSearch ? searchProducts(route.q) : prodsOf(slug);
    const title = isSearch ? `Поиск: «${route.q}»` : (cats[slug]?.[0] || 'Каталог');
    const chain = isSearch ? [] : chainOf(slug);
    const subs = isSearch ? [] : (visKids(slug).length ? visKids(slug) : (cats[slug] && cats[cats[slug][1]] ? visKids(cats[slug][1]) : []));
    const parentSlug = (!isSearch && !visKids(slug).length && cats[slug] && cats[cats[slug][1]]) ? cats[slug][1] : slug;
    CS = { base, sort: 'pop', min: '', max: '', shown: PAGE };
    const ext = isSearch ? `https://jjstore.ru/index.php?route=product/search&search=${encodeURIComponent(route.q)}` : catUrl(slug);
    catalog.innerHTML = `
      <nav class="crumbs" aria-label="Навигация"><a href="#/">Главная</a>${isSearch ? '<i>' + ICON.chev + '</i><span>Поиск</span>' : chain.map((c, i) => `<i>${ICON.chev}</i>${i === chain.length - 1 ? `<span>${esc(cats[c][0])}</span>` : `<a href="#/c/${c}">${esc(cats[c][0])}</a>`}`).join('')}</nav>
      <div class="cat-head"><h1>${esc(title)}<small id="catCount"></small></h1>
        <a class="ext-link" href="${esc(ext)}" target="_blank" rel="noopener" data-ext>На jjstore.ru ${ICON.ext}</a></div>
      ${subs.length ? `<div class="chips-row">${!isSearch && parentSlug !== slug ? `<a class="chip2" href="#/c/${parentSlug}">Все ${esc(cats[parentSlug][0])}</a>` : ''}${subs.map(s => `<a class="chip2 ${s === slug ? 'on' : ''}" href="#/c/${s}">${esc(cats[s][0])}<em>${catCount[s] || 0}</em></a>`).join('')}</div>` : ''}
      <div class="toolbar glass">
        <div class="seg" id="sortSeg">${SORTS.map(([k, t], i) => `<button data-sort="${k}" class="${i ? '' : 'on'}">${t}</button>`).join('')}</div>
        <div class="price-f"><label>Цена от<input id="pMin" inputmode="numeric" placeholder="0"></label><label>до<input id="pMax" inputmode="numeric" placeholder="∞"></label><button id="pReset" type="button">Сбросить</button></div>
      </div>
      <div class="grid" id="catGrid"></div>
      <div class="more-wrap"><button class="btn-more" id="catMore">Показать ещё</button></div>`;
    renderCatGrid(true);
    document.title = `${title} — JJstore`;
    scrollTo({ top: 0, behavior: 'instant' });
  }
  function filtered() {
    const min = parseInt(CS.min.replace(/\D/g, ''), 10) || 0, max = parseInt(CS.max.replace(/\D/g, ''), 10) || Infinity;
    let list = CS.base.filter(p => p.price >= min && p.price <= max);
    if (CS.sort === 'asc') list = [...list].sort((a, b) => a.price - b.price);
    else if (CS.sort === 'desc') list = [...list].sort((a, b) => b.price - a.price);
    else if (CS.sort === 'az') list = [...list].sort((a, b) => a.name.localeCompare(b.name, 'ru'));
    return list;
  }
  function renderCatGrid(reset) {
    if (reset) CS.shown = PAGE;
    const list = filtered(), grid = $('#catGrid'), more = $('#catMore');
    $('#catCount').textContent = `${list.length} ${plural(list.length, 'товар', 'товара', 'товаров')}`;
    grid.innerHTML = list.length ? list.slice(0, CS.shown).map(p => card(p)).join('') : `<div class="empty wide"><span class="e-ico">${ICON.bag}</span><b>Ничего не найдено</b><p>Попробуйте изменить запрос или фильтры, либо поищите на jjstore.ru</p></div>`;
    $$('.card', grid).forEach((c, i) => c.style.animationDelay = Math.min(i, 12) * 35 + 'ms');
    const left = list.length - CS.shown;
    more.parentElement.hidden = left <= 0; more.textContent = `Показать ещё ${Math.min(left, PAGE)}`;
    syncSlots();
  }
  catalog.addEventListener('click', e => {
    const s = e.target.closest('[data-sort]');
    if (s) { CS.sort = s.dataset.sort; $$('#sortSeg button').forEach(b => b.classList.toggle('on', b === s)); renderCatGrid(true); }
    if (e.target.closest('#catMore')) { CS.shown += PAGE; renderCatGrid(false); }
    if (e.target.closest('#pReset')) { CS.min = CS.max = ''; $('#pMin').value = $('#pMax').value = ''; renderCatGrid(true); }
  });
  let ft; catalog.addEventListener('input', e => {
    if (e.target.id === 'pMin' || e.target.id === 'pMax') { CS.min = $('#pMin').value; CS.max = $('#pMax').value; clearTimeout(ft); ft = setTimeout(() => renderCatGrid(true), 220); }
  });
  function showHome() {
    catalog.hidden = true; home.hidden = false; document.body.classList.remove('in-catalog');
    home.classList.remove('view-in'); void home.offsetWidth; home.classList.add('view-in'); document.title = 'JJstore — оригинальная техника в Воронеже';
    window.dispatchEvent(new Event('homeshown'));
  }
  function route() {
    const h = decodeURIComponent(location.hash || '');
    let m;
    if ((m = h.match(/^#\/c\/([a-z0-9\/-]+)/)) && cats[m[1]]) showCatalog({ cat: m[1] });
    else if ((m = h.match(/^#\/s\/(.+)/))) showCatalog({ q: m[1] });
    else showHome();
  }
  addEventListener('hashchange', route);

  const mega = $('#mega'), headEl = $('#head');
  let megaT, megaFor = '';
  function hideMega() { clearTimeout(megaT); mega.classList.remove('on'); mega.setAttribute('aria-hidden', 'true'); megaFor = ''; }
  function showMega(slug) {
    const subs = visKids(slug); if (!subs.length) { hideMega(); return; }
    clearTimeout(megaT);
    if (megaFor !== slug) {
      mega.innerHTML = `<div class="mega-head"><b>${esc(cats[slug][0])}</b><a href="#/c/${slug}">Показать все · ${catCount[slug] || 0}${ICON.chev}</a></div>
        <div class="mega-grid">${subs.map(s => `<a href="#/c/${s}"><span>${esc(cats[s][0])}</span><em>${catCount[s] || 0}</em></a>`).join('')}</div>`;
      megaFor = slug;
    }
    mega.classList.add('on'); mega.setAttribute('aria-hidden', 'false');
  }
  if (matchMedia('(hover:hover) and (pointer:fine)').matches) {
    $$('.brands a').forEach(a => {
      const path = a.getAttribute('href').replace('https://jjstore.ru/', '').split('/').filter(Boolean).join('/');
      a.addEventListener('pointerenter', () => showMega(path));
    });
    headEl.addEventListener('pointerleave', () => { megaT = setTimeout(hideMega, 180); });
    mega.addEventListener('pointerenter', () => clearTimeout(megaT));
    mega.addEventListener('click', () => hideMega());
  }
  headEl.addEventListener('click', e => { if (e.target.closest('.brands a')) hideMega(); });

  $('.logo').addEventListener('click', e => { e.preventDefault(); if (location.hash && location.hash !== '#/') location.hash = '#/'; else scrollTo({ top: 0, behavior: 'smooth' }); });

  const input = $('#search'), res = $('#results');
  const sugg = ['iPhone 18', 'iPhone 17', 'AirPods', 'PlayStation', 'Dyson', 'MacBook'];
  const showSugg = () => { res.innerHTML = '<div class="sugg"><small>Популярные запросы</small>' + sugg.map(s => `<button type="button" data-q="${s}">${s}</button>`).join('') + '</div>'; res.classList.add('on'); };
  input.addEventListener('input', () => {
    const q = input.value.trim();
    if (!q) { showSugg(); return; }
    const found = searchProducts(q), top = found.slice(0, 6);
    res.innerHTML = top.length
      ? top.map(p => `<button class="sr" data-act="view" data-id="${esc(p.id)}"><img${rm(p)} src="${esc(imgSrc(p))}" alt="" loading="lazy"><b>${esc(p.name)}</b><span>${fmt(p.price)}</span></button>`).join('') +
        `<a class="sr-all" href="#/s/${encodeURIComponent(q)}">Все результаты · ${found.length}${ICON.chev}</a>`
      : '<em>Ничего не найдено</em>';
    res.classList.add('on');
  });
  input.addEventListener('focus', () => { if (!input.value.trim()) showSugg(); });
  input.addEventListener('keydown', e => { if (e.key === 'Enter' && input.value.trim()) { location.hash = '#/s/' + encodeURIComponent(input.value.trim()); res.classList.remove('on'); input.blur(); } });
  res.addEventListener('click', e => {
    const b = e.target.closest('[data-q]'); if (b) { input.value = b.dataset.q; input.dispatchEvent(new Event('input')); input.focus(); return; }
    if (e.target.closest('.sr, .sr-all')) res.classList.remove('on');
  });
  document.addEventListener('click', e => { if (!e.target.closest('.search')) res.classList.remove('on'); });
  document.addEventListener('keydown', e => { if (e.key === '/' && !/INPUT|TEXTAREA/.test(document.activeElement.tagName)) { e.preventDefault(); input.focus(); } });

  if (matchMedia('(hover:hover) and (pointer:fine)').matches) {
    document.addEventListener('pointermove', e => {
      const g = e.target.closest && e.target.closest('.glass'); if (!g) return;
      const r = g.getBoundingClientRect();
      g.style.setProperty('--mx', (e.clientX - r.left) + 'px'); g.style.setProperty('--my', (e.clientY - r.top) + 'px');
    }, { passive: true });
  }

  function startReveal() {
    document.querySelectorAll('.wall .tile').forEach((t, i) => { t.dataset.reveal = ''; t.style.setProperty('--d', (i % 6) * 55 + 'ms'); });
    const all = document.querySelectorAll('[data-reveal]');
    if (!('IntersectionObserver' in window)) { all.forEach(e => e.classList.add('in')); return; }
    const io = new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } }), { threshold: .08, rootMargin: '0px 0px -4% 0px' });
    all.forEach(el => io.observe(el));
  }

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

  (function () {
    const nav = $('.brands'); if (!nav || !matchMedia('(hover:hover)').matches) return;
    const ind = document.createElement('i'); ind.className = 'ind'; nav.prepend(ind);
    nav.querySelectorAll('a').forEach(a => {
      a.addEventListener('pointerenter', () => { ind.style.cssText = `opacity:1;width:${a.offsetWidth}px;height:${a.offsetHeight}px;transform:translate(${a.offsetLeft}px,${a.offsetTop}px)`; });
    });
    nav.addEventListener('pointerleave', () => { ind.style.opacity = 0; });
  })();

  (function () {
    const head = $('#head'); let y = scrollY, ticking = false;
    const measure = () => { if (head.classList.contains('compact')) return; const h = head.firstElementChild.offsetHeight; if (h) { head.style.setProperty('--bh', h + 'px'); head.style.setProperty('--hh', (h + 22) + 'px'); } };
    measure(); addEventListener('resize', measure); addEventListener('load', measure); setTimeout(measure, 400);
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

  const mini = $('#miniCart');
  function syncMini() {
    const q = totalQty(); mini.classList.toggle('on', q > 0 && !cartModal.classList.contains('on'));
    $('#mcQty').textContent = q; $('#mcSum').textContent = fmt(totalSum());
    $('#mcLabel').textContent = `${q} ${plural(q, 'товар', 'товара', 'товаров')}`;
  }
  mini.onclick = openCart;
  new MutationObserver(syncMini).observe(cartModal, { attributes: true, attributeFilter: ['class'] });

  (function () {
    const c = $('#cookie'); let ok = false;
    try { ok = localStorage.getItem('jj-cookie') === '1'; } catch (e) {}
    if (!ok) c.hidden = false;
    $('#cookieOk').onclick = () => { c.hidden = true; try { localStorage.setItem('jj-cookie', '1'); } catch (e) {} };
  })();

  (function () {
    const h = $('#help'), b = $('#helpBtn'), p = $('#helpPanel');
    const set = on => { h.classList.toggle('open', on); b.setAttribute('aria-expanded', on); p.setAttribute('aria-hidden', !on); };
    b.onclick = () => set(!h.classList.contains('open'));
    document.addEventListener('click', e => { if (!e.target.closest('#help')) set(false); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') set(false); });
  })();

  renderCart(); renderWish(); route();
})();
