-- EcoSafe Bangladesh CMS v3 migration
-- Safe to run on the existing EcoSafe Supabase project after the base schema/RLS/storage are already installed.
-- This migration only upserts EcoSafe content and removes the accidental Moire placeholder social row.

DELETE FROM public.social_links
WHERE url LIKE '%facebook.com/p/Moir%C3%A9-Studio-61562499697661%';

INSERT INTO public.company_settings(id,company_name,tagline,address,phone,email,contact_intro)
VALUES ('default','EcoSafe Bangladesh','Greener. Healthier. More Inclusive.','Banani DOHS, Dhaka, Bangladesh','','','For partnerships, research, consultancy and community initiatives.')
ON CONFLICT(id) DO UPDATE SET
 company_name=EXCLUDED.company_name,
 tagline=EXCLUDED.tagline,
 address=EXCLUDED.address,
 contact_intro=EXCLUDED.contact_intro;

-- Services shown on the live Services page.
INSERT INTO public.services(title,description,display_order) VALUES
('Environmental Protection','Awareness, action and research that support environmental protection and more responsible relationships with natural systems.',1),
('Urban Environmental Management','Exploring environmental challenges in growing urban communities and supporting practical approaches to healthier cities.',2),
('Occupational Health & Safety','Focusing on safer working conditions and awareness for people working in hazardous sectors.',3),
('Social & Environmental Consultancy','Research-informed consultancy across social, environmental and related development needs.',4),
('Clean Water & Sanitation','Promoting hygiene, health and access to clean water as foundations of resilient communities.',5),
('Waste Management','Supporting responsible collection, recycling, reuse and future-oriented waste management systems.',6),
('Sustainable Clean Energy','Promoting sustainable energy and solar-electric initiatives as part of a cleaner future.',7),
('Community Empowerment','Working with underprivileged and vulnerable communities to build awareness, skills and sustainable livelihoods.',8),
('Research & Knowledge','Using research-based approaches and sharing knowledge through dissemination and publication.',9),
('SDG Adaptation','Connecting local initiatives and development work with the Sustainable Development Goals.',10)
ON CONFLICT DO NOTHING;

-- Programs / initiatives shown on the Projects page and reused on the homepage.
INSERT INTO public.projects(name,slug,location,year,status,description,featured_image,display_order) VALUES
('Environmental awareness & tree plantation','environmental-awareness-tree-plantation','Bangladesh','', 'Published','Building public understanding and participation around environmental protection.','https://images.unsplash.com/photo-1492496913980-501348b61469?auto=format&fit=crop&w=1400&q=85',1),
('Community empowerment','community-empowerment','Bangladesh','', 'Published','Supporting vulnerable and underprivileged communities through knowledge and skills.','https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?auto=format&fit=crop&w=1400&q=85',2),
('E-waste collection, recycling & reuse','e-waste-collection-recycling-reuse','Bangladesh','', 'Published','Exploring responsible pathways for electronic waste and reusable materials.','https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=1400&q=85',3),
('Sustainable & solar-electric initiatives','sustainable-solar-electric-initiatives','Bangladesh','', 'Published','Promoting clean energy and practical sustainable energy solutions.','https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=1400&q=85',4)
ON CONFLICT(slug) DO UPDATE SET
 name=EXCLUDED.name, location=EXCLUDED.location, status=EXCLUDED.status, description=EXCLUDED.description, featured_image=EXCLUDED.featured_image, display_order=EXCLUDED.display_order;

-- Homepage story and editable text.
INSERT INTO public.site_content(id,eyebrow,title,lead,body,extra_data) VALUES
('homepage_story_1','Society / Non-profit organization','A greener Bangladesh begins with people.','Environmental protection, social development, sustainability, research and community empowerment — connected through practical action.','', '{}'::jsonb),
('homepage_story_2','OUR PURPOSE','Knowledge becomes powerful when communities can use it.','EcoSafe Bangladesh works to empower people with knowledge, skills and awareness to address environmental and social challenges, improve hygiene and health, and build sustainable livelihoods.','', '{}'::jsonb),
('homepage_story_3','OUR VISION','Greener. Healthier. More inclusive.','A Bangladesh where environmental protection, education and community empowerment work together to create healthier places and more sustainable futures.','', '{}'::jsonb),
('homepage_focus','Areas of focus','','Our work moves across the systems that shape everyday life — from water and waste to worker safety, clean energy, research and community resilience.','', '{"items":[{"title":"Environmental Protection","description":"Environmental awareness, action and research."},{"title":"Urban Environment","description":"Practical approaches for healthier cities and communities."},{"title":"Water & Sanitation","description":"Clean water, hygiene and healthier living."},{"title":"Waste Management","description":"Collection, reuse, recycling and responsible systems."},{"title":"Clean Energy","description":"Sustainable and solar-electric initiatives."},{"title":"Community Empowerment","description":"Knowledge, skills and sustainable livelihoods."},{"title":"Research & Knowledge","description":"Research-based approaches and dissemination."},{"title":"SDG Adaptation","description":"Connecting local action with global goals."}]}'::jsonb),
('homepage_mission','Mission & vision','Building capability for a healthier, more sustainable future.','','', '{"mission":"Empower people with knowledge, skills, and awareness to address environmental and social challenges, improve hygiene and health, and build sustainable livelihoods.","vision":"Build a greener, healthier, and more inclusive Bangladesh through environmental protection, education, and community empowerment."}'::jsonb),
('homepage_programs','Programs & initiatives','','From awareness and tree plantation to e-waste, rooftop gardening, sustainable energy and research dissemination, EcoSafe''s direction is rooted in practical community action.','', '{}'::jsonb),
('homepage_cta','Get involved','There is more than one way to contribute to change.','','', '{}'::jsonb),

('about_hero','Programs & projects','Practical environmental solutions built around people, systems and evidence.','','', '{}'::jsonb),
('about_feature','Featured project','Waste Management Pilot — DOHS Mohakhali','A three-month pilot introducing residential source segregation across 20 buildings along one road, in partnership with existing waste-management companies.','', '{}'::jsonb),
('about_intro','About the project','Environmental conservation as a foundation for human wellbeing.','','', '{"paragraph1":"Ecosafe Bangladesh is a nonprofit organisation focused on improving people’s lives through practical environmental solutions. At Ecosafe, we view environmental conservation as fundamental to human wellbeing and sustainable development.","paragraph2":"We work to address Bangladesh’s development challenges through three core areas: sustainable urban development, waste management, and skills development."}'::jsonb),
('about_problem','Problem statement','Why source segregation matters.','','', '{"paragraph1":"Large volumes of mixed municipal waste from Dhaka’s North areas are currently transported to the already-constrained Amin Bazar landfill. Because waste is not segregated at source, recyclable and organic materials are mixed with residual waste.","paragraph2":"This not only increases the volume of waste requiring disposal but also creates health and safety risks for informal waste workers working in mixed waste sites.","paragraph3":"The planned Amin Bazar waste-to-energy facility further underscores the need for source segregation. Batteries, e-waste and other hazardous materials require separate handling, while certain wastes reduce energy recovery efficiency. Segregation at source can therefore improve worker safety, resource recovery and the quality of residual waste for energy generation."}'::jsonb),
('about_pilot','Pilot brief','Building a circular waste-management ecosystem at building level.','The pilot will introduce waste segregation at the residential level across 20 buildings along one road in DOHS Mohakhali. It will partner with existing waste-management companies to channel segregated waste into appropriate recycling, recovery and disposal streams.','', '{}'::jsonb),
('about_outcomes','Expected outcomes','','','', '{"items":["Connect existing waste-management ecosystems","Establish a circular waste-management model","Generate evidence for scaling","Improve the quality of residual waste for disposal and energy recovery","Improve informal waste workers’ health and safety","Divert e-waste and lead-acid batteries from landfills"]}'::jsonb),
('about_other_programs','Other programs & initiatives','','','', '{"selectedProjectIds":[]}'::jsonb),
('about_longterm','Long-term direction','','','', '{"items":[{"eyebrow":"Learning, research & capability","title":"Training & research center","description":"Establishment of a training and research center to strengthen skills, research and development-sector capability.","image":"https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Waste, recovery & reuse","title":"Waste management plant","description":"Establishment of a waste management plant as part of a longer-term environmental systems direction.","image":"https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Evidence into policy","title":"Policy contribution","description":"Contribution to policy making and implementation through evidence, research and field experience.","image":"https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Sustainable enterprise","title":"Social & sustainable business","description":"Supporting social and sustainable business models that contribute to sustainable livelihoods and environmental responsibility.","image":"https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=1500&q=85"}]}'::jsonb),

('services_hero','What we do','Practical work for healthier people and a healthier environment.','','', '{}'::jsonb),
('services_intro','Core areas','','','', '{}'::jsonb),
('services_closing','From idea to action','','Our direction spans awareness, consultancy, research and community initiatives — with a long-term view toward training, research infrastructure and stronger environmental systems.','', '{}'::jsonb),

('projects_hero','Programs & initiatives','Turning environmental awareness into visible, practical action.','','', '{}'::jsonb),
('projects_longterm','Long-term direction','','','', '{"items":[{"eyebrow":"Learning, research & capability","title":"Training & research center","description":"Future infrastructure for skills, evidence-based learning and environmental research.","image":"https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Waste, recovery & reuse","title":"Waste management plant","description":"A longer-term ambition around responsible waste systems and circular resource use.","image":"https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Evidence into policy","title":"Policy contribution","description":"Contributing to policy making and implementation through evidence, research and field experience.","image":"https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?auto=format&fit=crop&w=1500&q=85"},{"eyebrow":"Sustainable enterprise","title":"Social & sustainable business","description":"Exploring models that connect social impact, environmental responsibility and sustainable livelihoods.","image":"https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=1500&q=85"}]}'::jsonb),

('join_intro','Join EcoSafe','Your skills, time and ideas can become part of a larger change.','','', '{}'::jsonb),
('join_volunteer','Volunteer','Bring your time to the field.','Support awareness, education, community activities and environmental initiatives. The exact volunteer pathways can grow with EcoSafe''s programs.','', '{}'::jsonb),
('join_collaborate','Collaborate','Bring expertise to the table.','EcoSafe''s direction includes consultancy, research, sustainable business and development-sector collaboration. Professionals and institutions can connect around shared goals.','', '{}'::jsonb),
('join_research','Research','Turn evidence into action.','Contribute knowledge, research, analytical skills and dissemination that help communities and decision-makers understand environmental and social challenges.','', '{}'::jsonb),
('join_partner','Partner','Build something useful together.','Organizations, institutions and development partners can explore opportunities around sustainability, clean energy, waste, water, health and community development.','', '{}'::jsonb),
('join_cta','Start a conversation','Tell us where you can make a difference.','','', '{}'::jsonb),

('contact_hero','Contact EcoSafe Bangladesh','For partnerships, research, consultancy and community initiatives.','','', '{}'::jsonb),
('contact_org','Organization','EcoSafe Bangladesh','','', '{"body":"A Society / NGO focused on environmental protection, social development, sustainability, research and community empowerment.","registration":"Registered under: RJSC<br>Possible registered office: Banani DOHS"}'::jsonb)
ON CONFLICT(id) DO UPDATE SET
 eyebrow=EXCLUDED.eyebrow,
 title=EXCLUDED.title,
 lead=EXCLUDED.lead,
 body=EXCLUDED.body,
 extra_data=EXCLUDED.extra_data,
 updated_at=now();

-- Homepage selected programs: first two. About page shows three.
UPDATE public.site_content SET extra_data=jsonb_set(extra_data,'{selectedProjectIds}',to_jsonb(ARRAY[(SELECT id::text FROM public.projects WHERE slug='environmental-awareness-tree-plantation'),(SELECT id::text FROM public.projects WHERE slug='e-waste-collection-recycling-reuse')])) WHERE id='homepage_programs';
UPDATE public.site_content SET extra_data=jsonb_set(extra_data,'{selectedProjectIds}',to_jsonb(ARRAY[(SELECT id::text FROM public.projects WHERE slug='environmental-awareness-tree-plantation'),(SELECT id::text FROM public.projects WHERE slug='community-empowerment'),(SELECT id::text FROM public.projects WHERE slug='sustainable-solar-electric-initiatives')])) WHERE id='about_other_programs';
