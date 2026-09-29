-- EcoSafe project CMS final migration
-- Run this once in Supabase SQL Editor.

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ecosafe_projects_public_read ON public.projects;
CREATE POLICY ecosafe_projects_public_read
ON public.projects FOR SELECT
TO anon, authenticated
USING (status <> 'Draft' OR public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_projects_admin_insert ON public.projects;
CREATE POLICY ecosafe_projects_admin_insert
ON public.projects FOR INSERT TO authenticated
WITH CHECK (public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_projects_admin_update ON public.projects;
CREATE POLICY ecosafe_projects_admin_update
ON public.projects FOR UPDATE TO authenticated
USING (public.ecosafe_is_admin())
WITH CHECK (public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_projects_admin_delete ON public.projects;
CREATE POLICY ecosafe_projects_admin_delete
ON public.projects FOR DELETE TO authenticated
USING (public.ecosafe_is_admin());

INSERT INTO storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
VALUES ('ecosafe-media','ecosafe-media',true,10485760,ARRAY['image/svg+xml','image/png','image/jpeg','image/webp'])
ON CONFLICT(id) DO UPDATE SET public=true,file_size_limit=10485760,allowed_mime_types=EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS ecosafe_media_public_read ON storage.objects;
CREATE POLICY ecosafe_media_public_read ON storage.objects FOR SELECT TO public
USING (bucket_id='ecosafe-media');

DROP POLICY IF EXISTS ecosafe_media_admin_insert ON storage.objects;
CREATE POLICY ecosafe_media_admin_insert ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id='ecosafe-media' AND public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_media_admin_update ON storage.objects;
CREATE POLICY ecosafe_media_admin_update ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id='ecosafe-media' AND public.ecosafe_is_admin())
WITH CHECK (bucket_id='ecosafe-media' AND public.ecosafe_is_admin());

DROP POLICY IF EXISTS ecosafe_media_admin_delete ON storage.objects;
CREATE POLICY ecosafe_media_admin_delete ON storage.objects FOR DELETE TO authenticated
USING (bucket_id='ecosafe-media' AND public.ecosafe_is_admin());
