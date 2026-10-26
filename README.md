# Hu's CRM

A private web app for Hu's mortgage and insurance business: clients, mortgages with renewal dates,
insurance policies, commissions (default split 90% of gross, editable per deal, paid / not paid),
ad spend with cost per lead, and notes per client. Each client page has **Email** (opens a Gmail
message), **Call**, **Drive folder** (the client's folder in Google Drive, found by client ID
like `C0042` when no link is saved) and, once set, **Send docs to file** (the `+file` Gmail
address that drops attachments into Drive "Inbox - to file" — see `email-intake/`).

## How it's built

No build step: `app/index.html` is the whole app (inline CSS + JS), talking to Supabase from the
browser with the publishable key. Every table is locked by row-level security to the emails in
`crm_users` (`supabase/schema.sql`). Sign-in is a code emailed to Hu (no passwords, no sign-ups).

With `app/config.js` left empty the app runs in **demo mode**: made-up clients saved only in that
browser. Nothing real goes in until Supabase is set up and Hu has OK'd it.

## Preview locally

```bash
cd app && python3 -m http.server 8077   # http://localhost:8077
```

## Going live (once Hu picks hosting)

1. New Supabase project (Canada region), run `supabase/schema.sql`, add Hu's email to `crm_users`.
2. Auth: turn off "Allow new users to sign up"; create Hu's user; email template shows the 6-digit code.
3. Put the project URL + publishable key in `app/config.js`.
4. Host `app/` on Cloudflare Pages (`npx wrangler pages deploy app --project-name=hu-crm`).
