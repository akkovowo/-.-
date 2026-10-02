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
  ];
  const byId = id => PRODUCTS.find(p => p.id === id);
  const link = p => 'https://jjstore.ru/' + p.url;

  /* Products */
  const track = $('#track');
  track.innerHTML = PRODUCTS.map(p => `
    <article class="card glass">
      <a class="img" href="${link(p)}" target="_blank" rel="noopener"><img src="${IMG + p.img}" alt="${p.name}" loading="lazy"></a>
      <h4>${p.name}</h4>
      <div class="price">${fmt(p.price)}</div>
      <button class="buy" data-id="${p.id}">В корзину</button>
    </article>`).join('');
  const step = () => track.clientWidth + 20;
  $('#prev').onclick = () => track.scrollBy({ left: -step(), behavior: 'smooth' });
  $('#next').onclick = () => track.scrollBy({ left: step(), behavior: 'smooth' });

  /* Cart */
  let cart = [];
  try { cart = JSON.parse(localStorage.getItem('jj-cart') || '[]'); } catch (e) {}
  const save = () => { try { localStorage.setItem('jj-cart', JSON.stringify(cart)); } catch (e) {} };
  function renderCart() {
    const box = $('#cartItems');
    box.innerHTML = cart.length ? '' : '<div class="empty">В корзине пусто</div>';
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
  const toggle = on => { drawer.classList.toggle('on', on); scrim.classList.toggle('on', on); };
  $('#openCart').onclick = () => toggle(true);
  $('#closeCart').onclick = $('#scrim').onclick = () => toggle(false);
  document.addEventListener('keydown', e => { if (e.key === 'Escape') toggle(false); });
  $('#cartItems').addEventListener('click', e => {
    const b = e.target.closest('button'); if (!b) return;
    cart.splice(+b.dataset.i, 1); save(); renderCart();
  });
  track.addEventListener('click', e => {
    const b = e.target.closest('.buy'); if (!b) return;
    cart.push(+b.dataset.id); save(); renderCart();
    b.classList.add('done'); b.textContent = 'Добавлено';
    setTimeout(() => { b.classList.remove('done'); b.textContent = 'В корзину'; }, 1200);
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

  /* opening hours: Voronezh time (MSK), 11:00–20:00 */
  (function () {
    const el = $('#hoursState'), box = $('#hours'); if (!el) return;
    const parts = new Intl.DateTimeFormat('ru-RU', { timeZone: 'Europe/Moscow', hour: 'numeric', minute: 'numeric', hour12: false }).formatToParts(new Date());
    const mins = +parts.find(p => p.type === 'hour').value * 60 + +parts.find(p => p.type === 'minute').value;
    const open = mins >= 11 * 60 && mins < 20 * 60;
    box.classList.toggle('open', open);
    el.textContent = open ? `Открыто · закрываемся в 20:00` : (mins < 11 * 60 ? 'Закрыто · откроемся в 11:00' : 'Закрыто · откроемся завтра в 11:00');
  })();

  renderCart();
})();
