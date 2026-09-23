# EcoSafe Bangladesh — Website + Admin CMS

This package contains the EcoSafe public website and its dedicated `/admin/` CMS.

## Public site
- Home
- About & waste-management pilot
- Services
- Projects & initiatives
- Join Us
- Contact Us

## Admin CMS
- Homepage text editor
- About & pilot content editor
- Services CRUD
- Projects & initiatives CRUD
- Join Us editor
- Contact details + social links
- Contact enquiry inbox
- Media Library with Supabase Storage upload/delete
- Account/password settings

## Supabase
See `ADMIN-SETUP.md` and the `supabase/` folder.

The public website and admin panel both read `js/supabase-config.js`. Use only the public/anon key in browser files.
