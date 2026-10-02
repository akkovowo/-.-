(() => {
  const $ = (s, c = document) => c.querySelector(s);
  const $$ = (s, c = document) => [...c.querySelectorAll(s)];
  const IMG = 'assets/img/';
  const fmt = n => n.toLocaleString('ru-RU').replace(/ /g, ' ') + ' ₽';

  const PRODUCTS = [
    { id: 1, cat: 'iphone', name: 'iPhone 17 Pro Max Silver 256Gb', price: 106990, img: 'apple/17pro/iphone-17-pro-silver-400x280.png', url: 'apple/iphone/iphone-17-pro-max-1/256gb-56/iphone-17-pro-max-silver-256g' },
    { id: 2, cat: 'iphone', name: 'iPhone 17 Pro Deep Blue 256Gb', price: 98990, img: 'apple/17pro/iphone-17-pro-deepblue-400x280.png', url: 'apple/iphone/iphone-17-pro-1/256gb-55/iphone-17-pro-deep-blue-256gb-bez' },
    { id: 3, cat: 'iphone', name: 'iPhone 17 Black 256Gb', price: 78990, img: 'apple/iphone17/08ed48e6-8718-4703-91bd-35e0c0490348-400x280.jpg', url: 'apple/iphone/iphone-17-1/256gb-24/iphone-17-black-256gb-bez-rustore' },
    { id: 4, cat: 'iphone', name: 'iPhone 16 Black 128Gb', price: 65990, img: 'iphone16/black/iphone_16_black-transformed-400x280.png', url: 'apple/iphone/iphone-16/128gb-7/iphone-16-black-128gb-bez-rustore' },
    { id: 5, cat: 'iphone', name: 'iPhone 15 Blue 128Gb', price: 56990, img: 'apple/iphone15/i15blue-400x280.jpg', url: 'apple/iphone/iphone-15/128gb-21/iphone-15-blue-128gb-bez-rustore' },
    { id: 6, cat: 'iphone', name: 'iPhone 15 Black 256Gb', price: 66990, img: 'apple/iphone15/i15black-400x280.jpg', url: 'apple/iphone/iphone-15/256gb-25/iphone-15-black-256gb-bez-rustore' },
    { id: 7, cat: 'airpods', name: 'AirPods 4 с активным шумоподавлением', price: 13490, img: 'airpods4/airpods_4_noise-400x280.png', url: 'apple/airpods/airpods-4/airpods-4-s-aktivnym-shumopodavleniem' },
    { id: 8, cat: 'airpods', name: 'AirPods 4', price: 10490, img: 'airpods4/airpods_4-400x280.png', url: 'apple/airpods/airpods-4/airpods-4-1' },
    { id: 9, cat: 'gaming', name: 'Sony PlayStation 5 Slim DVD', price: 71990, img: 'sony/a6d2fe363c2044d784357374213b0218-400x280.jpg', url: 'sony/playstation-1/ps5/sony-playstation-5-slim-dvd' },
    { id: 10, cat: 'acc', name: 'Блок USB-C 20W iPhone', price: 2990, img: 'iphone/aksessuary/blok-usb-c-20w-iphone-400x280.jpg', url: 'apple/aksessuary-1/blok-pitaniya/apple-10/blok-usb-c-20w-iphone' },
  ];
  const byId = id => PRODUCTS.find(p => p.id === id);
  const link = p => 'https://jjstore.ru/' + p.url;

  /* ---------- Products ---------- */
  const grid = $('#productGrid');
  function renderProducts(f = 'all') {
    grid.innerHTML = '';
    PRODUCTS.filter(p => f === 'all' || p.cat === f).forEach((p, i) => {
      const el = document.createElement('article');
      el.className = 'card glass tilt';
      el.style.animationDelay = i * 60 + 'ms';
      el.innerHTML = `
        <a class="img" href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt="${p.name}" loading="lazy"></a>
        <h4>${p.name}</h4>
        <div class="row"><span class="price">${fmt(p.price)}</span>
        <button class="add" data-id="${p.id}" aria-label="В корзину">+</button></div>`;
      grid.appendChild(el);
    });
    bindFx();
  }
  $('#filters').addEventListener('click', e => {
    const b = e.target.closest('.chip'); if (!b) return;
    $$('.chip').forEach(c => c.classList.toggle('active', c === b));
    renderProducts(b.dataset.f);
  });

  /* ---------- Cart ---------- */
  let cart = [];
  try { cart = JSON.parse(localStorage.getItem('jj-cart') || '[]'); } catch (e) {}
  const save = () => { try { localStorage.setItem('jj-cart', JSON.stringify(cart)); } catch (e) {} };
  function renderCart() {
    const box = $('#cartItems');
    box.innerHTML = cart.length ? '' : '<div class="empty">Корзина пуста.<br>Добавьте что-нибудь классное ✨</div>';
    cart.forEach((id, i) => {
      const p = byId(id); if (!p) return;
      const d = document.createElement('div'); d.className = 'ci';
      d.innerHTML = `<img src="${IMG + p.img}" alt=""><div><b>${p.name}</b><span>${fmt(p.price)}</span></div><button data-i="${i}" aria-label="Удалить">×</button>`;
      box.appendChild(d);
    });
    $('#cartTotal').textContent = fmt(cart.reduce((s, id) => s + (byId(id)?.price || 0), 0));
    const c = $('#cartCount'); c.textContent = cart.length; c.classList.toggle('on', cart.length > 0);
  }
  const drawer = $('#drawer'), scrim = $('#scrim');
  const openCart = () => { drawer.classList.add('open'); scrim.classList.add('open'); };
  const closeAll = () => { drawer.classList.remove('open'); scrim.classList.remove('open'); $('#searchOverlay').classList.remove('open'); $('#mobileMenu').classList.remove('open'); };
  $('#openCart').onclick = openCart; $('#closeCart').onclick = closeAll; scrim.onclick = closeAll;
  $('#cartItems').addEventListener('click', e => { const b = e.target.closest('button'); if (!b) return; cart.splice(+b.dataset.i, 1); save(); renderCart(); });
  document.addEventListener('click', e => {
    const b = e.target.closest('.add'); if (!b) return;
    cart.push(+b.dataset.id); save(); renderCart();
    b.classList.add('done'); b.textContent = '✓'; setTimeout(() => { b.classList.remove('done'); b.textContent = '+'; }, 1100);
  });

  /* ---------- Search ---------- */
  const so = $('#searchOverlay'), si = $('#searchInput'), sr = $('#searchResults');
  const openSearch = () => { so.classList.add('open'); setTimeout(() => si.focus(), 60); };
  $('#openSearch').onclick = openSearch;
  so.addEventListener('click', e => { if (e.target === so) closeAll(); });
  si.addEventListener('input', () => {
    const q = si.value.trim().toLowerCase();
    const res = q ? PRODUCTS.filter(p => p.name.toLowerCase().includes(q)) : [];
    sr.innerHTML = res.map(p => `<a class="sr" href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt=""><b>${p.name}</b><span>${fmt(p.price)}</span></a>`).join('')
      || (q ? '<div class="empty" style="padding:24px">Ничего не нашли — поищите на jjstore.ru</div>' : '');
  });
  document.addEventListener('keydown', e => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') { e.preventDefault(); openSearch(); }
    if (e.key === 'Escape') closeAll();
  });

  /* ---------- Mobile menu ---------- */
  $('#burger').onclick = () => $('#mobileMenu').classList.toggle('open');
  $$('#mobileMenu a').forEach(a => a.addEventListener('click', closeAll));

  /* ---------- Nav on scroll + active link ---------- */
  const nav = $('#nav');
  addEventListener('scroll', () => nav.classList.toggle('scrolled', scrollY > 30), { passive: true });
  const links = $$('.nav-links a');
  const secObs = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) links.forEach(l => l.classList.toggle('active', l.getAttribute('href') === '#' + e.target.id));
  }), { rootMargin: '-45% 0px -50% 0px' });
  $$('section[id]').forEach(s => secObs.observe(s));

  /* ---------- Reveal ---------- */
  const rev = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) { e.target.style.transitionDelay = (e.target.dataset.d || 0) + 'ms'; e.target.classList.add('in'); rev.unobserve(e.target); }
  }), { threshold: .12 });
  $$('.bento .reveal, .features .reveal').forEach((el, i) => el.dataset.d = (i % 4) * 80);
  $$('.reveal').forEach(el => rev.observe(el));

  /* ---------- Counters ---------- */
  const cObs = new IntersectionObserver(es => es.forEach(e => {
    if (!e.isIntersecting) return; cObs.unobserve(e.target);
    const t = +e.target.dataset.count, suf = e.target.dataset.suffix || '+', t0 = performance.now();
    const tick = now => { const k = Math.min(1, (now - t0) / 1600), v = Math.round(t * (1 - Math.pow(1 - k, 4)));
      e.target.textContent = v.toLocaleString('ru-RU') + (k === 1 ? suf : ''); if (k < 1) requestAnimationFrame(tick); };
    requestAnimationFrame(tick);
  }));
  $$('[data-count]').forEach(el => cObs.observe(el));

  /* ---------- Glass light + 3D tilt ---------- */
  const fine = matchMedia('(hover:hover) and (pointer:fine)').matches;
  function bindFx() {
    if (!fine) return;
    $$('.glass:not([data-fx])').forEach(el => {
      el.dataset.fx = 1;
      el.addEventListener('pointermove', e => {
        const r = el.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top;
        el.style.setProperty('--mx', x + 'px'); el.style.setProperty('--my', y + 'px');
        if (el.classList.contains('tilt')) {
          const rx = ((y / r.height) - .5) * -8, ry = ((x / r.width) - .5) * 8;
          el.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-4px)`;
          el.style.transition = 'transform .1s';
        }
      });
      el.addEventListener('pointerleave', () => { if (el.classList.contains('tilt')) { el.style.transition = 'transform .6s cubic-bezier(.22,1,.36,1)'; el.style.transform = ''; } });
    });
  }
  bindFx();

  if (fine) {
    const spot = $('#spot');
    addEventListener('pointermove', e => { spot.style.left = e.clientX + 'px'; spot.style.top = e.clientY + 'px'; }, { passive: true });
    const hv = $('#heroVisual');
    $('.hero').addEventListener('pointermove', e => {
      const r = hv.getBoundingClientRect(), x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5;
      hv.style.transform = `perspective(1000px) rotateY(${x * 10}deg) rotateX(${-y * 8}deg)`;
    });
    $('.hero').addEventListener('pointerleave', () => hv.style.transform = '');
  }

  /* ---------- Parallax blobs on scroll ---------- */
  addEventListener('scroll', () => { $('.aurora').style.transform = `translateY(${scrollY * -.05}px)`; }, { passive: true });

  renderProducts(); renderCart();
})();
