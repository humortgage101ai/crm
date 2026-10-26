# Plan (draft)

## Open questions for Hu
1. ~~Where do client documents live?~~ **Decided 2026-10-26: Google Drive**, folder `My Drive/CRM`:
   `Clients/` (one folder per client), `Inbox - to file/` (new statements land here first),
   `Ad Spend/` (the ad-spend tracker). Not GitHub.
2. **Which email account?** Outlook / Microsoft 365 — which mailbox and folder receive
   statements and ad-spend receipts?
3. **How are clients identified on a statement?** Name, policy number, or lender reference —
   decides how a statement is matched to its client folder.
4. **Ad-spend sources** — which platforms (Google Ads, Facebook/Meta, others) and which
   receipts arrive by email?

## First steps once those are answered
1. Client list + folder layout (one folder per client, sub-folders per year / policy).
2. Statement filing: read an incoming PDF, find the client, file it, log it.
3. Ad-spend log: read receipt emails from the Outlook folder → date, platform, amount.
