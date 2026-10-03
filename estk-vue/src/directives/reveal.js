import { onFrame } from '../composables/frame.js'

// v-reveal: adds `.in` once the element scrolls into view (the `.rise` class holds the out-of-focus resting state)
const pending = new Set()

function show(el) {
  el.classList.add('in')
  pending.delete(el)
  io.unobserve(el)
}

const io = new IntersectionObserver(
  (entries) => entries.forEach((e) => e.isIntersecting && show(e.target)),
  { threshold: 0.15, rootMargin: '0px 0px -6% 0px' },
)

// a very fast scroll can jump over an element without the observer ever seeing it;
// anything that is already above the viewport gets revealed anyway
let watching = false
function sweep() {
  pending.forEach((el) => { if (el.getBoundingClientRect().bottom < 0) show(el) })
}

export default {
  mounted(el) {
    pending.add(el)
    io.observe(el)
    if (!watching) { watching = true; onFrame(sweep) }
  },
  unmounted(el) {
    pending.delete(el)
    io.unobserve(el)
  },
}
