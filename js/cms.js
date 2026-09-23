/* EcoSafe Bangladesh public CMS bridge. Static HTML remains the fallback if CMS is empty/unavailable. */
(function () {
  const cfg = window.SUPABASE_CONFIG || {};
  if (!cfg.url || !cfg.anonKey) return;

  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, m => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#039;' }[m]));
  const setText = (el, value) => { if (el && value !== undefined && value !== null) el.textContent = String(value); };
  const setHTML = (el, value) => { if (el && value !== undefined && value !== null) el.innerHTML = String(value); };
  const loadSupabase = () => new Promise((resolve, reject) => {
    if (window.supabase?.createClient) return resolve();
    const s = document.createElement('script');
    s.src = 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2';
    s.onload = resolve;
    s.onerror = reject;
    document.head.appendChild(s);
  });

  function valueFrom(item, path) {
    const parts = path.split('.');
    let v = item;
    for (const part of parts) v = v?.[part];
    return v;
  }

  function hydrateText(content) {
    document.querySelectorAll('[data-cms-text]').forEach(el => {
      const key = el.dataset.cmsText || '';
      const [id, ...pathParts] = key.split('.');
      const item = content[id];
      if (!item) return;
      const path = pathParts.join('.');
      const value = path ? valueFrom(item, path) : item;
      if (value !== undefined && value !== null && value !== '') {
        if (el.dataset.cmsHtml === 'true') setHTML(el, value); else setText(el, value);
      }
    });
  }

  function renderFocus(item) {
    const root = document.querySelector('[data-cms-focus-grid]');
    const items = item?.extra_data?.items;
    if (!root || !Array.isArray(items) || !items.length) return;
    root.innerHTML = items.map((x, i) => `<div class="focus stack-card" data-stack-item style="--i:${i}"><span class="eyebrow">${String(i + 1).padStart(2,'0')}</span><strong>${esc(x.title)}</strong><p>${esc(x.description)}</p></div>`).join('');
  }

  function projectCard(p) {
    const img = p.featured_image || 'assets/ecosafe-logo.png';
    return `<article class="project-card reveal"><img src="${esc(img)}" alt="${esc(p.name)}"><div class="project-info"><span class="eyebrow">${esc(p.location || p.status || 'Program')}</span><h3>${esc(p.name)}</h3><p>${esc(p.description || '')}</p></div></article>`;
  }

  function renderProjects(projects, target, selectedIds) {
    if (!target) return;
    let list = projects.filter(p => p.status !== 'Draft');
    if (Array.isArray(selectedIds) && selectedIds.length) {
      const map = new Map(list.map(p => [String(p.id), p]));
      list = selectedIds.map(id => map.get(String(id))).filter(Boolean);
    }
    if (!list.length) return;
    target.innerHTML = list.map(projectCard).join('');
  }

  function renderLongTerm(item, selector) {
    const root = document.querySelector(selector);
    const items = item?.extra_data?.items;
    if (!root || !Array.isArray(items) || !items.length) return;
    root.innerHTML = items.map((x, i) => `<article class="direction-row reveal"><div class="direction-media ${i % 2 ? 'direction-media-left' : ''}"><img src="${esc(x.image || '')}" alt="${esc(x.title)}"></div><div class="direction-copy ${i % 2 ? 'direction-copy-right' : ''}"><span class="eyebrow">${esc(x.eyebrow || '')}</span><h2>${esc(x.title)}</h2><p>${esc(x.description || '')}</p></div></article>`).join('');
  }

  async function run() {
    try {
      await loadSupabase();
      const db = window.supabase.createClient(cfg.url, cfg.anonKey, { auth: { persistSession:false, autoRefreshToken:false } });
      const [{ data: contentRows, error: contentError }, { data: projects, error: projectError }, { data: services, error: serviceError }, { data: settings }] = await Promise.all([
        db.from('site_content').select('*'),
        db.from('projects').select('*').neq('status','Draft').order('display_order'),
        db.from('services').select('*').order('display_order'),
        db.from('company_settings').select('*').eq('id','default').maybeSingle()
      ]);
      if (contentError && projectError && serviceError) return;
      const content = Object.fromEntries((contentRows || []).map(x => [x.id, x]));
      hydrateText(content);
      renderFocus(content.homepage_focus);
      renderProjects(projects || [], document.querySelector('[data-cms-projects]'), null);
      renderProjects(projects || [], document.querySelector('[data-cms-home-projects]'), content.homepage_programs?.extra_data?.selectedProjectIds);
      renderProjects(projects || [], document.querySelector('[data-cms-about-projects]'), content.about_other_programs?.extra_data?.selectedProjectIds);
      renderLongTerm(content.projects_longterm, '[data-cms-longterm]');
      renderLongTerm(content.about_longterm, '[data-cms-about-longterm]');

      const serviceRoot = document.querySelector('[data-cms-services]');
      if (serviceRoot && Array.isArray(services) && services.length) {
        serviceRoot.innerHTML = services.map((s,i) => `<div class="service stack-card" data-stack-item style="--i:${i}"><span class="eyebrow">${String(i+1).padStart(2,'0')}</span><h3>${esc(s.title)}</h3><p>${esc(s.description)}</p></div>`).join('');
      }
      const outcomeRoot = document.querySelector('[data-cms-outcomes]');
      const outcomes = content.about_outcomes?.extra_data?.items;
      if (outcomeRoot && Array.isArray(outcomes) && outcomes.length) outcomeRoot.innerHTML = outcomes.map((x,i) => `<div class="outcome reveal"><span>${String(i+1).padStart(2,'0')}</span><h3>${esc(x)}</h3></div>`).join('');

      if (settings) {
        const reg = document.querySelector('[data-cms-text="contact_org.extraData.registration"]');
        const address = settings.address || '';
        setText(document.querySelector('[data-cms-contact-address]'), address);
        setText(document.querySelector('[data-cms-contact-phone]'), settings.phone || '');
        setText(document.querySelector('[data-cms-contact-email]'), settings.email || '');
        if (reg && settings.address) reg.innerHTML = `Registered under: RJSC<br>${esc(address)}`;
      }
    } catch (e) {
      console.warn('EcoSafe CMS unavailable; using static page content.', e);
    }
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run); else run();
})();
