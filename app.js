(() => {
  const init = () => {
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // Cinematic entrance — deliberately short, visual, and non-blocking.
    if (!prefersReduced && !sessionStorage.getItem('ecoCinematicSeen')) {
      const curtain = document.createElement('div');
      curtain.className = 'cinematic-curtain';
      curtain.innerHTML = '<div class="curtain-inner"><div class="curtain-brand"><span>ECOSAFE</span></div><div class="curtain-line"></div></div>';
      document.body.appendChild(curtain);
      sessionStorage.setItem('ecoCinematicSeen', '1');
      if (window.gsap) {
        const tl = gsap.timeline();
        tl.to(curtain.querySelector('.curtain-brand span'), { y: '0%', duration: .85, ease: 'power4.out' })
          .to(curtain.querySelector('.curtain-line'), { scaleX: 1, duration: .65, ease: 'power3.out' }, '-=.45')
          .to(curtain, { clipPath: 'inset(0 0 100% 0)', duration: 1.05, ease: 'power4.inOut', delay: .22, onComplete: () => curtain.remove() });
      } else {
        setTimeout(() => curtain.remove(), 1500);
      }
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
      document.querySelectorAll('[data-stack]').forEach(stack => {
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
