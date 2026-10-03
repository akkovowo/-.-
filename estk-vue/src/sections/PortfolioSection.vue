<script setup>
import { works, num } from '../data/content.js'
import ArrowIcon from '../components/ArrowIcon.vue'
</script>

<template>
  <section id="portfolio" class="sec portfolio" data-name="Портфолио" data-theme="light">
    <p v-reveal class="kicker rise">Портфолио</p>
    <h2 class="huge"><span v-reveal class="rise">Проекты, которые уже работают.</span></h2>
    <ul class="works">
      <li v-for="(w, i) in works" :key="w.title" v-reveal class="rise">
        <a :href="w.href" target="_blank" rel="noopener noreferrer">
          <span class="n">{{ num(i) }}</span>
          <b>{{ w.title }}</b>
          <em>{{ w.text }}</em>
          <span class="go"><ArrowIcon /></span>
        </a>
      </li>
    </ul>
  </section>
</template>
