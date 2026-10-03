# estk — Vue 3 + Vite

Сайт-портфолио estk.lol: один скролл, чёрные и белые секции, блюр, звук.

```bash
npm install
npm run dev      # разработка
npm run build    # сборка в dist/
npm run preview  # посмотреть сборку
```

## Структура

- `src/App.vue` — сборка страницы, вход, классы на `<body>`
- `src/sections/` — секции: Hero, About, Services, Approach, Portfolio, Contact
- `src/components/` — BgLayers (видео и фоновые сцены), TopBar, SoundPlayer, EnterGate, ScrubText, ArrowIcon
- `src/composables/` — `sound.js` (музыка, звук входа и свайпа), `stage.js` (какая секция сейчас активна), `frame.js` (общий scroll-луп)
- `src/directives/reveal.js` — `v-reveal`, проявление из блюра при появлении в кадре
- `src/data/content.js` — все тексты и ссылки в одном месте
- `src/styles/main.css` — стили; сцены фона переключаются по `body[data-scene]`
- `public/` — видео, постер, зерно, трек (`track.mp3`)

Шрифт Unbounded подключается с Google Fonts (`index.html`).

## Деплой

Статическая сборка: в Vercel корневая папка `estk-vue`, команда `npm run build`, папка вывода `dist`.
