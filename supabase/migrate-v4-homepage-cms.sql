-- EcoSafe Bangladesh CMS v4
-- Adds editable records for the newer homepage sections.

INSERT INTO public.site_content(id,eyebrow,title,lead,body,extra_data) VALUES
('about_feature','Featured project','Waste Management Pilot — DOHS Mohakhali','A three-month pilot introducing residential source segregation across 20 buildings along one road, in partnership with existing waste-management companies.','', '{"stats":[{"value":"20","label":"buildings served"},{"value":"3","label":"month pilot"},{"value":"1","label":"road"}]}'::jsonb),
('about_pilot','Pilot brief','Building a circular waste-management ecosystem at building level.','The pilot will introduce waste segregation at the residential level across 20 buildings along one road in DOHS Mohakhali. It will partner with existing waste-management companies to channel segregated waste into appropriate recycling, recovery and disposal streams.','', '{"points":[{"title":"Source segregation","description":"Separate collection bins at building level."},{"title":"Existing partnerships","description":"Working with established waste-management companies."},{"title":"Appropriate streams","description":"Recycling, recovery and responsible disposal."},{"title":"Circular model","description":"Connecting existing waste-management ecosystems."}]}'::jsonb),
('homepage_impact','Our Impact','Small actions. Measurable progress. Stronger communities.','Our work moves across the systems that shape everyday life — from human and environmental health to waste, worker safety, sustainable energy, research and community resilience.','',
 '{"items":[
  {"count":12500,"suffix":"+","title":"Trees Planted","description":"Trees planted through environmental awareness and community action.","icon":"✦"},
  {"count":320,"suffix":"+","title":"Active Volunteers","description":"People contributing time, ideas and energy to environmental initiatives.","icon":"♧"},
  {"count":20,"suffix":"+","title":"Community Initiatives","description":"Practical activities designed around local environmental and social needs.","icon":"◎"},
  {"count":331,"suffix":"","title":"People Reached","description":"Community members reached through awareness, learning and field activities.","icon":"♡"}
 ]}'::jsonb),
('homepage_pillars','What We Do','Four connected pillars for practical, evidence-based action.','','Safer workplaces. Healthier workers. Stronger communities.',
 '{"items":[
  {"title":"Environment","description":"Climate · Biodiversity · Urban Environment","icon":"○"},
  {"title":"Circular Economy","description":"Waste Management · Electronic Waste · RRR","icon":"○"},
  {"title":"People & OHS","description":"Workplace Safety & Health · Training","icon":"○"},
  {"title":"Knowledge","description":"Research · Consultancy · SDGs","icon":"○"}
 ]}'::jsonb),
('homepage_featured','Featured Project','Community Waste Management Pilot','Introducing source segregation at residential level and connecting existing waste-management systems to more responsible recycling, recovery and disposal streams.','',
 '{"location":"DOHS · Dhaka","stats":[{"value":"20","label":"Buildings"},{"value":"3","label":"Months"},{"value":"Source","label":"Segregation"}],"flow":["The Challenge","Our Intervention","Measure Results"]}'::jsonb),
('homepage_research','Research & Knowledge','Turning evidence into practical solutions.','','',
 '{"items":[
  {"title":"Research Papers","description":"E-waste · OHS · Circular Economy"},
  {"title":"Reports & Policy Briefs","description":"Evidence for decision-makers"},
  {"title":"Training Materials","description":"Practical learning resources"}
 ]}'::jsonb),
('homepage_get_involved','Get Involved','Be part of practical change.','','',
 '{"buttons":[{"label":"Volunteer","url":"contact.html"},{"label":"Partner","url":"contact.html"},{"label":"Research","url":"contact.html"},{"label":"Donate","url":"contact.html"}]}'::jsonb)
ON CONFLICT(id) DO UPDATE SET
 eyebrow=EXCLUDED.eyebrow,
 title=EXCLUDED.title,
 lead=EXCLUDED.lead,
 body=EXCLUDED.body,
 extra_data=EXCLUDED.extra_data,
 updated_at=now();
