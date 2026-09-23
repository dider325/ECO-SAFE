# EcoSafe Bangladesh CMS Backend

1. Create a new Supabase project dedicated to EcoSafe.
2. Run `schema.sql`, then `rls.sql`, then `storage.sql`.
3. Create the first administrator in Supabase Authentication.
4. Insert that Auth user into `public.admin_users` with the same UUID/email.
5. Run `seed.sql`.
6. Put the project URL and anon key into `js/supabase-config.js`.

The admin service layer intentionally has no localStorage fallback. CRUD failures are surfaced instead of silently pretending that an operation succeeded. Delete operations verify that a row was actually deleted.
