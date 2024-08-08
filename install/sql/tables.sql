-- DROP TABLE IF EXISTS webcal_access_function;
CREATE TABLE IF NOT EXISTS webcal_access_function (
  cal_login varchar(25) NOT NULL,
  cal_permissions varchar(64) NOT NULL DEFAULT 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN' COMMENT 'A string of Y and/or N for the various functions',
  PRIMARY KEY (cal_login)
) COMMENT='Specifies what WebCalendar functions a user can access. Each function has a corresponding numeric value (specified in the file includes/access.php). For example, view event is 0, so the very first character in the cal_permissions column is either a "Y" if this user can view events or an "N" if they cannot.';

-- DROP TABLE IF EXISTS webcal_access_user;
CREATE TABLE IF NOT EXISTS webcal_access_user (
  cal_login varchar(25) NOT NULL COMMENT 'current user who is attempting to look at another user''s calendar',
  cal_other_user varchar(25) NOT NULL COMMENT 'login of the other user whose calendar the current user wants to access',
  cal_can_approve int(11) NOT NULL DEFAULT 0 COMMENT 'can current user approve events on the other user''s calendar?',
  cal_can_edit int(11) NOT NULL DEFAULT 0 COMMENT 'can current user edit events on the other user''s calendar?',
  cal_can_view int(11) NOT NULL DEFAULT 0 COMMENT 'can current user view events on the other user''s calendar?',
  cal_see_time_only char(1) DEFAULT 'N' COMMENT 'can current user can only see time of other user?',
  cal_can_email char(1) DEFAULT 'Y' COMMENT 'can current user send emails to other user?',
  cal_can_invite char(1) DEFAULT 'Y' COMMENT 'can current user see other user in Participant lists?',
  PRIMARY KEY (cal_login,cal_other_user)
) COMMENT='Specifies which users can access another user''s calendar.';

-- DROP TABLE IF EXISTS webcal_asst;
CREATE TABLE IF NOT EXISTS webcal_asst (
  cal_boss varchar(25) NOT NULL COMMENT 'login of boss',
  cal_assistant varchar(25) NOT NULL COMMENT 'login of assistant',
  PRIMARY KEY (cal_boss,cal_assistant)
) COMMENT='Define assistant/boss relationship.';

-- DROP TABLE IF EXISTS webcal_blob;
CREATE TABLE IF NOT EXISTS webcal_blob (
  cal_blob_id int(11) NOT NULL COMMENT 'Unique identifier for this object',
  cal_login varchar(25) DEFAULT NULL COMMENT 'of creator',
  cal_id int(11) DEFAULT NULL COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table (if applicable)',
  cal_description varchar(128) DEFAULT NULL COMMENT 'of what the object is (subject for comment)',
  cal_mime_type varchar(50) DEFAULT NULL COMMENT 'of object (as specified by browser during upload) (not used for comment)',
  cal_name varchar(30) DEFAULT NULL COMMENT 'Filename of object (not used for comments)',
  cal_size int(11) DEFAULT NULL COMMENT 'of object (not used for comment)',
  cal_type char(1) NOT NULL COMMENT 'of object: Comment, Attachment',
  cal_mod_date int(11) NOT NULL COMMENT 'in YYYYMMDD format',
  cal_mod_time int(11) NOT NULL COMMENT 'in HHMMSS format',
  cal_blob longblob DEFAULT NULL COMMENT 'binary data for object',
  PRIMARY KEY (cal_blob_id),
  KEY ndx_wb_cl (cal_login),
  KEY ndx_wb_ci (cal_id)
) COMMENT='Stores event attachments and comments.';

-- DROP TABLE IF EXISTS webcal_categories;
CREATE TABLE IF NOT EXISTS webcal_categories (
  cat_id int(11) NOT NULL COMMENT 'Unique category id',
  cat_owner varchar(25) NOT NULL DEFAULT '' COMMENT 'User login of category owner. If this is empty, then it is a global category',
  cat_color varchar(8) DEFAULT NULL COMMENT 'RGB color for category',
  cat_icon_mime varchar(32) DEFAULT NULL COMMENT 'Category icon mime type (e.g. "image/png")',
  cat_name varchar(80) NOT NULL COMMENT 'of category',
  cat_status char(1) DEFAULT 'A' COMMENT 'of the category (A = Active, I = Inactive, D = Deleted)',
  cat_icon_blob longblob DEFAULT NULL COMMENT 'category icon image blob',
  PRIMARY KEY (cat_id,cat_owner),
  KEY ndx_wc_co (cat_owner)
) COMMENT='Defines user categories. Categories can be specific to a user or global. When a category is global, the cat_owner field will be NULL. (Only an admin user can create a global category.)';

-- DROP TABLE IF EXISTS webcal_config;
CREATE TABLE IF NOT EXISTS webcal_config (
  cal_setting varchar(50) NOT NULL,
  cal_value varchar(100) DEFAULT NULL,
  PRIMARY KEY (cal_setting)
) ENGINE=MyISAM  COMMENT='System settings (set by the admin interface in admin.php)';

-- DROP TABLE IF EXISTS webcal_entry;
CREATE TABLE IF NOT EXISTS webcal_entry (
  cal_id int(11) NOT NULL COMMENT 'Unique integer ID for event',
  cal_create_by varchar(25) NOT NULL COMMENT 'Creator of the event',
  cal_ext_for_id int(11) DEFAULT NULL COMMENT 'Used when an event goes past midnight into the next day, in which case an additional entry in this table will use this field to indicate the original event cal_id',
  cal_group_id int(11) DEFAULT NULL COMMENT 'Parent Event ID from <a href="#webcal_entry">webcal_entry</a> table if this event is overriding an occurrence of a repeating event',
  cal_access char(1) DEFAULT 'P' COMMENT 'Public, pRrivate (others cannot see the event), Confidential (others can see time allocated but not what it is)',
  cal_completed int(11) DEFAULT NULL COMMENT 'Date task completed',
  cal_duration int(11) NOT NULL COMMENT 'of event in minutes',
  cal_location varchar(100) DEFAULT NULL COMMENT 'of event',
  cal_name varchar(80) NOT NULL COMMENT 'Brief description of event',
  cal_priority int(11) DEFAULT 5 COMMENT '1=High, 5=Med, 9=Low',
  cal_type char(1) DEFAULT 'E' COMMENT 'E = Event, M = Repeating event, T = Task',
  cal_date int(11) NOT NULL COMMENT 'in YYYYMMDD format',
  cal_time int(11) DEFAULT NULL COMMENT 'in HHMMSS format',
  cal_mod_date int(11) DEFAULT NULL COMMENT 'Event was last modified (in YYYYMMDD format)',
  cal_mod_time int(11) DEFAULT NULL COMMENT 'Event was last modified (in HHMMSS format)',
  cal_due_date int(11) DEFAULT NULL COMMENT 'Task',
  cal_due_time int(11) DEFAULT NULL COMMENT 'Task',
  cal_url varchar(255) DEFAULT NULL COMMENT 'of event',
  cal_description text DEFAULT NULL COMMENT 'Full description of event',
  PRIMARY KEY (cal_id),
  KEY ndx_we_cb (cal_create_by),
  KEY ndx_we_efi (cal_ext_for_id),
  KEY ndx_we_gi (cal_group_id)
) COMMENT='Defines a calendar event. Each event in the system has one entry here, unless the event crosses midnight. In that case a secondary event will be created with cal_ext_for_id set to the cal_id of the original entry. The following tables contain additional information about each event:<ul><li><a href="#webcal_entry_user">webcal_entry_user</a> table - lists participants in the event and specifies the status (accepted, rejected) and category of each participant.</li><li><a href="#webcal_entry_repeats">webcal_entry_repeats</a> table - contains information if the event repeats.</li><li><a href="#webcal_entry_repeats_not">webcal_entry_repeats_not</a> table - specifies which dates the repeating event does not repeat (because they were deleted or modified for just that date by the user)</li><li><a href="#webcal_entry_log">webcal_entry_log</a> table - provides a history of changes to this event.</li><li><a href="#webcal_site_extras">webcal_site_extras</a> table - stores event data as defined in site_extras.php (such as reminders and other custom event fields).</li></ul>';

-- DROP TABLE IF EXISTS webcal_entry_categories;
CREATE TABLE IF NOT EXISTS webcal_entry_categories (
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table. Not unique here.',
  cat_id int(11) NOT NULL DEFAULT 0 COMMENT 'Category ID from <a href="#webcal_categories">webcal_categories</a> table. Not unique here.',
  cat_order int(11) NOT NULL DEFAULT 0 COMMENT 'Order that user requests their categories appear. Globals are always last.',
  cat_owner varchar(25) NOT NULL DEFAULT '' COMMENT 'Record owner from <a href="#webcal_user">webcal_user</a> table. Global categories will be empty string.',
  PRIMARY KEY (cal_id,cat_id,cat_order,cat_owner),
  KEY ndx_wec_ci (cat_id),
  KEY ndx_wec_co (cat_owner)
) COMMENT='Contains category foreign keys to enable multiple categories for each event or task,';

-- DROP TABLE IF EXISTS webcal_entry_ext_user;
CREATE TABLE IF NOT EXISTS webcal_entry_ext_user (
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table',
  cal_email varchar(75) DEFAULT NULL,
  cal_fullname varchar(50) NOT NULL,
  PRIMARY KEY (cal_id,cal_fullname)
) COMMENT='Associates one or more external users (people who do not have a WebCalendar login) with an event by the Event ID from <a href="#webcal_entry">webcal_entry</a> table. An event must still have at least one WebCalendar user associated with it. This table is not used unless external users are enabled* in system settings. The event can be found in <a href="#webcal_entry">webcal_entry</a> table.';

-- DROP TABLE IF EXISTS webcal_entry_log;
CREATE TABLE IF NOT EXISTS webcal_entry_log (
  cal_log_id int(11) NOT NULL COMMENT 'Unique ID of this log entry',
  cal_login varchar(25) NOT NULL COMMENT 'user from <a href="#webcal_user">webcal_user</a> table who performed this action',
  cal_user_cal varchar(25) DEFAULT NULL COMMENT 'user from <a href="#webcal_user">webcal_user</a> table of calendar affected',
  cal_entry_id int(11) NOT NULL COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table',
  cal_date int(11) NOT NULL COMMENT 'in YYYYMMDD format',
  cal_time int(11) DEFAULT NULL COMMENT 'in HHMMSS format',
  cal_type char(1) NOT NULL COMMENT 'log types: <ul><li>C: Created</li><li>A: Approved/Confirmed by user</li><li>R: Rejected by user</li><li>U: Updated by user</li><li>M: Mail Notification sent</li><li>E: Reminder sent</li></ul>',
  cal_text text DEFAULT NULL COMMENT 'optional',
  PRIMARY KEY (cal_log_id),
  KEY ndx_wel_cl (cal_login),
  KEY ndx_wel_cuc (cal_user_cal),
  KEY ndx_wel_cei (cal_entry_id)
) COMMENT='Activity log for an event.';

-- DROP TABLE IF EXISTS webcal_entry_repeats;
CREATE TABLE IF NOT EXISTS webcal_entry_repeats (
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table',
  cal_frequency int(11) DEFAULT 1 COMMENT 'of repeat: 1 = every, 2 = every other, 3 = every 3rd, etc.',
  cal_end int(11) DEFAULT NULL COMMENT 'date for repeating event (in YYYYMMDD format)',
  cal_endtime int(11) DEFAULT NULL COMMENT 'for repeating event (in HHMMSS format)',
  cal_type varchar(20) DEFAULT NULL COMMENT 'type of repeating: <ul><li>daily - repeats daily</li><li>monthlyByDate - repeats on same day of the month</li><li>monthlyBySetPos - repeats based on position within other ByXXX values</li><li>monthlyByDay - repeats on specified weekday (2nd Monday, for example)</li><li>weekly - repeats every week</li><li>yearly - repeats on same date every year</li></ul>',
  cal_days char(7) DEFAULT NULL COMMENT 'NO LONGER USED. We''ll leave it in for now',
  cal_byday varchar(100) DEFAULT NULL COMMENT 'The following columns are values as specified in RFC2445',
  cal_bymonth varchar(50) DEFAULT NULL,
  cal_bymonthday varchar(100) DEFAULT NULL,
  cal_bysetpos varchar(50) DEFAULT NULL,
  cal_byweekno varchar(50) DEFAULT NULL,
  cal_byyearday varchar(50) DEFAULT NULL,
  cal_count int(11) DEFAULT NULL,
  cal_wkst char(2) DEFAULT 'MO',
  PRIMARY KEY (cal_id)
) COMMENT='Defines repeating info about an event. The event is defined in <a href="#webcal_entry">webcal_entry</a> table.';

-- DROP TABLE IF EXISTS webcal_entry_repeats_not;
CREATE TABLE IF NOT EXISTS webcal_entry_repeats_not (
  cal_id int(11) NOT NULL COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table of repeating event',
  cal_date int(11) NOT NULL COMMENT 'date event should not repeat (in YYYYMMDD format)',
  cal_exdate int(1) NOT NULL DEFAULT 1 COMMENT 'Is this record is an exclusion (1) or inclusion (0)',
  PRIMARY KEY (cal_id,cal_date)
) COMMENT='Specifies which dates in a repeating event have either been deleted, included, or replaced with a replacement event for that day When replaced, the cal_group_id (I know... not the best name, but it was not being used) column will be set to the original event. That way the user can delete the original event and (at the same time) delete any exception events.';

-- DROP TABLE IF EXISTS webcal_entry_user;
CREATE TABLE IF NOT EXISTS webcal_entry_user (
  cal_login varchar(25) NOT NULL COMMENT 'participant in the event',
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table',
  cal_category int(11) DEFAULT NULL COMMENT 'category of the event for this user',
  cal_percent int(11) NOT NULL DEFAULT 0 COMMENT 'Task percentage of completion for this user''s task',
  cal_status char(1) DEFAULT 'A' COMMENT 'status of event for this user: <ul><li>A=Accepted</li><li>C=Completed</li><li>D=Deleted</li><li>P=In-Progress</li><li>R=Rejected/Declined</li><li>W=Waiting</li></ul>',
  PRIMARY KEY (cal_id,cal_login),
  KEY ndx_weu_ci (cal_id)
) COMMENT='Associates one or more users with an event by the cal_id. The event can be found in <a href="#webcal_entry">webcal_entry</a> table.';

-- DROP TABLE IF EXISTS webcal_group;
CREATE TABLE IF NOT EXISTS webcal_group (
  cal_group_id int(11) NOT NULL COMMENT 'Unique group id',
  cal_owner varchar(25) DEFAULT NULL COMMENT 'Creator from <a href="#webcal_user">webcal_user</a> table of this group',
  cal_name varchar(50) NOT NULL COMMENT 'of the group',
  cal_last_update int(11) NOT NULL COMMENT 'in YYYYMMDD format',
  PRIMARY KEY (cal_group_id),
  KEY ndx_wg_co (cal_owner)
) COMMENT='Define a group. Group members can be found in <a href="#webcal_group_user">webcal_group_user</a> table.';

-- DROP TABLE IF EXISTS webcal_group_user;
CREATE TABLE IF NOT EXISTS webcal_group_user (
  cal_group_id int(11) NOT NULL COMMENT 'Unique group id',
  cal_login varchar(25) NOT NULL,
  PRIMARY KEY (cal_group_id,cal_login),
  KEY ndx_wgu_cl (cal_login)
) COMMENT='Specify users in a group. The group is defined in <a href="#webcal_group">webcal_group</a> table.';

-- DROP TABLE IF EXISTS webcal_import;
CREATE TABLE IF NOT EXISTS webcal_import (
  cal_import_id int(11) NOT NULL COMMENT 'Unique ID for import',
  cal_login varchar(25) DEFAULT NULL COMMENT 'User from <a href="#webcal_user">webcal_user</a> table who performed the import',
  cal_check_date int(11) DEFAULT NULL COMMENT 'date of last check to see if remote calendar updated (YYYYMMDD format)',
  cal_date int(11) NOT NULL COMMENT 'of import (YYYYMMDD format)',
  cal_md5 varchar(32) DEFAULT NULL COMMENT 'md5 of last import used to see if a new import changes anything',
  cal_name varchar(50) DEFAULT NULL COMMENT 'of import (optional)',
  cal_type varchar(10) NOT NULL COMMENT 'of import (ical, vcal, palm, outlookcsv)',
  PRIMARY KEY (cal_import_id),
  KEY ndx_wi_cl (cal_login)
) COMMENT='Used to track import data (one row per import)';

-- DROP TABLE IF EXISTS webcal_import_data;
CREATE TABLE IF NOT EXISTS webcal_import_data (
  cal_login varchar(25) NOT NULL COMMENT 'User from <a href="#webcal_user">webcal_user</a> table',
  cal_id int(11) NOT NULL COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table in WebCalendar',
  cal_external_id varchar(200) DEFAULT NULL COMMENT 'Used in external calendar system (for example, UID in iCal)',
  cal_import_id int(11) NOT NULL COMMENT 'from webcal_import table',
  cal_import_type varchar(15) NOT NULL COMMENT 'type of import: palm, vcal, ical or outlookcsv',
  PRIMARY KEY (cal_id,cal_login)
) COMMENT='Used to track import data (one row per event)';

-- DROP TABLE IF EXISTS webcal_nonuser_cals;
CREATE TABLE IF NOT EXISTS webcal_nonuser_cals (
  cal_login varchar(25) NOT NULL COMMENT 'Unique ID for the calendar',
  cal_admin varchar(25) NOT NULL COMMENT 'The calendar administrator from <a href="#webcal_user">webcal_user</a> table',
  cal_firstname varchar(25) DEFAULT NULL COMMENT 'calendar',
  cal_lastname varchar(25) DEFAULT NULL COMMENT 'calendar',
  cal_is_public char(1) NOT NULL DEFAULT 'N' COMMENT 'can this nonuser calendar be a public calendar (no login required)',
  cal_url varchar(255) DEFAULT NULL COMMENT 'url of the remote calendar',
  PRIMARY KEY (cal_login),
  KEY ndx_wnc_ca (cal_admin)
) COMMENT='Defines non-user calendars.';

-- DROP TABLE IF EXISTS webcal_reminders;
CREATE TABLE IF NOT EXISTS webcal_reminders (
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table.',
  cal_action varchar(12) NOT NULL DEFAULT 'EMAIL' COMMENT 'action as imported, may be used in the future',
  cal_before char(1) NOT NULL DEFAULT 'Y' COMMENT 'specifies whether reminder is sent before or after selected edge',
  cal_date int(11) NOT NULL DEFAULT 0 COMMENT 'timestamp that specifies send datetime. Use this or cal_offset, but not both',
  cal_duration int(11) NOT NULL DEFAULT 0 COMMENT 'time in ISO 8601 format that specifies time between repeated reminders',
  cal_last_sent int(11) NOT NULL DEFAULT 0 COMMENT 'timestamp of last sent reminder',
  cal_offset int(11) NOT NULL DEFAULT 0 COMMENT 'in minutes from the selected edge',
  cal_related char(1) NOT NULL DEFAULT 'S' COMMENT 'Start, End. Specifies which edge of entry this reminder applies to',
  cal_repeats int(11) NOT NULL DEFAULT 0 COMMENT 'number of times to repeat in addition to original occurrence',
  cal_times_sent int(11) NOT NULL DEFAULT 0 COMMENT 'number of times this reminder has been sent',
  PRIMARY KEY (cal_id)
) COMMENT='Stores information about reminders';

-- DROP TABLE IF EXISTS webcal_report;
CREATE TABLE IF NOT EXISTS webcal_report (
  cal_report_id int(11) NOT NULL COMMENT 'Unique ID of this report',
  cal_login varchar(25) NOT NULL COMMENT 'Creator from <a href="#webcal_user">webcal_user</a> table of report',
  cal_user varchar(25) DEFAULT NULL COMMENT 'User from <a href="#webcal_user">webcal_user</a> table calendar to display (NULL indicates current user)',
  cal_allow_nav char(1) DEFAULT 'Y' COMMENT 'Allow user to navigate to different dates with next/previous (Y or N)',
  cal_cat_id int(11) DEFAULT NULL COMMENT 'Category to filter on (optional)',
  cal_include_empty char(1) DEFAULT 'N' COMMENT 'dates in report (Y or N)',
  cal_include_header char(1) NOT NULL DEFAULT 'Y' COMMENT 'If cal_report_type is HTML, should the DEFAULT HTML header and trailer be included? (Y or N)',
  cal_is_global char(1) NOT NULL DEFAULT 'N' COMMENT 'Is this a global report (can it be accessed by other users) (Y or N)',
  cal_report_name varchar(50) NOT NULL,
  cal_report_type varchar(20) NOT NULL COMMENT 'Format of report (html, plain or csv)',
  cal_show_in_trailer char(1) DEFAULT 'N' COMMENT 'Include a link for this report in the "Go to" section of the navigation in the page trailer (Y or N)',
  cal_time_range int(11) NOT NULL COMMENT 'for report: <ul><li>0 = tomorrow</li><li>1 = today</li><li>2 = yesterday</li><li>3 = day before yesterday</li><li>10 = next week</li><li>11 = current week</li><li>12 = last week</li><li>13 = week before last</li><li>20 = next week and week after</li><li>21 = current week and next week</li><li>22 = last week and this week</li><li>23 = last two weeks</li><li>30 = next month</li><li>31 = current month</li><li>32 = last month</li><li>33 = month before last</li><li>40 = next year</li><li>41 = current year</li><li>42 = last year</li><li>43 = year before last</li></ul>',
  cal_update_date int(11) NOT NULL COMMENT 'date created or last updated (in YYYYMMDD format)',
  PRIMARY KEY (cal_report_id),
  KEY ndx_wr_cl (cal_login),
  KEY ndx_wr_ca (cal_user)
) COMMENT='Defines a custom report created by a user.';

-- DROP TABLE IF EXISTS webcal_report_template;
CREATE TABLE IF NOT EXISTS webcal_report_template (
  cal_report_id int(11) NOT NULL COMMENT 'Report ID from <a href="#webcal_report">webcal_report</a> table',
  cal_template_type char(1) NOT NULL COMMENT '<ul><li>Page template represents entire document</li><li>Date template represents a single day of events</li><li>Event template represents a single event</li></ul>',
  cal_template_text text DEFAULT NULL COMMENT 'text of template',
  PRIMARY KEY (cal_report_id,cal_template_type)
) COMMENT='Defines one of the templates used for a report. Each report has three templates: <ol><li>Page template - Defines the entire page (except for header and footer). The following variables can be defined: <ul><li>${days}<sup>*</sup> - the HTML of all dates (generated from the Date template)</li></ul></li><li>Date template - Defines events for one day. If the report is for a week or month, then the results of each day will be concatenated and used as the ${days} variable in the Page template. The following variables can be defined: <ul><li>${events}<sup>*</sup> - the HTML of all events for the data (generated from the Event template)</li><li>${date} - the date</li><li>${fulldate} - date (includes weekday)</li></ul></li><li>Event template - Defines a single event. The following variables can be defined: <ul><li>${name}<sup>*</sup> - Brief Description of event</li><li>${description} - Full Description of event</li><li>${date} - Date of event</li><li>${fulldate} - Date of event (includes weekday)</li><li>${time} - Time of event (4:00pm - 4:30pm)</li><li>${starttime} - Start time of event</li><li>${endtime} - End time of event</li><li>${duration} - Duration of event (in minutes)</li><li>${priority} - Priority of event</li><li>${href} - URL to view event details</li></ul></li></ol><sup>*</sup> denotes a required template variable';

-- DROP TABLE IF EXISTS webcal_site_extras;
CREATE TABLE IF NOT EXISTS webcal_site_extras (
  cal_id int(11) NOT NULL DEFAULT 0 COMMENT 'Event ID from <a href="#webcal_entry">webcal_entry</a> table',
  cal_date int(11) DEFAULT 0 COMMENT 'Only used for EXTRA_DATE type fields (in YYYYMMDD format)',
  cal_name varchar(25) NOT NULL COMMENT 'Brief name of this type (first field in $site_extra array)',
  cal_remind int(11) DEFAULT 0 COMMENT 'How many minutes before event should a reminder be sent',
  cal_type int(11) NOT NULL COMMENT 'EXTRA_URL, EXTRA_DATE, etc.',
  cal_data text DEFAULT NULL COMMENT 'Store text data',
  PRIMARY KEY (cal_id,cal_name)
) COMMENT='Holds data for site extra fields (customized in site_extra.php).';

-- DROP TABLE IF EXISTS webcal_timezones;
CREATE TABLE IF NOT EXISTS webcal_timezones (
  tzid varchar(100) NOT NULL DEFAULT '' COMMENT 'Unique name of timezone, try to use Olsen naming conventions',
  dtstart varchar(25) DEFAULT NULL COMMENT 'Earliest date this timezone represents YYYYMMDDTHHMMSSZ format',
  dtend varchar(25) DEFAULT NULL,
  vtimezone text DEFAULT NULL COMMENT 'last date this timezone represents YYYYMMDDTHHMMSSZ format Complete VTIMEZONE text gleaned from imported ics files',
  PRIMARY KEY (tzid)
) ENGINE=MyISAM  COMMENT='Stores timezones of the world';

-- DROP TABLE IF EXISTS webcal_user;
CREATE TABLE IF NOT EXISTS webcal_user (
  cal_login varchar(25) NOT NULL COMMENT 'Unique user login',
  cal_passwd varchar(255) DEFAULT NULL COMMENT '(not used for http)',
  cal_enabled char(1) DEFAULT 'Y' COMMENT 'Has admin disabled account? (Y or N)',
  cal_is_admin char(1) DEFAULT 'N' COMMENT 'Is the user a WebCalendar administrator (Y or N)',
  cal_last_login date DEFAULT current_timestamp(),
  cal_address varchar(75) DEFAULT NULL,
  cal_birthday int(11) DEFAULT NULL,
  cal_email varchar(75) DEFAULT NULL,
  cal_firstname varchar(25) DEFAULT NULL,
  cal_lastname varchar(25) DEFAULT NULL,
  cal_telephone varchar(50) DEFAULT NULL,
  cal_title varchar(75) DEFAULT NULL,
  PRIMARY KEY (cal_login)
) COMMENT='Defines a WebCalendar user';

INSERT INTO webcal_user (cal_login, cal_passwd, cal_enabled, cal_is_admin, cal_last_login, cal_address, cal_birthday, cal_email, cal_firstname, cal_lastname, cal_telephone, cal_title) VALUES
('admin', '21232f297a57a5a743894a0e4a801fc3', 'Y', 'Y', NULL, NULL, NULL, NULL, 'Default', 'Administrator', NULL, NULL);

-- DROP TABLE IF EXISTS webcal_user_layers;
CREATE TABLE IF NOT EXISTS webcal_user_layers (
  cal_layerid int(11) NOT NULL DEFAULT 0 COMMENT 'Unique layer id',
  cal_login varchar(25) NOT NULL COMMENT 'login from <a href="#webcal_user">webcal_user</a> table of owner of this layer',
  cal_layeruser varchar(25) NOT NULL COMMENT 'login from <a href="#webcal_user">webcal_user</a> table of user that this layer represents',
  cal_color varchar(25) DEFAULT NULL COMMENT 'color to display this layer in',
  cal_dups char(1) DEFAULT 'N' COMMENT 'show duplicates (N or Y)',
  PRIMARY KEY (cal_layerid),
  UNIQUE KEY ndx_wul_clcl (cal_login,cal_layeruser)
) COMMENT='Define layers for a user.';

-- DROP TABLE IF EXISTS webcal_user_pref;
CREATE TABLE IF NOT EXISTS webcal_user_pref (
  cal_login varchar(25) NOT NULL COMMENT 'From <a href="#webcal_user">webcal_user</a> table',
  cal_setting varchar(25) NOT NULL,
  cal_value varchar(100) DEFAULT NULL,
  PRIMARY KEY (cal_login,cal_setting)
) COMMENT='Specify user preferences. Most preferences are set via pref.php. Values in this table are loaded after system settings found in <a href="#webcal_config">webcal_config</a> table.';

-- DROP TABLE IF EXISTS webcal_user_template;
CREATE TABLE IF NOT EXISTS webcal_user_template (
  cal_login varchar(25) NOT NULL COMMENT 'User from <a href="#webcal_user">webcal_user</a> table (or nonuser cal from <a href="#webcal_nonuser_cals">webcal_nonuser_cals</a> table), the DEFAULT for all users is stored with the username __system__',
  cal_type char(1) NOT NULL COMMENT 'Header, Stylesheet/script, Trailer',
  cal_template_text text DEFAULT NULL,
  PRIMARY KEY (cal_login,cal_type)
) COMMENT='Stores the custom header/stylesheet/trailer. If configured properly, each user (or nonuser cal) can have their own custom header/trailer.';

-- DROP TABLE IF EXISTS webcal_view;
CREATE TABLE IF NOT EXISTS webcal_view (
  cal_view_id int(11) NOT NULL COMMENT 'Unique view id',
  cal_owner varchar(25) NOT NULL COMMENT 'login name of owner of this view',
  cal_is_global char(1) NOT NULL DEFAULT 'N' COMMENT 'is this a global view (can it be accessed by other users) (Y or N)',
  cal_name varchar(50) NOT NULL COMMENT 'name of view',
  cal_view_type char(1) DEFAULT NULL COMMENT '"W" for week view, "D" for day view, "M" for month view',
  PRIMARY KEY (cal_view_id)
) COMMENT='A "view" allows a user to put the calendars of multiple users all on one page. A "view" is valid only for the owner (cal_owner) of the view. Users for the view are in <a href="#webcal_view_user">webcal_view_user</a> table.';

-- DROP TABLE IF EXISTS webcal_view_user;
CREATE TABLE IF NOT EXISTS webcal_view_user (
  cal_view_id int(11) NOT NULL COMMENT 'Unique view id',
  cal_login varchar(25) NOT NULL COMMENT 'a user from <a href="#webcal_user">webcal_user</a> table in the view',
  PRIMARY KEY (cal_view_id,cal_login)
) COMMENT='Specify users in a view. See <a href="#webcal_view">webcal_view</a> table.';
