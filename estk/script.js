(() => {
  const films = [
    { title: "Sites", lines: ["Identity", "Campaigns"], src: 0,
      text: "One strong frame, or a longer story. Picture, type, and pace. A page that does not look like a template." },
    { title: "Products", lines: ["Dashboards", "Tools"], src: 1,
      text: "Web apps people actually use. States, speed, and logic without the extra noise." },
    { title: "Interface", lines: ["Grid", "Motion"], src: 2,
      text: "Type, composition, animation. The interface behaves like a cut: a pause, an accent, a transition." },
    { title: "Systems", lines: ["API", "Handoff"], src: 0,
      text: "Backend, automation, deploy. You get a repository and a running environment, not a folder of pictures." },
  ];
  const skills = [
    ["Any API", "REST, webhooks, third-party services. Auth, limits, and a clean handoff."],
    ["Databases", "Schema, queries, migrations. Postgres or MySQL, and the admin around them."],
    ["Vue", "SPAs and interfaces. Fast screens, clear state, code you can keep."],
    ["PHP", "Sites, REST APIs, admin panels, and the database behind them."],
    ["Layout", "HTML and CSS, responsive pages. Type, grid, and a page that does not look like a template."],
    ["Landings", "One page, one offer. Type, pace, and a clear next step."],
    ["Stores", "A shop with a catalog, a cart, and payment. Fast, and not a stock theme."],
    ["Lua", "Scripts and small tools. One job, done cleanly."],
    ["C#", "Services, desktop tools, and integrations."],
    ["Payments", "Checkout, webhooks, and subscriptions wired into the product."],
    ["Python", "Bots, scripts, and jobs on a schedule."],
    ["Messengers", "Telegram and the rest. Bots, notifications, and a direct line into the product."],
    ["Parsers", "Structured data from pages and feeds, on a schedule, into your database."],
  ];
  const works = [
    ["pre77", "https://pre77.to", "Marketplace. Secure messenger and storefront in one."],
    ["pre77 bot", "https://t.me/pre77ccbot", "Telegram messenger for the marketplace."],
    ["Amnesia", "https://amnesia.plus", "Product site. Landing, accounts, and delivery."],
    ["Amnesia bot", "https://t.me/amnesiaplus_robot", "Telegram bot for the same product."],
    ["Void", "https://vo1d.cc", "Forum styling."],
    ["Hell Hours", "https://hellhours.ru", "Service site for Steam hours."],
    ["Hell Points", "https://hellpoints.ru", "Shop for Steam awards."],
    ["Bless", "https://t.me/blesschatmanager_bot", "Telegram chat manager."],
  ];
  const approach = [
    ["Frame", "The feeling first. What stays after three seconds, and how the page breathes in motion."],
    ["Precision", "Then the grid, the states, the speed. If you cannot use it, it is not finished."],
    ["Handoff", "Repository, hosting, a short note. The work can continue with me, or without."],
  ];
  const contact = { href: "https://t.me/riskybenefit", handle: "t.me/riskybenefit", domain: "estk.lol" };

  const $ = (s, r = document) => r.querySelector(s);
  const stage = $("#stage"), reel = $("#reel"), gate = $("#gate");
  const vids = [...document.querySelectorAll(".film")];
  const audio = $("#audio"), player = $("#player"), prog = $("#prog");
  const panel = $("#panel"), panelBody = $("#panelBody"), panelTitle = $("#panelTitle");
  const num = (i) => String(i + 1).padStart(2, "0");
  const esc = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;");

  // ---------- reel ----------
  reel.innerHTML = films.map((f, i) =>
    `<button class="card" data-i="${i}"><span class="card__title">${f.title}<i>${num(i)}</i></span>` +
    f.lines.map((l) => `<span class="card__meta">${l}</span>`).join("") + `</button>`).join("");
  const cards = [...reel.children];

  let active = -1, entered = false, soundOn = true, rafId = 0;
  const vidOf = (i) => vids[films[i].src];

  function show(i) {
    if (i === active) return;
    const prev = active >= 0 ? vidOf(active) : null;
    active = i;
    const v = vidOf(i);
    v.preload = "auto";
    v.currentTime = 0;
    if (v !== prev) {
      vids.forEach((x) => { if (x !== v) { x.classList.remove("is-front"); setTimeout(() => { if (!x.classList.contains("is-front")) x.pause(); }, 1200); } });
      v.classList.add("is-front");
    }
    if (entered) v.play().catch(() => {});
    cards.forEach((c, k) => { c.classList.toggle("is-active", k === i); c.style.setProperty("--t", 0); });
    const c = cards[i];
    if (c && reel.scrollWidth > reel.clientWidth) reel.scrollTo({ left: c.offsetLeft, behavior: "smooth" });
  }

  function tick() {
    const v = active >= 0 ? vidOf(active) : null;
    if (v && v.duration) cards[active].style.setProperty("--t", v.currentTime / v.duration);
    rafId = requestAnimationFrame(tick);
  }
  const next = () => show((active + 1) % films.length);

  cards.forEach((c, i) => {
    c.addEventListener("click", () => show(i));
    c.addEventListener("pointerenter", () => stage.classList.add("is-peek"));
    c.addEventListener("pointerleave", () => stage.classList.remove("is-peek"));
  });
  vids.forEach((v) => v.addEventListener("ended", next));
  vids.forEach((v) => { v.loop = false; });

  // ---------- sound ----------
  let fade = 0;
  function volTo(target, ms, done) {
    cancelAnimationFrame(fade);
    const from = audio.volume, t0 = performance.now();
    const step = (t) => {
      const k = Math.min(1, (t - t0) / ms), e = k * k * (3 - 2 * k);
      audio.volume = from + (target - from) * e;
      k < 1 ? (fade = requestAnimationFrame(step)) : done && done();
    };
    fade = requestAnimationFrame(step);
  }
  function playAudio() {
    audio.volume = 0;
    return audio.play().then(() => { volTo(0.18, 1600); sync(); }).catch(() => { soundOn = false; sync(); });
  }
  function pauseAudio() { soundOn = false; volTo(0, 900, () => audio.pause()); sync(); }
  function sync() {
    const playing = soundOn && !audio.paused;
    $("#icoPause").hidden = !playing;
    $("#icoPlay").hidden = playing;
    player.setAttribute("aria-label", playing ? "Mute" : "Play sound");
  }
  player.addEventListener("click", () => { if (soundOn && !audio.paused) pauseAudio(); else { soundOn = true; playAudio(); } });
  audio.addEventListener("timeupdate", () => {
    if (audio.duration) prog.style.strokeDashoffset = 100.531 * (1 - audio.currentTime / audio.duration);
  });

  // ---------- gate ----------
  function enter() {
    if (entered) return;
    entered = true;
    gate.classList.add("is-gone");
    stage.classList.add("is-on");
    show(0);
    vidOf(0).play().catch(() => {});
    playAudio();
    cancelAnimationFrame(rafId);
    rafId = requestAnimationFrame(tick);
    gate.setAttribute("aria-hidden", "true");
  }
  gate.addEventListener("click", enter);
  window.addEventListener("keydown", (e) => { if (!entered && (e.key === "Enter" || e.key === " ")) { e.preventDefault(); enter(); } });
  show(0);

  // ---------- panels ----------
  const rise = (i) => `class="rise" style="--i:${i}"`;
  const rows = (arr, fn) => `<div class="rows">${arr.map(fn).join("")}</div>`;
  const views = {
    services: () => ({
      title: "Services",
      html: `<div class="split"><div ${rise(0)}><h2>Sites and products.<br>From the frame to a working system.</h2></div>` +
        rows([...films.map((f) => [f.title, f.text]), ...skills], ([t, p], i) =>
          `<article class="row rise" style="--i:${i + 1}"><span class="num">${num(i)}</span><div><h3>${t}</h3><p>${esc(p)}</p></div></article>`) + `</div>`,
    }),
    approach: () => ({
      title: "Approach",
      html: `<div class="split"><div ${rise(0)}><h2>Frame first.</h2><p class="lead">estk is esoterik. I design and build. One person, from the first screen through delivery.</p></div>` +
        rows(approach, ([t, p], i) =>
          `<article class="row rise" style="--i:${i + 1}"><span class="num">${num(i)}</span><div><h3>${t}</h3><p>${esc(p)}</p></div></article>`) + `</div>`,
    }),
    portfolio: () => ({
      title: "Portfolio",
      html: `<div class="split"><div ${rise(0)}><h2>Work that's live.</h2></div>` +
        rows(works, ([t, href, p], i) =>
          `<article class="row rise" style="--i:${i + 1}"><span class="num">${num(i)}</span><div><h3><a href="${href}" target="_blank" rel="noopener noreferrer">${t}</a></h3><p>${esc(p)}</p></div></article>`) + `</div>`,
    }),
    contact: () => ({
      title: "Contact",
      html: `<div class="contact"><div ${rise(0)}><h2>Telegram. I answer myself.</h2></div>` +
        `<a class="mail rise" style="--i:1" href="${contact.href}" target="_blank" rel="noopener noreferrer">${contact.handle}` +
        `<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 7h10v10h-2V10.4L7.4 18 6 16.6l7.6-7.6H7Z"/></svg></a>` +
        `<p class="domain rise" style="--i:2">${contact.domain}</p></div>`,
    }),
  };

  let current = null, lastFocus = null;
  function open(name) {
    const v = views[name]; if (!v) return;
    const { title, html } = v();
    lastFocus = document.activeElement;
    panelTitle.textContent = title;
    panelBody.innerHTML = html;
    panel.scrollTop = 0;
    panel.setAttribute("aria-hidden", "false");
    stage.classList.add("is-panel");
    stage.classList.remove("is-peek");
    requestAnimationFrame(() => requestAnimationFrame(() => panel.classList.add("is-open")));
    current = name;
    history.replaceState(null, "", "#" + name);
    $("#close").focus({ preventScroll: true });
  }
  function close() {
    if (!current) return;
    current = null;
    panel.classList.remove("is-open");
    panel.setAttribute("aria-hidden", "true");
    stage.classList.remove("is-panel");
    history.replaceState(null, "", location.pathname + location.search);
    if (lastFocus) lastFocus.focus({ preventScroll: true });
  }
  document.querySelectorAll("[data-open]").forEach((b) => b.addEventListener("click", () => open(b.dataset.open)));
  $("#close").addEventListener("click", close);
  window.addEventListener("keydown", (e) => { if (e.key === "Escape") close(); });
  document.addEventListener("visibilitychange", () => {
    if (!entered) return;
    const v = vidOf(active);
    document.hidden ? (v.pause(), audio.pause()) : (v.play().catch(() => {}), soundOn && audio.play().catch(() => {}));
  });

  const hash = location.hash.slice(1);
  if (views[hash]) { enter(); open(hash); }
})();
