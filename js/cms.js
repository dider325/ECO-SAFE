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
    return path.split('.').reduce((v, part) => v?.[part], item);
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
    const meta = [p.location, p.year].filter(Boolean).join(' · ') || p.status || 'Program';
    return `<article class="client-project-card reveal">
      <div class="client-project-image"><img src="${esc(img)}" alt="${esc(p.name)}" loading="lazy"></div>
      <div class="client-project-body">
        <span>${esc(meta)}</span>
        <h3>${esc(p.name)}</h3>
        <p>${esc(p.description || '')}</p>
        <a href="contact.html">Read more <b>→</b></a>
      </div>
    </article>`;
  }

  function renderProjects(projects, target) {
    if (!target) return;
    const list = (projects || [])
      .filter(p => p && p.status !== 'Draft')
      .sort((a,b) => (Number(a.display_order ?? 0) - Number(b.display_order ?? 0)) || String(a.name||'').localeCompare(String(b.name||'')));
    if (!list.length) {
      target.innerHTML = '<div class="empty">No projects published yet.</div>';
      return;
    }
    target.innerHTML = list.map(projectCard).join('');
    target.querySelectorAll('.reveal').forEach(el => el.classList.add('is-visible'));
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
      const fetchProjectsDirect = async () => {
        const params = new URLSearchParams({
          select: 'id,name,slug,location,year,status,description,featured_image,images,display_order,created_at,updated_at',
          status: 'neq.Draft',
          order: 'display_order.asc,created_at.asc'
        });
        const response = await fetch(`${cfg.url}/rest/v1/projects?${params.toString()}`, {
          headers: { apikey: cfg.anonKey, Authorization: `Bearer ${cfg.anonKey}` },
          cache: 'no-store'
        });
        if (!response.ok) throw new Error(`Projects request failed (${response.status})`);
        return await response.json();
      };

      const [contentResult, projectRows, serviceResult, settingsResult] = await Promise.all([
        db.from('site_content').select('*'),
        fetchProjectsDirect(),
        db.from('services').select('*').order('display_order', { ascending:true }),
        db.from('company_settings').select('*').eq('id','default').maybeSingle()
      ]);

      if (contentResult.error) console.warn('EcoSafe CMS site_content error:', contentResult.error);
      if (serviceResult.error) console.warn('EcoSafe CMS services error:', serviceResult.error);

      const content = Object.fromEntries((contentResult.data || []).map(x => [x.id, x]));
      hydrateText(content);
      renderFocus(content.homepage_focus);
      renderProjects(Array.isArray(projectRows) ? projectRows : [], document.querySelector('[data-cms-projects]'));
      renderProjects(Array.isArray(projectRows) ? projectRows : [], document.querySelector('[data-cms-home-projects]'));
      renderLongTerm(content.about_longterm, '[data-cms-about-longterm]');

      const serviceRoot = document.querySelector('[data-cms-services]');
      if (serviceRoot && Array.isArray(serviceResult.data) && serviceResult.data.length) {
        serviceRoot.innerHTML = serviceResult.data.map((s,i) => `<div class="service stack-card" data-stack-item style="--i:${i}"><span class="eyebrow">${String(i+1).padStart(2,'0')}</span><h3>${esc(s.title)}</h3><p>${esc(s.description)}</p></div>`).join('');
      }

      const outcomeRoot = document.querySelector('[data-cms-outcomes]');
      const outcomes = content.about_outcomes?.extra_data?.items;
      if (outcomeRoot && Array.isArray(outcomes) && outcomes.length) outcomeRoot.innerHTML = outcomes.map((x,i) => `<div class="outcome reveal"><span>${String(i+1).padStart(2,'0')}</span><h3>${esc(x)}</h3></div>`).join('');

      const settings = settingsResult.data;
      if (settings) {
        const reg = document.querySelector('[data-cms-text="contact_org.extraData.registration"]');
        setText(document.querySelector('[data-cms-contact-address]'), settings.address || '');
        setText(document.querySelector('[data-cms-contact-phone]'), settings.phone || '');
        setText(document.querySelector('[data-cms-contact-email]'), settings.email || '');
        if (reg && settings.address) reg.innerHTML = `Registered under: RJSC<br>${esc(settings.address)}`;
      }
    } catch (e) {
      console.error('EcoSafe CMS unavailable:', e);
    }
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run); else run();
})();
