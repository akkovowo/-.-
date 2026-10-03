import { onMounted, onUnmounted } from 'vue'
import { store } from '../store.js'
import { onFrame, clamp } from './frame.js'
import { sectionSound } from './sound.js'

// decides which section is "current" and switches the whole stage (theme, film, scene, name)
export function useStage() {
  let sections = []
  let idx = -1
  let lastThemeY = 0
  let off = null

  function theme() {
    const mid = innerHeight * 0.5
    let cur = 0
    sections.forEach((s, i) => { if (s.getBoundingClientRect().top <= mid) cur = i })
    if (cur === idx) return
    const prev = idx
    idx = cur
    const s = sections[cur]
    // the white sheet opens from the side you are scrolling towards
    document.body.style.setProperty('--py', scrollY >= lastThemeY ? '100%' : '0%')
    document.body.style.setProperty('--px', '50%')
    store.light = s.dataset.theme === 'light'
    store.idx = cur
    store.scene = s.id
    store.name = s.dataset.name || ''
    if (s.dataset.film != null) store.film = +s.dataset.film
    lastThemeY = scrollY
    if (prev >= 0 && store.entered) sectionSound(cur > prev)
  }

  function frame() {
    const max = document.documentElement.scrollHeight - innerHeight
    store.progress = max > 0 ? clamp(scrollY / max) : 0
    theme()
  }

  onMounted(() => {
    sections = [...document.querySelectorAll('.sec')]
    off = onFrame(frame)
  })
  onUnmounted(() => off && off())
}
