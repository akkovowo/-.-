<template>
  <section id="hero" class="sec hero" data-name="Главная" data-theme="dark" data-film="0">
    <svg class="mark" viewBox="0 0 64 64" aria-hidden="true"><path d="M40 8.5 29.2 30.2h8.4L26.4 56" /></svg>
    <h1 class="mega" aria-label="estk">
      <span v-for="(c, i) in 'estk'" :key="i" class="ch" :style="{ '--i': i }" aria-hidden="true">{{ c }}</span>
    </h1>
    <p v-reveal class="hero__sub rise" style="--d: 0.25s">Сайты, сервисы и системы. Делаю один, от идеи до запуска.</p>
    <div v-reveal class="scroll rise" style="--d: 0.5s"><span>Листайте</span><i></i></div>
  </section>
</template>
