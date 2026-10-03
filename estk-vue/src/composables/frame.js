// one scroll/resize listener for the whole app; subscribers run once per animation frame
const subs = new Set()
let ticking = false
let bound = false

function run() {
  ticking = false
  subs.forEach((cb) => cb())
}

export function requestFrame() {
  if (!ticking) {
    ticking = true
    requestAnimationFrame(run)
  }
}

export function onFrame(cb) {
  if (!bound) {
    bound = true
    addEventListener('scroll', requestFrame, { passive: true })
    addEventListener('resize', requestFrame)
  }
  subs.add(cb)
  requestFrame()
  return () => subs.delete(cb)
}

export const clamp = (v, a = 0, b = 1) => Math.min(b, Math.max(a, v))
