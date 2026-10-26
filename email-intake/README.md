# Email intake (Gmail → Drive inbox)

Saves attachments from client emails into Drive `CRM/Inbox - to file`.
From there, "file my inbox" splits combined PDFs, turns photos into
compressed PDFs, names each document and files it in the client's folder.

## Set up (5 minutes, once)

1. Go to https://script.google.com signed in as the Gmail account, click **New project**, name it "CRM email intake".
2. Replace the code with `Code.gs` from this folder and save.
3. Pick `installTrigger` in the function menu and click **Run**. Allow access when Google asks
   (Gmail to read the emails, Drive to save the files).

## Use it

- Forward a client's email, or attach files to a new email, to your address with `+file`
  added before the @ (for Gmail: `yourname+file@gmail.com`). Add it as a contact called "CRM file".
- Or put the label **CRM/To file** on an email already in your inbox.

Within 10 minutes the attachments are in `Inbox - to file`, named
`<date> from <sender> - <original name>`. Saved emails get the label **CRM/Saved**.
Small images under 15 KB (signature logos) are skipped.

Nothing is sent from your account. The script only reads emails that match the two rules above.
