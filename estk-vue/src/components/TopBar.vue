<script setup>
import { store } from '../store.js'
import { num } from '../data/content.js'
import ArrowIcon from './ArrowIcon.vue'
</script>

<template>
  <header class="top">
    <a href="#hero" class="top__logo" aria-label="estk">
      <svg viewBox="0 0 64 64" aria-hidden="true"><path d="M40 8.5 29.2 30.2h8.4L26.4 56" /></svg>estk
    </a>
    <span class="top__idx"><b>{{ num(store.idx) }}</b> <span>{{ store.name }}</span></span>
    <a class="top__tg" href="https://t.me/riskybenefit" target="_blank" rel="noopener noreferrer">Написать <ArrowIcon /></a>
  </header>
</template>
