(function () {
  var groups = ['.head', '.feature', '.step', '.device', '.plan', '.faq details', '.cta'];
  var els = [];
  groups.forEach(function (sel) {
    document.querySelectorAll(sel).forEach(function (el, i) {
      el.classList.add('reveal');
      el.style.setProperty('--d', (i % 6) * 70 + 'ms');
      els.push(el);
    });
  });
  if (!('IntersectionObserver' in window)) { els.forEach(function (e) { e.classList.add('in'); }); }
  else {
    var io = new IntersectionObserver(function (list) {
      list.forEach(function (x) { if (x.isIntersecting) { x.target.classList.add('in'); io.unobserve(x.target); } });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    els.forEach(function (e) { io.observe(e); });
  }
  var header = document.querySelector('.header');
  var onScroll = function () { header.classList.toggle('stuck', window.scrollY > 8); };
  onScroll(); window.addEventListener('scroll', onScroll, { passive: true });
})();
