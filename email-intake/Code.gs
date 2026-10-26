/**
 * Email intake: saves attachments from client emails into the Drive
 * "Inbox - to file" folder, where "file my inbox" splits, names and files them.
 *
 * Two ways in:
 *   1. Send or forward an email to your own address with "+file" added
 *      (e.g. yourname+file@gmail.com).
 *   2. Put the Gmail label "CRM/To file" on any email.
 * Every saved email gets the label "CRM/Saved", so nothing is saved twice.
 * Runs every 10 minutes once installTrigger() has been run once.
 */

const INBOX_FOLDER_ID = '1JtdRkxlRbaFx6J8fIHF3amfGKEy0wXF2'; // CRM/Inbox - to file
const TODO_LABEL = 'CRM/To file';
const DONE_LABEL = 'CRM/Saved';
const MIN_BYTES = 15 * 1024; // skip email signature logos and tiny images

function saveClientAttachments() {
  const me = Session.getActiveUser().getEmail();
  const plus = me.replace('@', '+file@');
  const done = label_(DONE_LABEL);
  const query = '(to:' + plus + ' OR label:"' + TODO_LABEL + '") has:attachment -label:"' + DONE_LABEL + '" newer_than:30d';
  const folder = DriveApp.getFolderById(INBOX_FOLDER_ID);
  const tz = Session.getScriptTimeZone();

  GmailApp.search(query, 0, 50).forEach(thread => {
    thread.getMessages().forEach(msg => {
      const day = Utilities.formatDate(msg.getDate(), tz, 'yyyy-MM-dd');
      const from = msg.getFrom().replace(/<.*>/, '').replace(/["']/g, '').trim() || 'unknown';
      msg.getAttachments({ includeInlineImages: false }).forEach(att => {
        if (att.getSize() < MIN_BYTES) return;
        const file = folder.createFile(att.copyBlob());
        file.setName(day + ' from ' + from + ' - ' + att.getName());
        file.setDescription('Email: ' + msg.getSubject() + '\nFrom: ' + msg.getFrom());
      });
    });
    thread.addLabel(done);
    const todo = GmailApp.getUserLabelByName(TODO_LABEL);
    if (todo) thread.removeLabel(todo);
  });
}

/** Run once by hand: makes the labels and the 10-minute timer. */
function installTrigger() {
  label_(TODO_LABEL);
  label_(DONE_LABEL);
  ScriptApp.getProjectTriggers()
    .filter(t => t.getHandlerFunction() === 'saveClientAttachments')
    .forEach(t => ScriptApp.deleteTrigger(t));
  ScriptApp.newTrigger('saveClientAttachments').timeBased().everyMinutes(10).create();
}

function label_(name) {
  return GmailApp.getUserLabelByName(name) || GmailApp.createLabel(name);
}
