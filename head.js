(() => {
  const load = src => new Promise((resolve,reject)=>{const s=document.createElement('script');s.src=src;s.onload=resolve;s.onerror=reject;document.head.appendChild(s);});
  window.__ecoLibs = load('https://unpkg.com/lenis@1.1.20/dist/lenis.min.js')
    .then(()=>load('https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/gsap.min.js'))
    .then(()=>load('https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/ScrollTrigger.min.js'))
    .catch(()=>{});
})();
