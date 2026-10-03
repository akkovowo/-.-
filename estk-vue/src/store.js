import { reactive } from 'vue'

// shared UI state: what the page is doing right now
export const store = reactive({
  entered: false, // the gate was opened
  idx: 0, // index of the current section
  scene: 'hero', // id of the current section (drives the background scene)
  name: 'Главная',
  light: false, // current section is white
  film: 0, // which background film is in front
  progress: 0, // 0..1 scroll progress
})
