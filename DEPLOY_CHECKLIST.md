# Deploy checklist — Hu's CRM

## Where things live
- **Supabase:** org "Hu CRM" (free plan), project `hu-crm`, ref `eamjbfwiifzqmgkhqjmv`, region ca-central-1 (Canada).
  DB password: Windows Credential Manager on Hu's PC, entry `hu-crm-db` (never in this repo).
- **Website:** Cloudflare Pages project `hu-crm` → https://hu-crm.pages.dev (serves the `app/` folder).

## Done (2026-11-18)
1. Created the Supabase project and ran `supabase/schema.sql` (RLS on every table).
2. Added Hu's email to `crm_users`; created Hu's sign-in user (confirmed). Sign-ups are turned off.
3. Auth: site URL https://hu-crm.pages.dev, redirect allow-list includes it and http://localhost:8080, 6-digit codes.
4. `app/config.js` points at the project (publishable key only — safe in a page).

## Still to do
1. **Cloudflare login** (the saved one expired). On the PC, in a terminal:
   `npx wrangler login` → approve in the browser.
2. Create the site (once): `npx wrangler pages project create hu-crm --production-branch=main`
   (if the name is taken, use `hu-crm-app` and change Supabase Auth → URL Configuration → Site URL to match).
3. Deploy (every update): from the repo folder, `npx wrangler pages deploy app --project-name=hu-crm --branch=main --commit-dirty=true`

## Known limit
The free Supabase plan won't let us edit the sign-in email, so it contains a **link**, not a code.
Tap the link on the same device and the CRM opens signed in. To get a code in the email instead,
add a custom email sender (SMTP, e.g. Resend's free tier) under Supabase → Auth → SMTP, then
change the Magic Link template to show `{{ .Token }}`.
