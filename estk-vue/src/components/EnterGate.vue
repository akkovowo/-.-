<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { clamp } from '../composables/frame.js'

const emit = defineEmits(['enter'])
const el = ref(null)
const gone = ref(false)
const noClip = ref(false)

// a circle of light opens from the centre; plain fade where clip-path path() is unsupported
function open() {
  gone.value = true
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches
  const ok = !reduce && window.CSS && CSS.supports && CSS.supports('clip-path', 'path("M0 0L1 1Z")')
  if (!ok) { noClip.value = true; return }
  const w = innerWidth
  const h = innerHeight
  const cx = w / 2
  const cy = h / 2
  const max = Math.hypot(cx, cy) + 12
  const t0 = performance.now() + 250
  const dur = 2100
  const ease = (k) => (k < 0.5 ? 4 * k * k * k : 1 - Math.pow(-2 * k + 2, 3) / 2)
  const step = (t) => {
    const k = clamp((t - t0) / dur)
    if (k > 0 && el.value) {
      const r = max * ease(k)
      el.value.style.clipPath = `path(evenodd,"M0 0H${w}V${h}H0Z M${cx - r} ${cy}a${r} ${r} 0 1 0 ${2 * r} 0a${r} ${r} 0 1 0 ${-2 * r} 0Z")`
    }
    if (k < 1) requestAnimationFrame(step)
  }
  requestAnimationFrame(step)
}
defineExpose({ open })

const onKey = (e) => {
  if (!gone.value && (e.key === 'Enter' || e.key === ' ')) { e.preventDefault(); emit('enter') }
}
onMounted(() => addEventListener('keydown', onKey))
onUnmounted(() => removeEventListener('keydown', onKey))
</script>

<template>
  <button
    ref="el"
    class="gate"
    :class="{ 'is-gone': gone, 'no-clip': noClip }"
    type="button"
    aria-label="Войти"
    :aria-hidden="gone"
    @click="emit('enter')"
  >
    <svg class="gate__mark" viewBox="0 0 64 64" aria-hidden="true"><path d="M40 8.5 29.2 30.2h8.4L26.4 56" /></svg>
    <span class="gate__hint">Войти</span>
  </button>
</template>
