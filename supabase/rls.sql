-- EcoSafe Bangladesh RLS
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.company_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_enquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media_assets ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.ecosafe_is_admin() RETURNS boolean
LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$ SELECT EXISTS(SELECT 1 FROM public.admin_users WHERE id=auth.uid() AND is_active=true); $$;

DROP POLICY IF EXISTS ecosafe_admin_self_select ON public.admin_users; CREATE POLICY ecosafe_admin_self_select ON public.admin_users FOR SELECT TO authenticated USING(id=auth.uid() OR public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_admin_manage ON public.admin_users; CREATE POLICY ecosafe_admin_manage ON public.admin_users FOR ALL TO authenticated USING(public.ecosafe_is_admin()) WITH CHECK(public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_projects_public_read ON public.projects; CREATE POLICY ecosafe_projects_public_read ON public.projects FOR SELECT TO anon,authenticated USING(status <> 'Draft' OR public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_projects_admin_insert ON public.projects; CREATE POLICY ecosafe_projects_admin_insert ON public.projects FOR INSERT TO authenticated WITH CHECK(public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_projects_admin_update ON public.projects; CREATE POLICY ecosafe_projects_admin_update ON public.projects FOR UPDATE TO authenticated USING(public.ecosafe_is_admin()) WITH CHECK(public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_projects_admin_delete ON public.projects; CREATE POLICY ecosafe_projects_admin_delete ON public.projects FOR DELETE TO authenticated USING(public.ecosafe_is_admin());

DO $$ DECLARE t text; BEGIN FOREACH t IN ARRAY ARRAY['services','site_content','company_settings','social_links','media_assets'] LOOP EXECUTE format('DROP POLICY IF EXISTS %I_public_read ON public.%I', 'ecosafe_'||t, t); EXECUTE format('CREATE POLICY %I_public_read ON public.%I FOR SELECT TO anon,authenticated USING(true)', 'ecosafe_'||t, t); EXECUTE format('DROP POLICY IF EXISTS %I_admin_insert ON public.%I', 'ecosafe_'||t, t); EXECUTE format('CREATE POLICY %I_admin_insert ON public.%I FOR INSERT TO authenticated WITH CHECK(public.ecosafe_is_admin())', 'ecosafe_'||t, t); EXECUTE format('DROP POLICY IF EXISTS %I_admin_update ON public.%I', 'ecosafe_'||t, t); EXECUTE format('CREATE POLICY %I_admin_update ON public.%I FOR UPDATE TO authenticated USING(public.ecosafe_is_admin()) WITH CHECK(public.ecosafe_is_admin())', 'ecosafe_'||t, t); EXECUTE format('DROP POLICY IF EXISTS %I_admin_delete ON public.%I', 'ecosafe_'||t, t); EXECUTE format('CREATE POLICY %I_admin_delete ON public.%I FOR DELETE TO authenticated USING(public.ecosafe_is_admin())', 'ecosafe_'||t, t); END LOOP; END $$;

DROP POLICY IF EXISTS ecosafe_enquiry_insert ON public.contact_enquiries; CREATE POLICY ecosafe_enquiry_insert ON public.contact_enquiries FOR INSERT TO anon,authenticated WITH CHECK(length(trim(name))>0 AND length(trim(email))>0 AND length(trim(message))>0);
DROP POLICY IF EXISTS ecosafe_enquiry_admin_select ON public.contact_enquiries; CREATE POLICY ecosafe_enquiry_admin_select ON public.contact_enquiries FOR SELECT TO authenticated USING(public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_enquiry_admin_update ON public.contact_enquiries; CREATE POLICY ecosafe_enquiry_admin_update ON public.contact_enquiries FOR UPDATE TO authenticated USING(public.ecosafe_is_admin()) WITH CHECK(public.ecosafe_is_admin());
DROP POLICY IF EXISTS ecosafe_enquiry_admin_delete ON public.contact_enquiries; CREATE POLICY ecosafe_enquiry_admin_delete ON public.contact_enquiries FOR DELETE TO authenticated USING(public.ecosafe_is_admin());
