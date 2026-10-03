<script setup>
import { nextTick, onMounted, onUnmounted, ref, watchEffect } from 'vue'
import { store } from './store.js'
import { useStage } from './composables/stage.js'
import { requestFrame } from './composables/frame.js'
import { enterSound, playMusic, suspendMusic, resumeMusic } from './composables/sound.js'
import BgLayers from './components/BgLayers.vue'
import TopBar from './components/TopBar.vue'
import SoundPlayer from './components/SoundPlayer.vue'
import EnterGate from './components/EnterGate.vue'
import HeroSection from './sections/HeroSection.vue'
import AboutSection from './sections/AboutSection.vue'
import ServicesSection from './sections/ServicesSection.vue'
import ApproachSection from './sections/ApproachSection.vue'
import PortfolioSection from './sections/PortfolioSection.vue'
import ContactSection from './sections/ContactSection.vue'

useStage()

const gate = ref(null)

// every section-driven look is a class on <body> so the stylesheet can switch the whole scene at once
watchEffect(() => {
  const b = document.body
  b.classList.toggle('locked', !store.entered)
  b.classList.toggle('on', store.entered)
  b.classList.toggle('light', store.light)
  b.classList.toggle('deep', store.idx > 0)
  b.dataset.scene = store.scene
})

function enter() {
  if (store.entered) return
  store.entered = true
  enterSound()
  gate.value && gate.value.open()
  playMusic()
  requestFrame()
  if (location.hash.length > 1) nextTick(() => document.querySelector(location.hash)?.scrollIntoView())
}

function onVisibility() {
  if (!store.entered) return
  document.hidden ? suspendMusic() : resumeMusic()
}

onMounted(() => {
  document.addEventListener('visibilitychange', onVisibility)
  if (location.hash.length > 1) enter()
})
onUnmounted(() => document.removeEventListener('visibilitychange', onVisibility))
</script>

<template>
  <BgLayers />
  <div class="bar" aria-hidden="true"><i :style="{ transform: `scaleX(${store.progress})` }"></i></div>
  <TopBar />
  <SoundPlayer />

  <main>
    <HeroSection />
    <AboutSection />
    <ServicesSection />
    <ApproachSection />
    <PortfolioSection />
    <ContactSection />
  </main>

  <EnterGate ref="gate" @enter="enter" />
</template>
