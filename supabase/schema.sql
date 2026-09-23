-- EcoSafe Bangladesh CMS schema
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION public.ecosafe_set_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at=now(); RETURN NEW; END; $$;

CREATE TABLE IF NOT EXISTS public.admin_users (
 id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 email text NOT NULL UNIQUE,
 role text NOT NULL DEFAULT 'admin',
 is_active boolean NOT NULL DEFAULT true,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.projects (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, slug text NOT NULL UNIQUE,
 location text NOT NULL DEFAULT '', year text NOT NULL DEFAULT '', status text NOT NULL DEFAULT 'Draft' CHECK(status IN ('Published','Draft','Ongoing','Completed','Upcoming')),
 description text NOT NULL DEFAULT '', featured_image text NOT NULL DEFAULT '', images jsonb NOT NULL DEFAULT '[]'::jsonb,
 display_order int NOT NULL DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.services (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), title text NOT NULL, description text NOT NULL DEFAULT '', image_url text NOT NULL DEFAULT '', display_order int NOT NULL DEFAULT 0,
 created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.site_content (
 id text PRIMARY KEY, eyebrow text NOT NULL DEFAULT '', title text NOT NULL DEFAULT '', lead text NOT NULL DEFAULT '', body text NOT NULL DEFAULT '', image_url text NOT NULL DEFAULT '', extra_data jsonb NOT NULL DEFAULT '{}'::jsonb, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.company_settings (
 id text PRIMARY KEY DEFAULT 'default', company_name text NOT NULL DEFAULT 'EcoSafe Bangladesh', tagline text NOT NULL DEFAULT 'Greener. Healthier. More Inclusive.', established_year text NOT NULL DEFAULT '', address text NOT NULL DEFAULT 'Banani DOHS, Dhaka, Bangladesh', phone text NOT NULL DEFAULT '', email text NOT NULL DEFAULT '', contact_intro text NOT NULL DEFAULT '', updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.social_links (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), platform text NOT NULL, url text NOT NULL, is_active boolean NOT NULL DEFAULT true, display_order int NOT NULL DEFAULT 0, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.contact_enquiries (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, email text NOT NULL, phone text NOT NULL DEFAULT '', organization text NOT NULL DEFAULT '', message text NOT NULL,
 status text NOT NULL DEFAULT 'New' CHECK(status IN ('New','Read','Archived')), created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.media_assets (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), filename text NOT NULL, storage_path text NOT NULL UNIQUE, public_url text NOT NULL, usage_tag text NOT NULL DEFAULT '', file_type text NOT NULL DEFAULT 'IMAGE', file_size bigint NOT NULL DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ecosafe_projects_order ON public.projects(display_order);
CREATE INDEX IF NOT EXISTS idx_ecosafe_services_order ON public.services(display_order);
CREATE INDEX IF NOT EXISTS idx_ecosafe_enquiries_created ON public.contact_enquiries(created_at DESC);

DROP TRIGGER IF EXISTS trg_admin_updated ON public.admin_users; CREATE TRIGGER trg_admin_updated BEFORE UPDATE ON public.admin_users FOR EACH ROW EXECUTE FUNCTION public.ecosafe_set_updated_at();
DROP TRIGGER IF EXISTS trg_projects_updated ON public.projects; CREATE TRIGGER trg_projects_updated BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.ecosafe_set_updated_at();
DROP TRIGGER IF EXISTS trg_services_updated ON public.services; CREATE TRIGGER trg_services_updated BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.ecosafe_set_updated_at();
DROP TRIGGER IF EXISTS trg_site_content_updated ON public.site_content; CREATE TRIGGER trg_site_content_updated BEFORE UPDATE ON public.site_content FOR EACH ROW EXECUTE FUNCTION public.ecosafe_set_updated_at();
DROP TRIGGER IF EXISTS trg_company_updated ON public.company_settings; CREATE TRIGGER trg_company_updated BEFORE UPDATE ON public.company_settings FOR EACH ROW EXECUTE FUNCTION public.ecosafe_set_updated_at();
