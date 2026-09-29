(() => {
  const init = () => {
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // The curtain is rendered in the HTML immediately after <body> so no page
    // content can flash before the loading screen appears. Reuse it here instead
    // of creating a second curtain after the page has already rendered.
    let curtain = document.querySelector('.cinematic-curtain');
    if (!curtain) {
      curtain = document.createElement('div');
      curtain.className = 'cinematic-curtain';
      curtain.innerHTML = '<div class="curtain-inner"><div class="curtain-brand"><img src="assets/ecosafe-logo.png" alt="EcoSafe Bangladesh"></div><div class="curtain-loading"><span class="curtain-loading-label">Loading</span><span class="curtain-line"><i></i></span></div></div>';
      document.body.prepend(curtain);
    }

    if (!prefersReduced && window.gsap) {
      const tl = gsap.timeline();
      tl.fromTo(curtain.querySelector('.curtain-brand'), { opacity: 0, y: 18, scale: .97 }, { opacity: 1, y: 0, scale: 1, duration: .7, ease: 'power3.out' })
        .to(curtain.querySelector('.curtain-line i'), { scaleX: 1, duration: 1.15, ease: 'power2.inOut' }, '-=.2')
        .to(curtain.querySelector('.curtain-loading-label'), { opacity: .95, duration: .35 }, '-=.8')
        .to(curtain, { opacity: 0, duration: .6, ease: 'power2.out', delay: .15, onComplete: () => curtain.remove() });
    } else {
      const line = curtain.querySelector('.curtain-line i');
      line.style.transform = 'scaleX(1)';
      setTimeout(() => curtain.remove(), 850);
    }

    const toggle = document.querySelector('.nav-toggle');
    const menu = document.querySelector('.mobile-menu');
    if (toggle && menu) toggle.addEventListener('click', () => menu.classList.toggle('open'));

    let lenis = null;
    if (!prefersReduced && window.Lenis) {
      lenis = new Lenis({ duration: 1.05, smoothWheel: true, syncTouch: false, touchMultiplier: 1.02 });
      const raf = (t) => { lenis.raf(t); requestAnimationFrame(raf); };
      requestAnimationFrame(raf);
      window.__ecoLenis = lenis;
    }

    const updateStacks = () => {
      const mobile = window.innerWidth <= 850;
      document.querySelectorAll('[data-stack]').forEach(stack => {
        if (mobile) {
          stack.querySelectorAll('[data-stack-item]').forEach(item => item.classList.add('is-mobile-static'));
          return;
        }
        stack.querySelectorAll('[data-stack-item]').forEach(item => item.classList.remove('is-mobile-static'));
        const rect = stack.getBoundingClientRect();
        const vh = window.innerHeight;
        const progress = Math.max(0, Math.min(1, (vh * .72 - rect.top) / (rect.height + vh * .28)));
        const count = stack.querySelectorAll('[data-stack-item]').length;
        const active = Math.max(0, Math.min(count - 1, progress * (count - 1)));
        // Keep cards clearly separated so the active card reads first.
        stack.style.setProperty('--stack-gap', window.innerWidth < 481 ? '112px' : (window.innerWidth < 851 ? '138px' : '190px'));
        stack.style.setProperty('--active', active.toFixed(3));
        stack.querySelectorAll('[data-stack-item]').forEach((item, i) => {
          const dist = Math.abs(i - active);
          item.style.setProperty('--dist', Math.min(dist, 3).toFixed(3));
          item.classList.toggle('is-active', dist < .45);
        });
      });
    };
    let ticking = false;
    const onScroll = () => {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(() => { updateStacks(); ticking = false; });
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', updateStacks);
    updateStacks();

    // Live impact counters: animate from 0 to the target when they enter the viewport.
    const animateCounters = () => {
      const counters = document.querySelectorAll('[data-count]');
      if (!counters.length) return;
      const runCounter = (el) => {
        if (el.dataset.counted === 'true') return;
        el.dataset.counted = 'true';
        const target = Number(el.dataset.count || 0);
        const suffix = el.dataset.suffix || '';
        const duration = 1700;
        const start = performance.now();
        const tick = (now) => {
          const progress = Math.min((now - start) / duration, 1);
          const eased = 1 - Math.pow(1 - progress, 3);
          el.textContent = Math.floor(target * eased).toLocaleString('en-US') + suffix;
          if (progress < 1) requestAnimationFrame(tick);
        };
        requestAnimationFrame(tick);
      };
      if (!('IntersectionObserver' in window)) {
        counters.forEach(runCounter);
        return;
      }
      const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            runCounter(entry.target);
            obs.unobserve(entry.target);
          }
        });
      }, { threshold: 0.35 });
      counters.forEach(counter => observer.observe(counter));
    };
    animateCounters();

    if (!prefersReduced && window.gsap) {
      gsap.registerPlugin(ScrollTrigger);
      if (lenis) lenis.on('scroll', ScrollTrigger.update);
      gsap.ticker.lagSmoothing(1000, 16);
      document.querySelectorAll('.reveal').forEach(el => {
        gsap.to(el, { opacity: 1, y: 0, duration: 1.35, ease: 'power2.out', scrollTrigger: { trigger: el, start: 'top 90%', once: true } });
      });
      document.querySelectorAll('[data-parallax]').forEach(img => {
        gsap.to(img, { yPercent: -8, ease: 'none', scrollTrigger: { trigger: img.closest('section') || img, start: 'top bottom', end: 'bottom top', scrub: 1.8 } });
      });
      document.querySelectorAll('.direction-row').forEach(row => {
        const media = row.querySelector('.direction-media');
        const copy = row.querySelector('.direction-copy');
        if (media) gsap.fromTo(media, { y: 45, opacity: 0 }, { y: 0, opacity: 1, duration: 1.45, ease: 'power2.out', scrollTrigger: { trigger: row, start: 'top 82%', once: true } });
        if (copy) gsap.fromTo(copy, { y: 35, opacity: 0 }, { y: 0, opacity: 1, duration: 1.3, delay: .12, ease: 'power2.out', scrollTrigger: { trigger: row, start: 'top 78%', once: true } });
      });
      ScrollTrigger.refresh();
    } else {
      document.querySelectorAll('.reveal,.direction-media,.direction-copy').forEach(el => { el.style.opacity = '1'; el.style.transform = 'none'; });
    }
  };
  if (window.__ecoLibs) window.__ecoLibs.then(init); else init();
})();
