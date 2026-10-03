(() => {
  const services = [
    ["Сайты", "Один сильный кадр или длинная история. Картинка, шрифт, темп. Страница, которая не похожа на шаблон."],
    ["Продукты", "Веб-приложения, которыми реально пользуются. Состояния, скорость и логика без лишнего шума."],
    ["Интерфейсы", "Шрифт, композиция, анимация. Интерфейс ведёт себя как монтаж: пауза, акцент, переход."],
    ["Бэкенд", "Серверная часть, автоматизация, деплой. Вы получаете репозиторий и работающий проект, а не папку с картинками."],
  ];
  const skills = ["Любые API", "Базы данных", "Vue", "PHP", "Вёрстка", "Лендинги", "Интернет-магазины", "Lua", "C#", "Приём платежей", "Python", "Боты и мессенджеры", "Парсеры"];
  const approach = [
    ["Образ", "Сначала ощущение: что остаётся через три секунды и как страница дышит в движении."],
    ["Точность", "Потом сетка, состояния и скорость. Если сайтом нельзя пользоваться, работа не закончена."],
    ["Сдача", "Репозиторий, хостинг и короткая инструкция. Дальше проект живёт со мной или без меня."],
  ];
  const works = [
    ["pre77", "https://pre77.to", "Маркетплейс. Защищённый мессенджер и витрина в одном месте."],
    ["pre77 bot", "https://t.me/pre77ccbot", "Telegram-мессенджер для маркетплейса."],
    ["Amnesia", "https://amnesia.plus", "Сайт продукта: лендинг, личные кабинеты и выдача."],
    ["Amnesia bot", "https://t.me/amnesiaplus_robot", "Telegram-бот для того же продукта."],
    ["Void", "https://vo1d.cc", "Оформление для форума."],
    ["Hell Hours", "https://hellhours.ru", "Сервис для набора часов в Steam."],
    ["Hell Points", "https://hellpoints.ru", "Магазин наград для Steam."],
    ["Bless", "https://t.me/blesschatmanager_bot", "Telegram-бот для управления чатами."],
  ];

  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];
  const num = (i) => String(i + 1).padStart(2, "0");
  const clamp = (v, a = 0, b = 1) => Math.min(b, Math.max(a, v));
  const body = document.body;

  // ---------- content ----------
  $("#serviceList").innerHTML = services.map(([t, p], i) =>
    `<article class="item rise" style="--d:${i * 0.05}s"><h3><sup>${num(i)}</sup>${t}</h3><p>${p}</p></article>`).join("");
  $("#skills").innerHTML = skills.map((s, i) => `<span class="chip rise" style="--d:${(i % 6) * 0.06}s"><span>${s}</span></span>`).join("");
  $("#steps").innerHTML = approach.map(([t, p], i) =>
    `<article class="step"><div class="in"><span class="n rise">${num(i)} / ${num(approach.length - 1)}</span><h3 class="rise">${t}</h3><p class="rise" style="--d:.15s">${p}</p></div></article>`).join("");
  $("#works").innerHTML = works.map(([t, href, p], i) =>
    `<li class="rise"><a href="${href}" target="_blank" rel="noopener noreferrer"><span class="n">${num(i)}</span><b>${t}</b><em>${p}</em><span class="go"><svg class="arr" viewBox="0 0 64 64" aria-hidden="true"><use href="#arr"/></svg></span></a></li>`).join("");

  // scrubbed words
  $$("[data-scrub]").forEach((el) => {
    el.setAttribute("aria-label", el.textContent);
    el.innerHTML = el.textContent.trim().split(/\s+/).map((w) => `<span class="w" aria-hidden="true">${w}</span>`).join(" ");
  });

  // ---------- sound ----------
  const audio = $("#audio"), player = $("#player"), prog = $("#prog"), plState = $("#plState");
  const RING = 141.37;
  let soundOn = true, fade = 0, failTimer = 0;
  function volTo(target, ms, done) {
    cancelAnimationFrame(fade);
    const from = audio.volume, t0 = performance.now();
    const step = (t) => {
      const k = clamp((t - t0) / ms), e = k * k * (3 - 2 * k);
      try { audio.volume = from + (target - from) * e; } catch (_) {}
      k < 1 ? (fade = requestAnimationFrame(step)) : done && done();
    };
    fade = requestAnimationFrame(step);
  }
  function syncIcon() {
    const live = !audio.paused;
    player.classList.toggle("is-live", live);
    player.setAttribute("aria-pressed", String(live));
    player.setAttribute("aria-label", live ? "Выключить звук" : "Включить звук");
    if (!failTimer) plState.textContent = live ? "Включён" : "Выключен";
  }
  function playAudio() {
    try { audio.volume = 0; } catch (_) {}
    const p = audio.play();
    return (p && p.then ? p : Promise.resolve()).then(() => { volTo(0.22, 1400); syncIcon(); }).catch(() => {
      soundOn = false; syncIcon();
      plState.textContent = "Не удалось, ещё раз";
      clearTimeout(failTimer);
      failTimer = setTimeout(() => { failTimer = 0; syncIcon(); }, 2600);
    });
  }
  function toggleSound() {
    if (!audio.paused) { soundOn = false; volTo(0, 500, () => { audio.pause(); syncIcon(); }); plState.textContent = "Выключен"; }
    else { soundOn = true; audio.preload = "auto"; playAudio(); }
  }
  player.addEventListener("click", toggleSound);
  ["play", "pause", "ended"].forEach((e) => audio.addEventListener(e, syncIcon));
  audio.addEventListener("timeupdate", () => {
    if (audio.duration) prog.style.strokeDashoffset = RING * (1 - audio.currentTime / audio.duration);
  });
  syncIcon();

  // ---------- film / theme ----------
  const vids = $$(".film");
  let film = -1, entered = false;
  function setFilm(i) {
    if (i === film) return;
    film = i;
    const v = vids[i];
    v.preload = "auto";
    vids.forEach((x) => {
      if (x === v) { x.classList.add("is-front"); if (entered) x.play().catch(() => {}); }
      else { x.classList.remove("is-front"); setTimeout(() => { if (!x.classList.contains("is-front")) x.pause(); }, 1300); }
    });
  }
  setFilm(0);

  const sections = $$(".sec");
  let idx = -1, lastThemeY = 0;
  function theme() {
    const mid = innerHeight * 0.5;
    let cur = 0;
    sections.forEach((s, i) => { if (s.getBoundingClientRect().top <= mid) cur = i; });
    if (cur === idx) return;
    idx = cur;
    const s = sections[cur];
    body.style.setProperty("--py", scrollY >= lastThemeY ? "100%" : "0%");
    body.style.setProperty("--px", "50%");
    body.classList.toggle("light", s.dataset.theme === "light");
    body.classList.toggle("deep", cur > 0);
    if (s.dataset.film != null) setFilm(+s.dataset.film);
    $("#idx").textContent = num(cur);
    $("#idxName").textContent = s.dataset.name || "";
    lastThemeY = scrollY;
    body.dataset.scene = s.id;
  }

  // ---------- scroll-driven ----------
  const scrubs = $$("[data-scrub]");
  const steps = $$(".step");
  const bar = $("#bar");
  let ticking = false;
  function frame() {
    ticking = false;
    const vh = innerHeight;
    const max = document.documentElement.scrollHeight - vh;
    bar.style.transform = `scaleX(${max > 0 ? clamp(scrollY / max) : 0})`;
    theme();

    scrubs.forEach((el) => {
      const r = el.getBoundingClientRect();
      const p = clamp((vh * 0.82 - r.top) / (vh * 0.5 + r.height * 0.4)); // 0..1 as it travels up
      const ws = el.children, n = ws.length;
      for (let i = 0; i < n; i++) {
        const k = clamp(p * (n + 3) - i, 0, 3) / 3; // each word eases in over a few word-steps
        const w = ws[i];
        w.style.opacity = 0.1 + 0.9 * k;
        w.style.filter = k >= 1 ? "none" : `blur(${((1 - k) * 14).toFixed(1)}px)`;
        w.style.transform = `translateY(${((1 - k) * 0.15).toFixed(3)}em)`;
      }
    });

    // pinned approach words dissolve as the next one slides in
    steps.forEach((s, i) => {
      const next = steps[i + 1];
      const inner = s.firstElementChild;
      if (!next) { inner.style.opacity = ""; inner.style.filter = ""; return; }
      const p = clamp(1 - next.getBoundingClientRect().top / vh);
      inner.style.opacity = (1 - p).toFixed(3);
      inner.style.filter = p > 0 ? `blur(${(p * 40).toFixed(1)}px)` : "";
    });
  }
  const req = () => { if (!ticking) { ticking = true; requestAnimationFrame(frame); } };
  addEventListener("scroll", req, { passive: true });
  addEventListener("resize", req);

  // ---------- living background: everything here reacts to scroll position and speed ----------
  const reduce = matchMedia("(prefers-reduced-motion: reduce)").matches;
  const hoverDevice = matchMedia("(hover: hover) and (pointer: fine)").matches;
  const spot = $("#spot"), filmsEl = $(".films");
  let lastY = scrollY, vel = 0, sp = 0, mx = innerWidth / 2, my = innerHeight / 2, sx = mx, sy = my, fxOn = false;
  addEventListener("pointermove", (e) => { mx = e.clientX; my = e.clientY; }, { passive: true });
  function fxLoop() {
    if (!fxOn) return;
    const max = Math.max(1, document.documentElement.scrollHeight - innerHeight);
    const y = scrollY, dy = y - lastY;
    lastY = y;
    vel += (Math.min(Math.abs(dy), 90) - vel) * 0.12;
        sp += (clamp(y / max) - sp) * 0.07;
    if (!hoverDevice) { mx = innerWidth * (0.5 + 0.38 * Math.sin(sp * 11)); my = innerHeight * (0.5 + 0.32 * Math.cos(sp * 8)); }
    sx += (mx - sx) * 0.06; sy += (my - sy) * 0.06;
    spot.style.transform = `translate3d(${sx.toFixed(1)}px,${sy.toFixed(1)}px,0)`;
    filmsEl.style.transform = `translate3d(0,${(-sp * 5).toFixed(2)}%,0) scale(${(1 + sp * 0.1 + vel * 0.0025).toFixed(4)})`;
    requestAnimationFrame(fxLoop);
  }
  function fxStart() { if (reduce || fxOn) return; fxOn = true; lastY = scrollY; requestAnimationFrame(fxLoop); }

  // ---------- reveal ----------
  const io = new IntersectionObserver((es) => es.forEach((e) => {
    if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); }
  }), { threshold: 0.15, rootMargin: "0px 0px -6% 0px" });
  $$(".rise").forEach((el) => io.observe(el));

  // ---------- gate ----------
  // circle of light opens from the centre of the gate; plain fade where clip-path path() is unsupported
  function openGate() {
    const ok = !reduce && window.CSS && CSS.supports && CSS.supports("clip-path", 'path("M0 0L1 1Z")');
    if (!ok) { gate.classList.add("no-clip"); return; }
    const w = innerWidth, h = innerHeight, cx = w / 2, cy = h / 2, max = Math.hypot(cx, cy) + 12;
    const t0 = performance.now() + 250, dur = 2100;
    const ease = (k) => (k < 0.5 ? 4 * k * k * k : 1 - Math.pow(-2 * k + 2, 3) / 2);
    const step = (t) => {
      const k = clamp((t - t0) / dur);
      if (k > 0) {
        const r = max * ease(k);
        gate.style.clipPath = `path(evenodd,"M0 0H${w}V${h}H0Z M${cx - r} ${cy}a${r} ${r} 0 1 0 ${2 * r} 0a${r} ${r} 0 1 0 ${-2 * r} 0Z")`;
      }
      if (k < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  }
  const gate = $("#gate");
  function enter() {
    if (entered) return;
    entered = true;
    openGate();
    gate.classList.add("is-gone");
    gate.setAttribute("aria-hidden", "true");
    body.classList.remove("locked");
    body.classList.add("on");
    vids[film].play().catch(() => {});
    playAudio();
    req();
    fxStart();
    if (location.hash) $(location.hash)?.scrollIntoView();
  }
  gate.addEventListener("click", enter);
  addEventListener("keydown", (e) => { if (!entered && (e.key === "Enter" || e.key === " ")) { e.preventDefault(); enter(); } });
  document.addEventListener("visibilitychange", () => {
    if (!entered) return;
    if (document.hidden) { fxOn = false; vids[film].pause(); audio.pause(); }
    else { fxStart(); vids[film].play().catch(() => {}); soundOn && audio.play().catch(() => {}); }
  });
  if (location.hash.length > 1) enter();
  req();
})();
