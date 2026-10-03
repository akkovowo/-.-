<script setup>
import { contact } from '../data/content.js'
import ArrowIcon from '../components/ArrowIcon.vue'
</script>

<template>
  <section id="contact" class="sec contact" data-name="Контакты" data-theme="dark" data-film="0">
    <p v-reveal class="kicker rise">Контакты</p>
    <h2 class="huge"><span v-reveal class="rise">Пишите в Telegram. Отвечаю лично.</span></h2>
    <a v-reveal class="mail rise" :href="contact.href" target="_blank" rel="noopener noreferrer">{{ contact.handle }}<span><ArrowIcon /></span></a>
    <p v-reveal class="domain rise">{{ contact.domain }}</p>
  </section>
</template>
