<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { onFrame, clamp } from '../composables/frame.js'

const props = defineProps({ text: { type: String, required: true } })
const el = ref(null)
const words = computed(() => props.text.trim().split(/\s+/))

// each word comes out of the blur as the paragraph travels up the screen
function update() {
  const node = el.value
  if (!node) return
  const vh = innerHeight
  const r = node.getBoundingClientRect()
  const p = clamp((vh * 0.82 - r.top) / (vh * 0.5 + r.height * 0.4))
  const ws = node.children
  const n = ws.length
  for (let i = 0; i < n; i++) {
    const k = clamp(p * (n + 3) - i, 0, 3) / 3
    const w = ws[i]
    w.style.opacity = 0.1 + 0.9 * k
    w.style.filter = k >= 1 ? 'none' : `blur(${((1 - k) * 14).toFixed(1)}px)`
    w.style.transform = `translateY(${((1 - k) * 0.15).toFixed(3)}em)`
  }
}

let off = null
onMounted(() => { off = onFrame(update) })
onUnmounted(() => off && off())
</script>

<template>
  <p ref="el" class="scrub big" :aria-label="text">
    <template v-for="(w, i) in words" :key="i"><span class="w" aria-hidden="true">{{ w }}</span>{{ ' ' }}</template>
  </p>
</template>
