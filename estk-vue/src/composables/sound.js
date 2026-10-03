import { ref } from 'vue'
import { clamp } from './frame.js'

// ---------- music ----------
const audio = new Audio('/track.mp3')
audio.loop = true
audio.preload = 'none'

export const live = ref(false) // music is playing right now
export const stateText = ref('Включён')
export const progress = ref(0) // 0..1 position in the track

let soundOn = true // false once the user mutes (effects stay silent too)
let fade = 0
let failTimer = 0

function volTo(target, ms, done) {
  cancelAnimationFrame(fade)
  const from = audio.volume
  const t0 = performance.now()
  const step = (t) => {
    const k = clamp((t - t0) / ms)
    const e = k * k * (3 - 2 * k)
    try { audio.volume = from + (target - from) * e } catch (_) {}
    k < 1 ? (fade = requestAnimationFrame(step)) : done && done()
  }
  fade = requestAnimationFrame(step)
}

function sync() {
  live.value = !audio.paused
  if (!failTimer) stateText.value = live.value ? 'Включён' : 'Выключен'
}
;['play', 'pause', 'ended'].forEach((e) => audio.addEventListener(e, sync))
audio.addEventListener('timeupdate', () => {
  if (audio.duration) progress.value = audio.currentTime / audio.duration
})

export function playMusic() {
  try { audio.volume = 0 } catch (_) {}
  const p = audio.play()
  return (p && p.then ? p : Promise.resolve())
    .then(() => { volTo(0.22, 1400); sync() })
    .catch(() => {
      soundOn = false
      sync()
      stateText.value = 'Не удалось, ещё раз'
      clearTimeout(failTimer)
      failTimer = setTimeout(() => { failTimer = 0; sync() }, 2600)
    })
}

export function toggleMusic() {
  if (!audio.paused) {
    soundOn = false
    volTo(0, 500, () => { audio.pause(); sync() })
    stateText.value = 'Выключен'
  } else {
    soundOn = true
    audio.preload = 'auto'
    playMusic()
  }
}

// tab hidden → pause everything, visible again → resume if the user did not mute
export function suspendMusic() { audio.pause() }
export function resumeMusic() { if (soundOn) audio.play().catch(() => {}) }

// ---------- effects (synthesised, no files) ----------
let actx = null
let lastSwipe = 0

function getCtx() {
  if (actx) return actx
  try {
    const AC = window.AudioContext || window.webkitAudioContext
    if (AC) actx = new AC()
  } catch (_) {}
  return actx
}

function whenReady(ctx, fn) {
  ctx.state === 'suspended' ? ctx.resume().then(fn, fn) : fn()
}

// very quiet glass chime + a breath of air under the circle that opens the site
function chime(ctx, out, t0) {
  const master = ctx.createGain()
  master.gain.value = 0.9
  const delay = ctx.createDelay(0.5)
  const fb = ctx.createGain()
  const lp = ctx.createBiquadFilter()
  delay.delayTime.value = 0.21
  fb.gain.value = 0.34
  lp.type = 'lowpass'
  lp.frequency.value = 2800
  master.connect(out); master.connect(delay); delay.connect(lp); lp.connect(fb); fb.connect(delay); lp.connect(out)
  ;[[880, 0, 0.032], [1318.51, 0.11, 0.026], [1975.53, 0.23, 0.02]].forEach(([f, dt, peak]) => {
    ;[[1, 1], [2.01, 0.28], [3.97, 0.08]].forEach(([mul, amp]) => {
      const o = ctx.createOscillator()
      const g = ctx.createGain()
      const t = t0 + dt
      o.type = 'sine'
      o.frequency.value = f * mul
      g.gain.setValueAtTime(0.0001, t)
      g.gain.exponentialRampToValueAtTime(peak * amp, t + 0.018)
      g.gain.exponentialRampToValueAtTime(0.0001, t + 1.5 / mul + 0.5)
      o.connect(g); g.connect(master); o.start(t); o.stop(t + 2.2)
    })
  })
  const len = Math.floor(ctx.sampleRate * 2.2)
  const buf = ctx.createBuffer(1, len, ctx.sampleRate)
  const d = buf.getChannelData(0)
  for (let i = 0; i < len; i++) d[i] = Math.random() * 2 - 1
  const n = ctx.createBufferSource()
  const bp = ctx.createBiquadFilter()
  const ng = ctx.createGain()
  n.buffer = buf
  bp.type = 'bandpass'
  bp.Q.value = 0.9
  bp.frequency.setValueAtTime(500, t0)
  bp.frequency.exponentialRampToValueAtTime(3600, t0 + 1.7)
  ng.gain.setValueAtTime(0.0001, t0)
  ng.gain.exponentialRampToValueAtTime(0.02, t0 + 0.9)
  ng.gain.exponentialRampToValueAtTime(0.0001, t0 + 2.1)
  n.connect(bp); bp.connect(ng); ng.connect(master); n.start(t0); n.stop(t0 + 2.2)
}

// soft swipe for a section change: sweeps up when going down, down when going up
function swipe(ctx, out, t0, down) {
  const dur = 0.5
  const len = Math.floor(ctx.sampleRate * dur)
  const buf = ctx.createBuffer(1, len, ctx.sampleRate)
  const d = buf.getChannelData(0)
  for (let i = 0; i < len; i++) d[i] = Math.random() * 2 - 1
  const n = ctx.createBufferSource()
  const bp = ctx.createBiquadFilter()
  const lp = ctx.createBiquadFilter()
  const g = ctx.createGain()
  n.buffer = buf
  bp.type = 'bandpass'
  bp.Q.value = 1.1
  lp.type = 'lowpass'
  lp.frequency.value = 4200
  const [f0, f1] = down ? [650, 2400] : [2400, 650]
  bp.frequency.setValueAtTime(f0, t0)
  bp.frequency.exponentialRampToValueAtTime(f1, t0 + dur * 0.9)
  g.gain.setValueAtTime(0.0001, t0)
  g.gain.exponentialRampToValueAtTime(0.06, t0 + dur * 0.38)
  g.gain.exponentialRampToValueAtTime(0.0001, t0 + dur)
  n.connect(bp); bp.connect(lp); lp.connect(g); g.connect(out)
  n.start(t0); n.stop(t0 + dur + 0.05)
}

export function enterSound() {
  const ctx = getCtx()
  if (!ctx) return
  whenReady(ctx, () => { try { chime(ctx, ctx.destination, ctx.currentTime + 0.05) } catch (_) {} })
}

export function sectionSound(down) {
  const ctx = actx
  const now = performance.now()
  if (!ctx || !soundOn || now - lastSwipe < 350) return
  lastSwipe = now
  whenReady(ctx, () => { try { swipe(ctx, ctx.destination, ctx.currentTime + 0.02, down) } catch (_) {} })
}
