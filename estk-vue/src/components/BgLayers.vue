<script setup>
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { store } from '../store.js'
import { clamp } from '../composables/frame.js'

const films = ['/main.webm', '/second.webm', '/third.webm']
const filmsEl = ref(null)
const spot = ref(null)
const vids = ref([])

const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches
const hoverDevice = matchMedia('(hover: hover) and (pointer: fine)').matches

// ---------- films: only the front one plays ----------
let pauseTimers = []
function syncFilms() {
  pauseTimers.forEach(clearTimeout)
  pauseTimers = []
  vids.value.forEach((v, i) => {
    if (i === store.film) {
      v.preload = 'auto'
      if (store.entered) v.play().catch(() => {})
    } else {
      pauseTimers.push(setTimeout(() => { if (store.film !== i) v.pause() }, 1300))
    }
  })
}
watch(() => [store.film, store.entered], syncFilms)

function onVisibility() {
  if (!store.entered) return
  const v = vids.value[store.film]
  if (!v) return
  document.hidden ? v.pause() : v.play().catch(() => {})
}

// ---------- living background: reacts to scroll position and speed ----------
let lastY = 0
let vel = 0
let sp = 0
let mx = innerWidth / 2
let my = innerHeight / 2
let sx = mx
let sy = my
let fxOn = false

const onPointer = (e) => { mx = e.clientX; my = e.clientY }

function fxLoop() {
  if (!fxOn) return
  const max = Math.max(1, document.documentElement.scrollHeight - innerHeight)
  const y = scrollY
  const dy = y - lastY
  lastY = y
  vel += (Math.min(Math.abs(dy), 90) - vel) * 0.12
  sp += (clamp(y / max) - sp) * 0.07
  if (!hoverDevice) {
    mx = innerWidth * (0.5 + 0.38 * Math.sin(sp * 11))
    my = innerHeight * (0.5 + 0.32 * Math.cos(sp * 8))
  }
  sx += (mx - sx) * 0.06
  sy += (my - sy) * 0.06
  if (spot.value) spot.value.style.transform = `translate3d(${sx.toFixed(1)}px,${sy.toFixed(1)}px,0)`
  if (filmsEl.value) filmsEl.value.style.transform = `translate3d(0,${(-sp * 5).toFixed(2)}%,0) scale(${(1 + sp * 0.1 + vel * 0.0025).toFixed(4)})`
  requestAnimationFrame(fxLoop)
}
function fxStart() {
  if (reduce || fxOn) return
  fxOn = true
  lastY = scrollY
  requestAnimationFrame(fxLoop)
}
watch(() => store.entered, (v) => v && fxStart())

function onVisibilityFx() {
  if (document.hidden) fxOn = false
  else if (store.entered) fxStart()
}

onMounted(() => {
  syncFilms()
  addEventListener('pointermove', onPointer, { passive: true })
  document.addEventListener('visibilitychange', onVisibility)
  document.addEventListener('visibilitychange', onVisibilityFx)
})
onUnmounted(() => {
  fxOn = false
  removeEventListener('pointermove', onPointer)
  document.removeEventListener('visibilitychange', onVisibility)
  document.removeEventListener('visibilitychange', onVisibilityFx)
})
</script>

<template>
  <div class="paper" aria-hidden="true"></div>

  <div ref="filmsEl" class="films" aria-hidden="true">
    <video
      v-for="(src, i) in films"
      :key="src"
      ref="vids"
      class="film"
      :class="{ 'is-front': store.film === i }"
      :src="src"
      :poster="i === 0 ? '/poster.jpg' : undefined"
      :preload="i === 0 ? 'auto' : 'none'"
      muted
      playsinline
      loop
    ></video>
  </div>

  <div class="veil" aria-hidden="true"></div>

  <div class="fx" aria-hidden="true">
    <div ref="spot" class="spot"></div>
    <div class="boltwrap">
      <svg class="bolt" viewBox="0 0 64 64">
        <path class="b1" d="M40 8.5 29.2 30.2h8.4L26.4 56" />
        <path class="b2" pathLength="100" d="M40 8.5 29.2 30.2h8.4L26.4 56" />
      </svg>
    </div>
    <div class="rings"><i></i><i></i><i></i><i></i></div>
    <div class="dots"></div>
    <div class="grid"></div>
    <div class="frames"><i></i><i></i><i></i><i></i><i></i><i></i></div>
    <svg class="bolt2" viewBox="0 0 64 64"><path pathLength="100" d="M40 8.5 29.2 30.2h8.4L26.4 56" /></svg>
  </div>

  <div class="flash" aria-hidden="true"></div>
  <div class="grain" aria-hidden="true"></div>
</template>
