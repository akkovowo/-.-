<script setup>
import { services, skills, num } from '../data/content.js'
</script>

<template>
  <section id="services" class="sec services" data-name="Услуги" data-theme="light">
    <p v-reveal class="kicker rise">Услуги</p>
    <h2 class="huge">
      <span v-reveal class="rise">Сайты и продукты.</span>
      <span v-reveal class="rise">От первого кадра до работающей системы.</span>
    </h2>
    <div class="list">
      <article v-for="(s, i) in services" :key="s.title" v-reveal class="item rise" :style="{ '--d': i * 0.05 + 's' }">
        <h3><sup>{{ num(i) }}</sup>{{ s.title }}</h3>
        <p>{{ s.text }}</p>
      </article>
    </div>
    <div class="cloud">
      <span v-for="(s, i) in skills" :key="s" v-reveal class="chip rise" :style="{ '--d': (i % 6) * 0.06 + 's' }"><span>{{ s }}</span></span>
    </div>
  </section>
</template>
