-- EcoSafe Bangladesh: register an already-created Supabase Auth user as an admin.
-- Run this in Supabase SQL Editor AFTER creating the user in Authentication > Users.
-- Replace the email below with the exact email of your Auth user.

INSERT INTO public.admin_users (id, email, role, is_active)
SELECT id, email, 'admin', true
FROM auth.users
WHERE lower(email) = lower('YOUR-ADMIN-EMAIL-HERE')
ON CONFLICT (id) DO UPDATE
SET email = EXCLUDED.email,
    role = 'admin',
    is_active = true;

-- Verify:
SELECT id, email, role, is_active
FROM public.admin_users
ORDER BY created_at DESC;
