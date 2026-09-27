# EcoSafe Bangladesh — Admin Panel

A dedicated EcoSafe Bangladesh CMS. It has its own Supabase schema, Storage bucket, Auth admin registry, and service layer.

## Backend services
- `services/supabaseClient.js` — browser Supabase client
- `services/authService.js` — authentication + admin authorization
- `services/projectService.js` — initiative CRUD
- `services/contentService.js` — page content, services, company settings and social links
- `services/enquiryService.js` — contact enquiry CRUD
- `services/mediaService.js` — Storage upload/delete + media registry sync
- `services/index.js` — service exports
- `services/supabase-bundle.js` — bundled Supabase browser client

The service layer does not use localStorage as a database fallback. Delete operations verify that the database row was actually removed.
