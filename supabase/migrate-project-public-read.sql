-- Ensure public visitors can read non-draft EcoSafe projects.
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ecosafe_projects_public_read ON public.projects;
CREATE POLICY ecosafe_projects_public_read
ON public.projects FOR SELECT TO anon, authenticated
USING (status <> 'Draft' OR public.ecosafe_is_admin());
