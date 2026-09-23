# EcoSafe Bangladesh — Admin + CMS Setup

## Existing project
If the EcoSafe Supabase project is already created and the base schema/RLS/storage are already installed, run only:

`supabase/migrate-v3-ecosafe-cms.sql`

This updates the CMS content to match the current EcoSafe website and removes the accidental Moiré social placeholder.

## Fresh project
Run these in order:
1. `supabase/schema.sql`
2. `supabase/rls.sql`
3. `supabase/storage.sql`
4. `supabase/seed.sql`

Then create the admin user in Supabase Authentication and run `supabase/bootstrap-admin.sql` with the exact email.

## Configuration
Set the same Supabase Project URL and public/anon key in:
- `js/supabase-config.js` (public website)

The admin panel reads that same config file from the parent website directory.

Never place a `service_role` or secret key in browser files.
