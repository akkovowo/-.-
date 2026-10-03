<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { approach, num } from '../data/content.js'
import { onFrame, clamp } from '../composables/frame.js'

const stepEls = ref([])

// the pinned word dissolves into blur as the next one slides in
function update() {
  const vh = innerHeight
  const els = stepEls.value
  els.forEach((s, i) => {
    const inner = s.firstElementChild
    const next = els[i + 1]
    if (!next) { inner.style.opacity = ''; inner.style.filter = ''; return }
    const p = clamp(1 - next.getBoundingClientRect().top / vh)
    inner.style.opacity = (1 - p).toFixed(3)
    inner.style.filter = p > 0 ? `blur(${(p * 40).toFixed(1)}px)` : ''
  })
}

let off = null
onMounted(() => { off = onFrame(update) })
onUnmounted(() => off && off())
</script>

<template>
  <section id="approach" class="sec approach" data-name="Как я работаю" data-theme="dark" data-film="2">
    <p v-reveal class="kicker rise">Как я работаю</p>
    <div class="steps">
      <article v-for="(s, i) in approach" :key="s.title" ref="stepEls" class="step">
        <div class="step__in">
          <span v-reveal class="n rise">{{ num(i) }} / {{ num(approach.length - 1) }}</span>
          <h3 v-reveal class="rise">{{ s.title }}</h3>
          <p v-reveal class="rise" style="--d: 0.15s">{{ s.text }}</p>
        </div>
      </article>
    </div>
  </section>
</template>
