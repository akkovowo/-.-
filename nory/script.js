(() => {
  const REPO = "wasteprince/nory";
  const RELEASES = `https://github.com/${REPO}/releases/latest`;
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];

  const bar = $("#progress"), par = $$("[data-parallax]");
  let tick = false;
  const onScroll = () => {
    if (tick) return; tick = true;
    requestAnimationFrame(() => {
      const h = document.documentElement.scrollHeight - innerHeight;
      bar.style.transform = `scaleX(${h > 0 ? scrollY / h : 0})`;
      par.forEach(el => { el.style.transform = `translateY(${scrollY * -(+el.dataset.parallax)}px)`; });
      tick = false;
    });
  };
  addEventListener("scroll", onScroll, { passive: true }); onScroll();

  const io = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); }
  }), { threshold: .15 });
  $$(".reveal").forEach(el => io.observe(el));

  const steps = $$(".step"), panels = $$(".panel"), dots = $$(".dots i"), glow = $(".stage-glow");
  const shot = $("#shot"), OFF = [0, -170, 0, -185];
  const setStep = i => {
    shot.style.transform = `translateY(${OFF[i]}px)`;
    $(".shot").classList.toggle("hide", i === 2);
    steps.forEach((s, k) => s.classList.toggle("act", k === i));
    panels.forEach(p => p.classList.toggle("on", +p.dataset.i === i));
    dots.forEach((d, k) => d.classList.toggle("on", k === i));
    glow.style.transform = `translate(${(i - 1.5) * 24}px,${(i - 1.5) * 18}px) scale(${1 + i * .06})`;
  };
  const so = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) setStep(+e.target.dataset.i);
  }), { rootMargin: matchMedia("(max-width:900px)").matches ? "-60% 0px -30% 0px" : "-45% 0px -45% 0px" });
  steps.forEach(s => so.observe(s)); setStep(0);

  const win = $("#win-main"), power = $("#power"), st = $("#state-text"), tm = $("#timer"),
        dn = $("#dn"), up = $("#up"), srvName = $("#state-srv");
  let secs = 44 * 60 + 8, down = 186, upl = 14, on = true;
  const fmt = s => `${Math.floor(s / 3600)}:${String(Math.floor(s / 60) % 60).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
  const render = () => {
    win.classList.toggle("off", !on); power.classList.toggle("on", on);
    st.textContent = on ? "Подключено" : "Отключено";
    tm.textContent = fmt(secs); dn.textContent = Math.round(down); up.textContent = Math.round(upl);
  };
  setInterval(() => { if (!on) return; secs++; down += Math.random() * .6; upl += Math.random() * .08; render(); }, 1000);
  power.addEventListener("click", () => {
    on = !on; if (on) { secs = 0; down = 0; upl = 0; } render();
  });
  $$("#srvs li").forEach(li => li.addEventListener("click", () => {
    $$("#srvs li").forEach(x => x.classList.remove("on")); li.classList.add("on");
    srvName.textContent = li.dataset.n; if (!on) { on = true; } secs = 0; down = 0; upl = 0; render();
  }));
  render();

  const dd = $("#dd"), ddBtn = $("#dd-btn"), ddVal = $("#dd-val"), ddList = $("#dd-list");
  const DATA = {
    "Приложения": [["Telegram", "Приложение"], ["Steam", "Приложение"], ["Сбербанк Онлайн", "Приложение"]],
    "Процессы": [["telegram", "Процесс · PID 4120"], ["steamwebhelper", "Процесс · PID 5873"], ["Safari", "Процесс · PID 912"]]
  };
  ddBtn.addEventListener("click", e => { e.stopPropagation(); dd.classList.toggle("open"); });
  document.addEventListener("click", () => dd.classList.remove("open"));
  $$(".opt").forEach(o => o.addEventListener("click", () => {
    $$(".opt").forEach(x => { x.classList.remove("on"); x.firstElementChild.textContent = ""; });
    o.classList.add("on"); o.firstElementChild.textContent = "✓";
    ddVal.textContent = o.dataset.v;
    ddList.innerHTML = DATA[o.dataset.v].map(([a, b], i) => `<div class="item" style="animation-delay:${i * .07}s"><b>${a}</b><small>${b}</small></div>`).join("");
  }));
  new IntersectionObserver((es, ob) => es.forEach(e => {
    if (e.isIntersecting) { setTimeout(() => dd.classList.add("open"), 700); setTimeout(() => dd.classList.remove("open"), 3200); ob.disconnect(); }
  }), { threshold: .6 }).observe($(".win.add"));

  const NAMES = { mac: "macOS", win: "Windows", linux: "Linux" };
  const ua = navigator.userAgent, plat = (navigator.userAgentData && navigator.userAgentData.platform) || navigator.platform || "";
  const detectOS = () => {
    if (/android|iphone|ipad|ipod/i.test(ua)) return null;
    if (/mac/i.test(plat) || /Macintosh|Mac OS X/i.test(ua)) return "mac";
    if (/win/i.test(plat) || /Windows/i.test(ua)) return "win";
    if (/linux|x11|cros/i.test(plat + ua)) return "linux";
    return null;
  };
  const os = detectOS();
  let arch = /arm|aarch64/i.test(ua) ? "arm" : null;
  const archReady = (navigator.userAgentData && navigator.userAgentData.getHighEntropyValues)
    ? navigator.userAgentData.getHighEntropyValues(["architecture"]).then(v => { arch = /arm/i.test(v.architecture) ? "arm" : "x64"; }).catch(() => {})
    : Promise.resolve();
  if (os === "mac" && !arch) {
    try {
      const gl = document.createElement("canvas").getContext("webgl");
      const r = gl && gl.getParameter(gl.getExtension("WEBGL_debug_renderer_info")?.UNMASKED_RENDERER_WEBGL || gl.RENDERER);
      if (/apple m|apple gpu/i.test(r || "")) arch = "arm";
    } catch (e) {}
  }

  const RX = {
    mac: /\.(dmg|pkg)$|mac|darwin|osx/i,
    win: /\.(exe|msi)$|windows|win(32|64)/i,
    linux: /\.(appimage|deb|rpm|tar\.gz|tgz)$|linux/i
  };
  const EXT_PREF = { mac: ["pkg", "dmg", "zip", "gz"], win: ["exe", "msi", "zip"], linux: ["appimage", "deb", "rpm", "gz", "tgz", "zip"] };
  const junk = /\.(sig|sha256|sha512|blockmap|yml|yaml|txt|json|asc|minisig|sbom)$|checksums?/i;
  const archOf = n => /arm64|aarch64|apple-?silicon/i.test(n) ? "arm" : /x64|x86_64|amd64|intel|x86/i.test(n) ? "x64" : null;
  const pick = (assets, o, wantArch) => {
    const c = assets.filter(a => !junk.test(a.name) && RX[o].test(a.name) && !(o === "linux" && /\.(dmg|exe|msi)$/i.test(a.name)));
    const score = a => {
      const ext = a.name.split(".").pop().toLowerCase(), i = EXT_PREF[o].indexOf(ext);
      let s = i < 0 ? 0 : 20 - i;
      const ar = archOf(a.name);
      if (wantArch && ar === wantArch) s += 30; else if (wantArch && ar && ar !== wantArch) s -= 30;
      return s;
    };
    return c.sort((a, b) => score(b) - score(a))[0] || null;
  };

  const labels = $$("[data-dl-label]"), osName = $("#os-name"), meta = $("#dl-meta"), heroVer = $("#hero-ver");
  const mainDl = $("#main-dl"), heroDl = $("#hero-dl");
  const setLabel = t => labels.forEach(l => l.textContent = t);
  const labelFor = o => o ? `Скачать для ${NAMES[o]}` : "Скачать";
  setLabel(labelFor(os));
  osName.textContent = os ? NAMES[os] : "выберите платформу ниже";
  if (os) $(`.os[data-os="${os}"]`)?.classList.add("cur");
  heroDl.href = "#download";

  const human = b => b > 1048576 ? (b / 1048576).toFixed(1) + " МБ" : Math.round(b / 1024) + " КБ";

  const findIn = (releases, o, wantArch) => {
    for (const rel of releases) {
      if (rel.draft || rel.prerelease) continue;
      const f = pick(rel.assets || [], o, wantArch);
      if (f) return { rel, f };
    }
    return null;
  };
  Promise.all([
    fetch(`https://api.github.com/repos/${REPO}/releases?per_page=15`, { headers: { Accept: "application/vnd.github+json" } }).then(r => { if (!r.ok) throw 0; return r.json(); }),
    archReady
  ]).then(([rels]) => {
    const newest = rels.find(r => !r.draft && !r.prerelease) || rels[0];
    heroVer.textContent = `Версия ${newest.tag_name}`;
    $$(".os").forEach(a => {
      const o = a.dataset.os, small = $("small", a);
      const hit = findIn(rels, o, o === os ? arch : null);
      if (hit) { a.href = hit.f.browser_download_url; small.textContent = `${hit.rel.tag_name} · ${human(hit.f.size)}`; a.title = hit.f.name; }
      else small.textContent = o === "linux" ? "бета · инструкция" : "на GitHub";
    });
    const mine = os && findIn(rels, os, arch);
    if (mine) {
      for (const el of [mainDl, heroDl]) { el.href = mine.f.browser_download_url; el.setAttribute("download", mine.f.name); }
      meta.textContent = `${mine.rel.tag_name} · ${mine.f.name} · ${human(mine.f.size)}`;
    } else {
      mainDl.href = os === "linux" ? "https://github.com/wasteprince/nory/blob/main/INSTALL.md" : RELEASES;
      meta.textContent = os === "linux" ? "Для Linux пока бета-версия — смотрите инструкцию" : "Откроется страница релизов на GitHub";
    }
  }).catch(() => {
    $$(".os small").forEach(s => s.textContent = "на GitHub");
    mainDl.href = RELEASES; heroDl.href = RELEASES;
    meta.textContent = "Откроется страница последнего релиза на GitHub";
    heroVer.textContent = "Последняя версия на GitHub";
  });
})();
