<script setup>
import { computed } from 'vue'
import { live, stateText, progress, toggleMusic } from '../composables/sound.js'

const RING = 141.37
const offset = computed(() => RING * (1 - progress.value))
</script>

<template>
  <button
    class="player"
    :class="{ 'is-live': live }"
    type="button"
    :aria-label="live ? 'Выключить звук' : 'Включить звук'"
    :aria-pressed="live"
    @click="toggleMusic"
  >
    <span class="disc">
      <svg class="ring" viewBox="0 0 48 48" aria-hidden="true">
        <circle class="ring__track" cx="24" cy="24" r="22.5" />
        <circle class="ring__prog" cx="24" cy="24" r="22.5" :style="{ strokeDashoffset: offset }" />
      </svg>
      <span class="eq" aria-hidden="true"><i /><i /><i /><i /><i /></span>
    </span>
    <span class="pl"><b>Звук</b><em>{{ stateText }}</em></span>
  </button>
</template>
