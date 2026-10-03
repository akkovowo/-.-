(() => {
  const services = [
    ["Sites", "One strong frame, or a longer story. Picture, type, and pace. A page that does not look like a template."],
    ["Products", "Web apps people actually use. States, speed, and logic without the extra noise."],
    ["Interface", "Type, composition, animation. The interface behaves like a cut: a pause, an accent, a transition."],
    ["Systems", "Backend, automation, deploy. You get a repository and a running environment, not a folder of pictures."],
  ];
  const skills = ["Any API", "Databases", "Vue", "PHP", "Layout", "Landings", "Stores", "Lua", "C#", "Payments", "Python", "Messengers", "Parsers"];
  const approach = [
    ["Frame", "The feeling first. What stays after three seconds, and how the page breathes in motion."],
    ["Precision", "Then the grid, the states, the speed. If you cannot use it, it is not finished."],
    ["Handoff", "Repository, hosting, a short note. The work can continue with me, or without."],
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
    `<li class="rise"><a href="${href}" target="_blank" rel="noopener noreferrer"><span class="n">${num(i)}</span><b>${t}</b><em>${p}</em><span class="go">↗</span></a></li>`).join("");

  // scrubbed words
  $$("[data-scrub]").forEach((el) => {
    el.setAttribute("aria-label", el.textContent);
    el.innerHTML = el.textContent.trim().split(/\s+/).map((w) => `<span class="w" aria-hidden="true">${w}</span>`).join(" ");
  });

  // ---------- sound ----------
  const audio = $("#audio"), player = $("#player"), prog = $("#prog");
  let soundOn = true, fade = 0;
  function volTo(target, ms, done) {
    cancelAnimationFrame(fade);
    const from = audio.volume, t0 = performance.now();
    const step = (t) => {
      const k = clamp((t - t0) / ms), e = k * k * (3 - 2 * k);
      audio.volume = from + (target - from) * e;
      k < 1 ? (fade = requestAnimationFrame(step)) : done && done();
    };
    fade = requestAnimationFrame(step);
  }
  function syncIcon() {
    const playing = soundOn && !audio.paused;
    $("#icoPause").hidden = !playing;
    $("#icoPlay").hidden = playing;
    player.setAttribute("aria-label", playing ? "Mute" : "Play sound");
  }
  function playAudio() {
    audio.volume = 0;
    return audio.play().then(() => { volTo(0.18, 1600); syncIcon(); }).catch(() => { soundOn = false; syncIcon(); });
  }
  player.addEventListener("click", () => {
    if (soundOn && !audio.paused) { soundOn = false; volTo(0, 900, () => audio.pause()); syncIcon(); }
    else { soundOn = true; playAudio(); }
  });
  audio.addEventListener("timeupdate", () => {
    if (audio.duration) prog.style.strokeDashoffset = 100.531 * (1 - audio.currentTime / audio.duration);
  });

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
  let idx = -1;
  function theme() {
    const mid = innerHeight * 0.5;
    let cur = 0;
    sections.forEach((s, i) => { if (s.getBoundingClientRect().top <= mid) cur = i; });
    if (cur === idx) return;
    idx = cur;
    const s = sections[cur];
    body.classList.toggle("light", s.dataset.theme === "light");
    body.classList.toggle("deep", cur > 0);
    if (s.dataset.film != null) setFilm(+s.dataset.film);
    $("#idx").textContent = num(Math.min(cur, 4));
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

  // ---------- reveal ----------
  const io = new IntersectionObserver((es) => es.forEach((e) => {
    if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); }
  }), { threshold: 0.15, rootMargin: "0px 0px -6% 0px" });
  $$(".rise").forEach((el) => io.observe(el));

  // ---------- gate ----------
  const gate = $("#gate");
  function enter() {
    if (entered) return;
    entered = true;
    gate.classList.add("is-gone");
    gate.setAttribute("aria-hidden", "true");
    body.classList.remove("locked");
    body.classList.add("on");
    vids[film].play().catch(() => {});
    playAudio();
    req();
    if (location.hash) $(location.hash)?.scrollIntoView();
  }
  gate.addEventListener("click", enter);
  addEventListener("keydown", (e) => { if (!entered && (e.key === "Enter" || e.key === " ")) { e.preventDefault(); enter(); } });
  document.addEventListener("visibilitychange", () => {
    if (!entered) return;
    if (document.hidden) { vids[film].pause(); audio.pause(); }
    else { vids[film].play().catch(() => {}); soundOn && audio.play().catch(() => {}); }
  });
  if (location.hash.length > 1) enter();
  req();
})();
