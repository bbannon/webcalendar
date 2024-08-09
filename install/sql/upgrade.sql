/*upgrade_v0.9.14*/
ALTER TABLE webcal_entry MODIFY cal_time INT NOT NULL DEFAULT -1;
UPDATE webcal_entry SET cal_time = -1 WHERE cal_time IS NULL;
CREATE TABLE webcal_entry_repeats (
 cal_id INT NOT NULL,
 cal_days CHAR(7),
 cal_end INT,
 cal_frequency INT DEFAULT 1,
 cal_type VARCHAR(20),
 PRIMARY KEY (cal_id)
);
/*upgrade_v0.9.22*/
CREATE TABLE webcal_user_layers (
 cal_login VARCHAR(25) NOT NULL,
 cal_layeruser VARCHAR(25) NOT NULL,
 cal_color VARCHAR(25),
 cal_dups CHAR(1) NOT NULL DEFAULT 'N',
 cal_layerid INT NOT NULL,
 PRIMARY KEY (cal_login,cal_layeruser)
);
/*upgrade_v0.9.27*/
CREATE TABLE webcal_site_extras (
 cal_id INT NOT NULL,
 cal_name VARCHAR(25) NOT NULL,
 cal_type INT NOT NULL,
 cal_date INT,
 cal_remind INT,
 cal_data TEXT,
 PRIMARY KEY (cal_id,cal_name,cal_type)
);
/*upgrade_v0.9.35*/
CREATE TABLE webcal_config (
 cal_setting VARCHAR(50) NOT NULL,
 cal_value VARCHAR(50),
 PRIMARY KEY (cal_setting)
);
CREATE TABLE webcal_entry_log (
 cal_log_id INT NOT NULL,
 cal_date INT NOT NULL,
 cal_entry_id INT NOT NULL,
 cal_login VARCHAR(25) NOT NULL,
 cal_time INT,
 cal_type CHAR(1) NOT NULL,
 cal_text TEXT,
 PRIMARY KEY (cal_log_id)
);
CREATE TABLE webcal_group (
 cal_group_id INT NOT NULL,
 cal_last_update INT NOT NULL,
 cal_name VARCHAR(50) NOT NULL,
 cal_owner VARCHAR(25),
 PRIMARY KEY (cal_group_id)
);
CREATE TABLE webcal_group_user (
 cal_group_id INT NOT NULL,
 cal_login VARCHAR(25) NOT NULL,
 PRIMARY KEY (cal_group_id,cal_login)
);
CREATE TABLE webcal_view (
 cal_view_id INT NOT NULL,
 cal_name VARCHAR(50) NOT NULL,
 cal_owner VARCHAR(25) NOT NULL,
 cal_view_type CHAR(1),
 PRIMARY KEY (cal_view_id)
);
CREATE TABLE webcal_view_user (
 cal_view_id INT NOT NULL,
 cal_login VARCHAR(25) NOT NULL,
 PRIMARY KEY (cal_view_id,cal_login)
);
/*upgrade_v0.9.37*/
ALTER TABLE webcal_entry_log ADD cal_user_cal VARCHAR(25);
CREATE TABLE webcal_entry_repeats_not (
 cal_id INT NOT NULL,
 cal_date INT NOT NULL,
 PRIMARY KEY (cal_id,cal_date)
);
/*upgrade_v0.9.38*/
ALTER TABLE webcal_entry_user ADD cal_category INT;
CREATE TABLE webcal_categories (
 cat_id INT NOT NULL,
 cat_name VARCHAR(80) NOT NULL,
 cat_owner VARCHAR(25),
 PRIMARY KEY (cat_id)
);
/*upgrade_v0.9.40*/
DELETE FROM webcal_config WHERE cal_setting LIKE 'DATE_FORMAT%';
DELETE FROM webcal_user_pref WHERE cal_setting LIKE 'DATE_FORMAT%';
ALTER TABLE webcal_entry ADD cal_ext_for_id INT;
CREATE TABLE webcal_asst (
 cal_boss VARCHAR(25) NOT NULL,
 cal_assistant VARCHAR(25) NOT NULL,
 PRIMARY KEY (cal_boss,cal_assistant)
);
CREATE TABLE webcal_entry_ext_user (
 cal_id INT NOT NULL,
 cal_fullname VARCHAR(50) NOT NULL,
 cal_email VARCHAR(75),
 PRIMARY KEY (cal_id,cal_fullname)
);
/*upgrade_v0.9.41*/
CREATE TABLE webcal_nonuser_cals (
 cal_login VARCHAR(25) NOT NULL,
 cal_admin VARCHAR(25) NOT NULL,
 cal_firstname VARCHAR(25),
 cal_lastname VARCHAR(25),
 PRIMARY KEY (cal_login)
);
/*upgrade_v0.9.42*/
CREATE TABLE webcal_report (
 cal_report_id INT NOT NULL,
 cal_allow_nav CHAR(1) NOT NULL DEFAULT 'Y',
 cal_cat_id INT,
 cal_include_empty CHAR(1) NOT NULL DEFAULT 'N',
 cal_include_header CHAR(1) NOT NULL DEFAULT 'Y',
 cal_is_global CHAR(1) NOT NULL DEFAULT 'N',
 cal_login VARCHAR(25) NOT NULL,
 cal_report_name VARCHAR(50) NOT NULL,
 cal_report_type VARCHAR(20) NOT NULL,
 cal_show_in_trailer CHAR(1) NOT NULL DEFAULT 'N',
 cal_time_range INT NOT NULL,
 cal_update_date INT NOT NULL,
 cal_user VARCHAR(25),
 PRIMARY KEY (cal_report_id)
);
CREATE TABLE webcal_report_template (
 cal_report_id INT NOT NULL,
 cal_template_type CHAR(1) NOT NULL,
 cal_template_text TEXT,
 PRIMARY KEY (cal_report_id,cal_template_type)
);
/*upgrade_v0.9.43*/
ALTER TABLE webcal_user MODIFY cal_passwd VARCHAR(32);
DROP TABLE IF EXISTS webcal_import_data;
CREATE TABLE webcal_import (
 cal_import_id INT NOT NULL,
 cal_date INT NOT NULL,
 cal_login VARCHAR(25),
 cal_name VARCHAR(50),
 cal_type VARCHAR(10) NOT NULL,
 PRIMARY KEY (cal_import_id)
);
CREATE TABLE webcal_import_data (
 cal_id INT NOT NULL,
 cal_login VARCHAR(25) NOT NULL,
 cal_external_id VARCHAR(200),
 cal_import_id INT NOT NULL,
 cal_import_type VARCHAR(15) NOT NULL,
 PRIMARY KEY (cal_id,cal_login)
);
/*upgrade_v1.0RC3*/
ALTER TABLE webcal_view ADD cal_is_global CHAR(1) NOT NULL DEFAULT 'N';
UPDATE webcal_config SET cal_value = 'week.php' WHERE cal_setting = 'STARTVIEW';
UPDATE webcal_user_pref SET cal_value = 'day.php' WHERE cal_value = 'day' AND cal_setting = 'STARTVIEW';
UPDATE webcal_user_pref SET cal_value = 'month.php' WHERE cal_value = 'month' AND cal_setting = 'STARTVIEW';
UPDATE webcal_user_pref SET cal_value = 'week.php' WHERE cal_value = 'week' AND cal_setting = 'STARTVIEW';
UPDATE webcal_user_pref SET cal_value = 'year.php' WHERE cal_value = 'year' AND cal_setting = 'STARTVIEW';
UPDATE webcal_view SET cal_is_global = 'N';
/*upgrade_v1.1.0-CVS*/
CREATE TABLE webcal_access_function (
 cal_login VARCHAR(25) NOT NULL,
 cal_permissions VARCHAR(64) NOT NULL,
 PRIMARY KEY (cal_login)
);
ALTER TABLE webcal_nonuser_cals ADD cal_is_public CHAR(1) NOT NULL DEFAULT 'N';
/*upgrade_v1.1.0a-CVS*/
CREATE TABLE webcal_user_template (
 cal_login VARCHAR(25) NOT NULL,
 cal_type CHAR(1) NOT NULL,
 cal_template_text TEXT,
 PRIMARY KEY (cal_login,cal_type)
);
ALTER TABLE webcal_entry
 ADD cal_completed int(11) DEFAULT NULL,
 ADD cal_due_date int(11) DEFAULT NULL,
 ADD cal_due_time int(11) DEFAULT NULL,
 ADD cal_location varchar(100) DEFAULT NULL,
 ADD cal_url varchar(100) DEFAULT NULL;

ALTER TABLE webcal_entry_repeats
 ADD cal_endtime int(11) DEFAULT NULL,
 ADD cal_count int(11) DEFAULT NULL,
 ADD cal_byyearday varchar(50) DEFAULT NULL,
 ADD cal_byweekno varchar(50) DEFAULT NULL,
 ADD cal_bysetpos varchar(50) DEFAULT NULL,
 ADD cal_bymonthday varchar(100) DEFAULT NULL,
 ADD cal_bymonth varchar(50) DEFAULT NULL,
 ADD cal_byday varchar(100) DEFAULT NULL,
 ADD cal_wkst char(2) DEFAULT 'MO';

ALTER TABLE webcal_entry_repeats_not ADD cal_exdate int(1) NOT NULL DEFAULT '1';
ALTER TABLE webcal_entry_user ADD cal_percent int(11) NOT NULL DEFAULT '0';
ALTER TABLE webcal_site_extras DROP PRIMARY KEY;
/*upgrade_v1.1.0b-CVS*/
CREATE TABLE webcal_entry_categories (
 cal_id int(11) NOT NULL DEFAULT '0',
 cat_id int(11) NOT NULL DEFAULT '0',
 cat_order int(11) NOT NULL DEFAULT '0',
 cat_owner varchar(25) DEFAULT NULL
);
/*upgrade_v1.1.0c-CVS*/
CREATE TABLE webcal_blob (
 cal_blob_id INT NOT NULL,
 cal_id INT NULL,
 cal_login VARCHAR(25) NULL,
 cal_mime_type VARCHAR(50) NULL,
 cal_name VARCHAR(30) NULL,
 cal_size INT NULL,
 cal_type CHAR(1) NOT NULL,
 cal_description VARCHAR(128) NULL,
 cal_mod_date INT NOT NULL,
 cal_mod_time INT NOT NULL,
 cal_blob LONGBLOB,
 PRIMARY KEY (cal_blob_id)
);
/*upgrade_v1.1.0d-CVS*/
DROP TABLE IF EXISTS webcal_access_user;
CREATE TABLE webcal_access_user (
 cal_login VARCHAR(25) NOT NULL,
 cal_other_user VARCHAR(25) NOT NULL,
 cal_can_approve INT NOT NULL DEFAULT '0',
 cal_can_edit INT NOT NULL DEFAULT '0',
 cal_can_view INT NOT NULL DEFAULT '0',
 cal_can_email CHAR(1) DEFAULT 'Y',
 cal_can_invite CHAR(1) DEFAULT 'Y',
 cal_see_time_only CHAR(1) DEFAULT 'N',
 PRIMARY KEY (cal_login, cal_other_user)
);
/*upgrade_v1.1.0e-CVS*/
CREATE TABLE webcal_reminders (
 cal_id INT NOT NULL DEFAULT '0',
 cal_action VARCHAR(12) NOT NULL DEFAULT 'EMAIL',
 cal_before CHAR(1) NOT NULL DEFAULT 'Y',
 cal_date INT NOT NULL DEFAULT '0',
 cal_duration INT NOT NULL DEFAULT '0',
 cal_last_sent INT NOT NULL DEFAULT '0',
 cal_offset INT NOT NULL DEFAULT '0',
 cal_related CHAR(1) NOT NULL DEFAULT 'S',
 cal_repeats INT NOT NULL DEFAULT '0',
 cal_times_sent INT NOT NULL DEFAULT '0',
 PRIMARY KEY (cal_id)
);
/*upgrade_v1.1.1*/
ALTER TABLE webcal_nonuser_cals ADD cal_url VARCHAR(255) DEFAULT NULL;
/*upgrade_v1.1.2*/
ALTER TABLE webcal_categories ADD cat_color VARCHAR(8) DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_address VARCHAR(75) DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_birthday INT NULL;
ALTER TABLE webcal_user ADD cal_enabled CHAR(1) DEFAULT 'Y';
ALTER TABLE webcal_user ADD cal_last_login INT NULL;
ALTER TABLE webcal_user ADD cal_telephone VARCHAR(50) DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_title VARCHAR(75) DEFAULT NULL;
/*upgrade_v1.1.3*/
CREATE TABLE webcal_timezones (
 tzid varchar(100) NOT NULL default '',
 dtstart varchar(25) default NULL,
 dtend varchar(25) default NULL,
 vtimezone text,
 PRIMARY KEY (tzid)
);
/*upgrade_v1.2.8*/
/*upgrade_v1.9.0*/
ALTER TABLE webcal_import ADD cal_check_date INT NULL;
ALTER TABLE webcal_import ADD cal_md5 VARCHAR(32) NULL DEFAULT NULL;
CREATE INDEX webcal_import_data_type ON webcal_import_data(cal_import_type);
CREATE INDEX webcal_import_data_ext_id ON webcal_import_data(cal_external_id);
ALTER TABLE webcal_user MODIFY cal_passwd VARCHAR(255);
/*upgrade_v1.9.5*/
update webcal_entry_categories SET cat_owner = '' WHERE cat_owner IS NULL;
ALTER TABLE webcal_entry_categories DROP PRIMARY KEY;
ALTER TABLE webcal_entry_categories ADD PRIMARY KEY (cal_id, cat_id, cat_order, cat_owner);
/*upgrade_v1.9.6*/
/*upgrade_v1.9.10*/
ALTER TABLE webcal_categories ADD cat_status CHAR DEFAULT 'A';
ALTER TABLE webcal_categories ADD cat_icon_mime VARCHAR(32) DEFAULT NULL;
ALTER TABLE webcal_categories ADD cat_icon_blob LONGBLOB DEFAULT NULL;
ALTER TABLE webcal_categories MODIFY cat_owner VARCHAR(25) DEFAULT '' NOT NULL;
/*upgrade_v1.9.11*/
ALTER TABLE webcal_nonuser_cals MODIFY COLUMN cal_url varchar(255);
ALTER TABLE webcal_entry MODIFY COLUMN cal_url varchar(255);
/*upgrade_1.9.13*/
ALTER TABLE webcal_user
  COMMENT = 'Defines a WebCalendar user',
  MODIFY cal_last_login date DEFAULT CURRENT_TIMESTAMP,
  MODIFY cal_is_admin CHAR(1) DEFAULT 'N' COMMENT 'Is the user a WebCalendar administrator (Y or N)' FIRST,
  MODIFY cal_enabled CHAR(1) DEFAULT 'Y' COMMENT 'Has admin disabled account? (Y or N)' FIRST,
  MODIFY cal_passwd VARCHAR(255) COMMENT '(not used for http)' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'Unique user login' FIRST;

ALTER TABLE webcal_entry
  COMMENT = 'Defines a calendar event. Each event in the system has one entry here, unless the event crosses midnight. In that case a secondary event will be created with cal_ext_for_id set to the cal_id of the original entry. The following tables contain additional information about each event:<ul><li><a href="#webcal_entry_user">webcal_entry_user</a> table - lists participants in the event and specifies the status (accepted, rejected) and category of each participant.</li><li><a href="#webcal_entry_repeats">webcal_entry_repeats</a> table - contains information if the event repeats.</li><li><a href="#webcal_entry_repeats_not">webcal_entry_repeats_not</a> table - specifies which dates the repeating event does not repeat (because they were deleted or modified for just that date by the user)</li><li><a href="#webcal_entry_log">webcal_entry_log</a> table - provides a history of changes to this event.</li><li><a href="#webcal_site_extras">webcal_site_extras</a> table - stores event data as defined in site_extras.php (such as reminders and other custom event fields).</li></ul>',
  MODIFY cal_url varchar(255) DEFAULT NULL COMMENT 'of event',
  MODIFY cal_type CHAR(1) DEFAULT 'E' COMMENT 'E = Event, M = Repeating event, T = Task' FIRST,
  MODIFY cal_priority INT DEFAULT 5 COMMENT '1=High, 5=Med, 9=Low' FIRST,
  MODIFY cal_name VARCHAR(80) NOT NULL COMMENT 'Brief description of event' FIRST,
  MODIFY cal_location varchar(100) DEFAULT NULL COMMENT 'of event' FIRST,
  MODIFY cal_duration INT NOT NULL COMMENT 'of event in minutes' FIRST,
  MODIFY cal_completed INT DEFAULT NULL COMMENT 'Date task completed' FIRST,
  MODIFY cal_access CHAR(1) DEFAULT 'P' COMMENT 'Public, pRrivate (others cannot see the event), Confidential (others can see time allocated but not what it is)' FIRST,
  MODIFY cal_date INT NOT NULL COMMENT 'in YYYYMMDD format',
  MODIFY cal_time INT COMMENT 'in HHMMSS format',
  MODIFY cal_due_date INT DEFAULT NULL COMMENT 'Task',
  MODIFY cal_due_time INT DEFAULT NULL COMMENT 'Task',
  MODIFY cal_mod_date INT COMMENT 'Event was last modified (in YYYYMMDD format)',
  MODIFY cal_mod_time INT COMMENT 'Event was last modified (in HHMMSS format)',
  MODIFY cal_create_by VARCHAR(25) NOT NULL COMMENT 'Creator of the event' FIRST,
  MODIFY cal_group_id INT NULL COMMENT 'Parent event ID if this event is overriding an occurrence of a repeating event' FIRST,
  MODIFY cal_ext_for_id INT NULL COMMENT 'Used when an event goes past midnight into the next day, in which case an additional entry in this table will use this field to indicate the original event cal_id' FIRST,
  MODIFY cal_id INT NOT NULL COMMENT 'Unique integer ID for event' FIRST,
  MODIFY cal_description TEXT COMMENT 'Full description of event';

ALTER TABLE webcal_entry_categories
  COMMENT = 'Contains category foreign keys to enable multiple categories for each event or task,',
  MODIFY cat_owner varchar(25) DEFAULT '' NOT NULL COMMENT 'Record owner. Global categories will be empty string.',
  MODIFY cat_order INT DEFAULT 0 NOT NULL COMMENT 'Order that user requests their categories appear. Globals are always last.' FIRST,
  MODIFY cat_id INT DEFAULT 0 NOT NULL COMMENT 'Category ID. Not unique here.' FIRST,
  MODIFY cal_id INT DEFAULT 0 NOT NULL COMMENT 'Event ID. Not unique here.' FIRST;

ALTER TABLE webcal_entry_repeats
  COMMENT = 'Defines repeating info about an event. The event is defined in <a href="#webcal_entry">webcal_entry</a> table.',
  MODIFY cal_byday varchar(100) DEFAULT NULL COMMENT 'the following columns are values as specified in RFC2445' FIRST,
  MODIFY cal_days CHAR(7) COMMENT 'NO LONGER USED. We''ll leave it in for now' FIRST,
  MODIFY cal_type VARCHAR(20) COMMENT 'of repeating:<ul><li>daily - repeats daily</li><li>monthlyByDate - repeats on same day of the month</li><li>monthlyBySetPos - repeats based on position within other ByXXX values</li><li>monthlyByDay - repeats on specified weekday (2nd Monday, for example)</li><li>weekly - repeats every week</li><li>yearly - repeats on same date every year</li></ul>' FIRST,
  MODIFY cal_endtime INT DEFAULT NULL COMMENT 'for repeating event (in HHMMSS format)' FIRST,
  MODIFY cal_end INT COMMENT 'date for repeating event (in YYYYMMDD format)' FIRST,
  MODIFY cal_frequency INT DEFAULT 1 COMMENT 'of repeat: 1 = every, 2 = every other, 3 = every 3rd, etc.' FIRST,
  MODIFY cal_wkst char(2) DEFAULT 'MO' AFTER cal_count,
  MODIFY cal_id INT DEFAULT 0 NOT NULL COMMENT 'Event ID' FIRST;

ALTER TABLE webcal_entry_repeats_not
  COMMENT = 'Specifies which dates in a repeating event have either been deleted, included, or replaced with a replacement event for that day When replaced, the cal_group_id (I know... not the best name, but it was not being used) column will be set to the original event. That way the user can delete the original event and (at the same time) delete any exception events.',
  MODIFY cal_date INT NOT NULL COMMENT 'cal_date: date event should not repeat (in YYYYMMDD format)' FIRST,
  MODIFY cal_id INT NOT NULL COMMENT 'Event ID of repeating event' FIRST,
  MODIFY cal_exdate int(1) NOT NULL DEFAULT 1 COMMENT 'indicates whether this record is an exclusion (1) or inclusion (0)';

ALTER TABLE webcal_entry_user
  COMMENT = 'Associates one or more users with an event by the cal_id. The event can be found in <a href="#webcal_entry">webcal_entry</a> table.',
  MODIFY cal_status CHAR(1) DEFAULT 'A' COMMENT 'status of event for this user: <ul><li>A=Accepted</li><li>C=Completed</li><li>D=Deleted</li><li>P=In-Progress</li><li>R=Rejected/Declined</li><li>W=Waiting</li></ul>',
  MODIFY cal_percent INT DEFAULT 0 NOT NULL COMMENT 'Task percentage of completion for this user''s task' FIRST,
  MODIFY cal_category INT DEFAULT NULL COMMENT 'category of the event for this user' FIRST,
  MODIFY cal_id INT DEFAULT 0 NOT NULL COMMENT 'Event ID' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'participant in the event' FIRST;

ALTER TABLE webcal_entry_ext_user
  COMMENT = 'Associates one or more external users (people who do not have a WebCalendar login) with an event by the event id. An event must still have at least one WebCalendar user associated with it. This table is not used unless external users are enabled* in system settings. The event can be found in <a href="#webcal_entry">webcal_entry</a> table.',
  MODIFY cal_email VARCHAR(75) NULL FIRST,
  MODIFY cal_id INT DEFAULT 0 NOT NULL COMMENT 'Event ID' FIRST;

ALTER TABLE webcal_user_pref
  COMMENT = 'Specify user preferences. Most preferences are set via pref.php. Values in this table are loaded after system settings found in <a href="#webcal_config">webcal_config</a> table.',
  MODIFY cal_setting VARCHAR(25) NOT NULL COMMENT 'setting name' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'user login' FIRST,
  MODIFY cal_value VARCHAR(100) NULL COMMENT 'setting value';

ALTER TABLE webcal_user_layers
  COMMENT = 'Define layers for a user.',
  MODIFY cal_dups CHAR(1) DEFAULT 'N' COMMENT 'show duplicates (N or Y)',
  MODIFY cal_color VARCHAR(25) COMMENT 'color to display this layer in' FIRST,
  MODIFY cal_layeruser VARCHAR(25) NOT NULL COMMENT 'login name of user that this layer represents' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'login of owner of this layer' FIRST,
  MODIFY cal_layerid INT DEFAULT 0 NOT NULL COMMENT 'unique layer id' FIRST;

ALTER TABLE webcal_site_extras
  COMMENT = 'Holds data for site extra fields (customized in site_extra.php).',
  MODIFY cal_type INT NOT NULL COMMENT 'EXTRA_URL, EXTRA_DATE, etc.' FIRST,
  MODIFY cal_remind INT DEFAULT 0 COMMENT 'How many minutes before event should a reminder be sent' FIRST,
  MODIFY cal_name VARCHAR(25) NOT NULL COMMENT 'Brief name of this type (first field in $site_extra array)' FIRST,
  MODIFY cal_date INT DEFAULT 0 COMMENT 'Only used for EXTRA_DATE type fields (in YYYYMMDD format)' FIRST,
  MODIFY cal_id INT DEFAULT 0 NOT NULL COMMENT 'Event ID' FIRST,
  MODIFY cal_data TEXT COMMENT 'Store text data';

ALTER TABLE webcal_reminders
  COMMENT = 'Stores information about reminders',
  MODIFY cal_times_sent INT NOT NULL default '0' COMMENT 'number of times this reminder has been sent',
  MODIFY cal_repeats INT NOT NULL default '0' COMMENT 'number of times to repeat in addition to original occurrence' FIRST,
  MODIFY cal_related CHAR(1) NOT NULL default 'S' COMMENT 'Start, End. Specifies which edge of entry this reminder applies to' FIRST,
  MODIFY cal_offset INT NOT NULL default '0' COMMENT 'in minutes from the selected edge' FIRST,
  MODIFY cal_last_sent INT NOT NULL default '0' COMMENT 'timestamp of last sent reminder' FIRST,
  MODIFY cal_duration INT NOT NULL default '0' COMMENT 'time in ISO 8601 format that specifies time between repeated reminders' FIRST,
  MODIFY cal_date INT NOT NULL default '0' COMMENT 'timestamp that specifies send datetime. Use this or cal_offset, but not both' FIRST,
  MODIFY cal_before CHAR(1) NOT NULL default 'Y' COMMENT 'specifies whether reminder is sent before or after selected edge' FIRST,
  MODIFY cal_action VARCHAR(12) NOT NULL default 'EMAIL' COMMENT 'action as imported, may be used in the future' FIRST,
  MODIFY cal_id INT NOT NULL default '0' COMMENT 'Event ID.';

ALTER TABLE webcal_group
  COMMENT = 'Define a group. Group members can be found in <a href="#webcal_group_user">webcal_group_user</a> table.',
  MODIFY cal_name VARCHAR(50) NOT NULL COMMENT 'of the group' FIRST,
  MODIFY cal_owner VARCHAR(25) NULL COMMENT 'Created this group' FIRST,
  MODIFY cal_group_id INT NOT NULL COMMENT 'Unique group id' FIRST,
  MODIFY cal_last_update INT NOT NULL COMMENT 'in YYYYMMDD format';

ALTER TABLE webcal_group_user
  COMMENT = 'Specify users in a group. The group is defined in <a href="#webcal_group">webcal_group</a> table.',
  MODIFY cal_group_id INT NOT NULL COMMENT 'Unique group id' FIRST;

ALTER TABLE webcal_view
  COMMENT = 'A "view" allows a user to put the calendars of multiple users all on one page. A "view" is valid only for the owner (cal_owner) of the view. Users for the view are in <a href="#webcal_view_user">webcal_view_user</a> table.',
  MODIFY cal_view_type CHAR(1) COMMENT '"W" for week view, "D" for day view, "M" for month view',
  MODIFY cal_name VARCHAR(50) NOT NULL COMMENT 'name of view' FIRST,
  MODIFY cal_is_global CHAR(1) DEFAULT 'N' NOT NULL COMMENT 'is this a global view (can it be accessed by other users) (Y or N)' FIRST,
  MODIFY cal_owner VARCHAR(25) NOT NULL COMMENT 'login name of owner of this view' FIRST,
  MODIFY cal_view_id INT NOT NULL COMMENT 'unique view id' FIRST;

ALTER TABLE webcal_view_user
  COMMENT = 'Specify users in a view. See <a href="#webcal_view">webcal_view</a> table.',
  MODIFY cal_view_id INT NOT NULL COMMENT 'Unique view id' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'a user in the view';

ALTER TABLE webcal_config
  ENGINE MyISAM COMMENT 'System settings (set by the admin interface in admin.php)';

ALTER TABLE webcal_entry_log
  COMMENT = 'Activity log for an event.',
  MODIFY cal_type CHAR(1) NOT NULL COMMENT 'log types:<ul><li>C: Created</li><li>A: Approved/Confirmed by user</li><li>R: Rejected by user</li><li>U: Updated by user</li><li>M: Mail Notification sent</li><li>E: Reminder sent</li></ul>' FIRST,
  MODIFY cal_time INT NULL COMMENT 'in HHMMSS format' FIRST,
  MODIFY cal_date INT NOT NULL COMMENT 'in YYYYMMDD format' FIRST,
  MODIFY cal_entry_id INT NOT NULL COMMENT 'Event ID' FIRST,
  MODIFY cal_user_cal VARCHAR(25) NULL COMMENT 'user of calendar affected' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'user who performed this action' FIRST,
  MODIFY cal_log_id INT NOT NULL COMMENT 'unique ID of this log entry' FIRST,
  MODIFY cal_text TEXT COMMENT 'optional';

ALTER TABLE webcal_categories
  COMMENT = 'Defines user categories. Categories can be specific to a user or global. When a category is global, the cat_owner field will be NULL. (Only an admin user can create a global category.)',
  MODIFY cat_status CHAR DEFAULT 'A' COMMENT 'of the category (A = Active, I = Inactive, D = Deleted)' FIRST,
  MODIFY cat_name VARCHAR(80) NOT NULL COMMENT 'of category' FIRST,
  MODIFY cat_icon_mime VARCHAR(32) DEFAULT NULL COMMENT 'Category icon mime type (e.g. "image/png")' FIRST,
  MODIFY cat_color VARCHAR(8) NULL COMMENT 'RGB color for category' FIRST,
  MODIFY cat_owner VARCHAR(25) DEFAULT '' NOT NULL COMMENT 'User login of category owner. If this is empty, then it is a global category' FIRST,
  MODIFY cat_id INT NOT NULL COMMENT 'Unique category id' FIRST,
  MODIFY cat_icon_blob LONGBLOB DEFAULT NULL COMMENT 'category icon image blob';

ALTER TABLE webcal_asst
  COMMENT = 'Define assistant/boss relationship.',
  MODIFY cal_boss VARCHAR(25) NOT NULL COMMENT 'login of boss' FIRST,
  MODIFY cal_assistant VARCHAR(25) NOT NULL COMMENT 'login of assistant';

ALTER TABLE webcal_nonuser_cals
  COMMENT = 'Defines non-user calendars.',
  MODIFY cal_is_public CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'can this nonuser calendar be a public calendar (no login required)' FIRST,
  MODIFY cal_lastname VARCHAR(25) NULL COMMENT 'calendar' FIRST,
  MODIFY cal_firstname VARCHAR(25) NULL COMMENT 'calendar' FIRST,
  MODIFY cal_admin VARCHAR(25) NOT NULL COMMENT 'Who is the calendar administrator' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'Unique ID for the calendar' FIRST,
  MODIFY cal_url VARCHAR(255) DEFAULT NULL COMMENT 'url of the remote calendar';

ALTER TABLE webcal_import
  COMMENT = 'Used to track import data (one row per import)',
  MODIFY cal_type VARCHAR(10) NOT NULL COMMENT 'of import (ical, vcal, palm, outlookcsv)' FIRST,
  MODIFY cal_name VARCHAR(50) COMMENT 'of import (optional)' FIRST,
  MODIFY cal_md5 VARCHAR(32) DEFAULT NULL COMMENT 'md5 of last import used to see if a new import changes anything' FIRST,
  MODIFY cal_date INT NOT NULL COMMENT 'of import (YYYYMMDD format)' FIRST,
  MODIFY cal_check_date INT NULL COMMENT 'date of last check to see if remote calendar updated (YYYYMMDD format)' FIRST,
  MODIFY cal_login VARCHAR(25) COMMENT 'User who performed the import' FIRST,
  MODIFY cal_import_id INT NOT NULL COMMENT 'Unique ID for import' FIRST;

ALTER TABLE webcal_import_data
  COMMENT = 'Used to track import data (one row per event)',
  MODIFY cal_import_type VARCHAR(15) NOT NULL COMMENT 'type of import: palm, vcal, ical or outlookcsv' FIRST,
  MODIFY cal_import_id INT NOT NULL COMMENT 'from webcal_import table' FIRST,
  MODIFY cal_external_id VARCHAR(200) NULL COMMENT 'Used in external calendar system (for example, UID in iCal)' FIRST,
  MODIFY cal_id INT NOT NULL COMMENT 'Event ID in WebCalendar' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'user login' FIRST;

ALTER TABLE webcal_report
  COMMENT = 'Defines a custom report created by a user.',
  MODIFY cal_update_date INT NOT NULL COMMENT 'date created or last updated (in YYYYMMDD format)' FIRST,
  MODIFY cal_time_range INT NOT NULL COMMENT 'for report:<ul><li>0 = tomorrow</li><li>1 = today</li><li>2 = yesterday</li><li>3 = day before yesterday</li><li>10 = next week</li><li>11 = current week</li><li>12 = last week</li><li>13 = week before last</li><li>20 = next week and week after</li><li>21 = current week and next week</li><li>22 = last week and this week</li><li>23 = last two weeks</li><li>30 = next month</li><li>31 = current month</li><li>32 = last month</li><li>33 = month before last</li><li>40 = next year</li><li>41 = current year</li><li>42 = last year</li><li>43 = year before last</li></ul>' FIRST,
  MODIFY cal_show_in_trailer CHAR(1) DEFAULT 'N' COMMENT 'Include a link for this report in the "Go to" section of the navigation in the page trailer (Y or N)' FIRST,
  MODIFY cal_report_type VARCHAR(20) NOT NULL COMMENT 'Format of report (html, plain or csv)' FIRST,
  MODIFY cal_report_name VARCHAR(50) NOT NULL FIRST,
  MODIFY cal_is_global CHAR(1) DEFAULT 'N' NOT NULL COMMENT 'Is this a global report (can it be accessed by other users) (Y or N)' FIRST,
  MODIFY cal_include_header CHAR(1) DEFAULT 'Y' NOT NULL COMMENT 'If cal_report_type is HTML, should the DEFAULT HTML header and trailer be included? (Y or N)' FIRST,
  MODIFY cal_include_empty CHAR(1) DEFAULT 'N' COMMENT 'dates in report (Y or N)' FIRST,
  MODIFY cal_cat_id INT NULL COMMENT 'Category to filter on (optional)' FIRST,
  MODIFY cal_allow_nav CHAR(1) DEFAULT 'Y' COMMENT 'Allow user to navigate to different dates with next/previous (Y or N)' FIRST,
  MODIFY cal_user VARCHAR(25) COMMENT 'Calendar to display (NULL indicates current user)' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'Creator of report' FIRST,
  MODIFY cal_report_id INT NOT NULL COMMENT 'Unique ID of this report' FIRST;

ALTER TABLE webcal_report_template
  COMMENT = 'Defines one of the templates used for a report. Each report has three templates:<ol><li>Page template - Defines the entire page (except for header and footer). The following variables can be defined:<ul><li>${days}<sup>*</sup> - the HTML of all dates (generated from the Date template)</li></ul></li><li>Date template - Defines events for one day. If the report is for a week or month, then the results of each day will be concatenated and used as the ${days} variable in the Page template. The following variables can be defined:<ul><li>${events}<sup>*</sup> - the HTML of all events for the data (generated from the Event template)</li><li>${date} - the date</li><li>${fulldate} - date (includes weekday)</li></ul></li><li>Event template - Defines a single event. The following variables can be defined:<ul><li>${name}<sup>*</sup> - Brief Description of event</li><li>${description} - Full Description of event</li><li>${date} - Date of event</li><li>${fulldate} - Date of event (includes weekday)</li><li>${time} - Time of event (4:00pm - 4:30pm)</li><li>${starttime} - Start time of event</li><li>${endtime} - End time of event</li><li>${duration} - Duration of event (in minutes)</li><li>${priority} - Priority of event</li><li>${href} - URL to view event details</li></ul></li></ol><sup>*</sup> denotes a required template variable',
  MODIFY cal_template_type CHAR(1) NOT NULL COMMENT '<ul><li>Page template represents entire document</li><li>Date template represents a single day of events</li><li>Event template represents a single event</li></ul>' FIRST,
  MODIFY cal_report_id INT NOT NULL COMMENT 'Report ID (in webcal_report table)' FIRST,
  MODIFY cal_template_text TEXT COMMENT 'text of template';

ALTER TABLE webcal_access_user
  COMMENT = 'Specifies which users can access another user''s calendar.',
  MODIFY cal_can_invite CHAR(1) DEFAULT 'Y' COMMENT 'can current user see other user in Participant lists?' FIRST,
  MODIFY cal_can_email CHAR(1) DEFAULT 'Y' COMMENT 'can current user send emails to other user?' FIRST,
  MODIFY cal_see_time_only CHAR(1) DEFAULT 'N' COMMENT 'can current user can only see time of other user?' FIRST,
  MODIFY cal_can_view INT NOT NULL DEFAULT '0' COMMENT 'can current user view events on the other user''s calendar?' FIRST,
  MODIFY cal_can_edit INT NOT NULL DEFAULT '0' COMMENT 'can current user edit events on the other user''s calendar?' FIRST,
  MODIFY cal_can_approve INT NOT NULL DEFAULT '0' COMMENT 'can current user approve events on the other user''s calendar?' FIRST,
  MODIFY cal_other_user VARCHAR(25) NOT NULL COMMENT 'the login of the other user whose calendar the current user wants to access' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'the current user who is attempting to look at another user''s calendar' FIRST;

ALTER TABLE webcal_access_function
  COMMENT = 'Specifies what WebCalendar functions a user can access. Each function has a corresponding numeric value (specified in the file includes/access.php). For example, view event is 0, so the very first character in the cal_permissions column is either a "Y" if this user can view events or an "N" if they cannot.',
  MODIFY cal_login VARCHAR(25) NOT NULL FIRST,
  MODIFY cal_permissions VARCHAR(64) NOT NULL COMMENT 'A string of Y or N for the various functions';

ALTER TABLE webcal_user_template
  COMMENT = 'Stores the custom header/stylesheet/trailer. If configured properly, each user (or nonuser cal) can have their own custom header/trailer.',
  MODIFY cal_type CHAR(1) NOT NULL COMMENT 'Header, Stylesheet/script, Trailer' FIRST,
  MODIFY cal_login VARCHAR(25) NOT NULL COMMENT 'User login (or nonuser cal name), the DEFAULT for all users is stored with the username __system__' FIRST,
  MODIFY cal_template_text TEXT;

ALTER TABLE webcal_blob
  COMMENT = 'Stores event attachments and comments.',
  MODIFY cal_mod_time INT NOT NULL COMMENT 'in HHMMSS format' FIRST,
  MODIFY cal_mod_date INT NOT NULL COMMENT 'in YYYYMMDD format' FIRST,
  MODIFY cal_type CHAR(1) NOT NULL COMMENT 'of object: C=Comment, A=Attachment' FIRST,
  MODIFY cal_size INT NULL COMMENT 'of object (not used for comment)' FIRST,
  MODIFY cal_name VARCHAR(30) NULL COMMENT 'Filename of object (not used for comments)' FIRST,
  MODIFY cal_mime_type VARCHAR(50) NULL COMMENT 'of object (as specified by browser during upload) (not used for comment)' FIRST,
  MODIFY cal_description VARCHAR(128) NULL COMMENT 'of what the object is (subject for comment)' FIRST,
  MODIFY cal_id INT NULL COMMENT 'Event ID (if applicable)' FIRST,
  MODIFY cal_login VARCHAR(25) NULL COMMENT 'of creator' FIRST,
  MODIFY cal_blob_id INT NOT NULL COMMENT 'Unique identifier for this object' FIRST,
  MODIFY cal_blob LONGBLOB COMMENT 'binary data for object',
  DROP INDEX IF EXISTS ndx_wb_cl, ndx_wb_ci,
  ADD KEY ndx_wb_cl (cal_login),
  ADD KEY ndx_wb_ci (cal_id);

ALTER TABLE webcal_timezones
  ENGINE MyISAM COMMENT 'Stores timezones of the world',
  MODIFY dtstart varchar(25) default NULL COMMENT 'Earliest date this timezone represents YYYYMMDDTHHMMSSZ format' FIRST,
  MODIFY tzid varchar(100) NOT NULL default '' COMMENT 'Unique name of timezone, try to use Olsen naming conventions' FIRST,
  MODIFY dtend varchar(25) default NULL,
  MODIFY vtimezone text COMMENT 'last date this timezone represents YYYYMMDDTHHMMSSZ format Complete VTIMEZONE text gleaned from imported ics files';

-- DROP TABLE IF EXISTS webcal_translations;
CREATE TABLE IF NOT EXISTS webcal_translations (
  phrase varchar(300) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL COMMENT 'The translate / tooltip (phrases) from the code. ("latin1" is currently the only choice that is case sensitive.)',
  on_page varchar(50) NOT NULL COMMENT 'Which code page (sorted alphabetically) has the first occurrence of the above phrase.',
  English_US varchar(300) NOT NULL COMMENT 'The full English text.',
  Afrikaans varchar(300) NOT NULL,
  Albanian varchar(300) NOT NULL,
  Arabic varchar(300) NOT NULL,
  Armenian varchar(300) NOT NULL,
  Azerbaijan varchar(300) NOT NULL,
  Basque varchar(300) NOT NULL,
  Belarusian varchar(300) NOT NULL,
  Bulgarian varchar(300) NOT NULL,
  Catalan varchar(300) NOT NULL,
  Chamorro varchar(300) NOT NULL,
  Chinese_Big5 varchar(300) NOT NULL,
  Chinese_GB2312 varchar(300) NOT NULL,
  Croatian varchar(300) CHARACTER SET utf8 COLLATE utf8_croatian_ci NOT NULL,
  Czech varchar(300) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  Danish varchar(300) CHARACTER SET utf8 COLLATE utf8_danish_ci NOT NULL,
  Dutch varchar(300) NOT NULL,
  Esperanto varchar(300) CHARACTER SET utf8 COLLATE utf8_esperanto_ci NOT NULL,
  Estonian varchar(300) CHARACTER SET utf8 COLLATE utf8_estonian_ci NOT NULL,
  Faroese varchar(300) NOT NULL,
  Farsi varchar(300) NOT NULL,
  Finnish varchar(300) NOT NULL,
  French varchar(300) NOT NULL,
  Galician varchar(300) NOT NULL,
  Georgian varchar(300) NOT NULL,
  German varchar(300) CHARACTER SET utf8 COLLATE utf8_german2_ci NOT NULL,
  Greek varchar(300) NOT NULL,
  Hebrew varchar(300) NOT NULL,
  Hungarian varchar(300) CHARACTER SET utf8 COLLATE utf8_hungarian_ci NOT NULL,
  Icelandic varchar(300) CHARACTER SET utf8 COLLATE utf8_icelandic_ci NOT NULL,
  Indonesian varchar(300) NOT NULL,
  Italian varchar(300) NOT NULL,
  Japanese varchar(300) NOT NULL,
  Klingon varchar(300) NOT NULL,
  Korean varchar(300) NOT NULL,
  Latvian varchar(300) CHARACTER SET utf8 COLLATE utf8_latvian_ci NOT NULL,
  Lithuanian varchar(300) CHARACTER SET utf8 COLLATE utf8_lithuanian_ci NOT NULL,
  Malaysian varchar(300) NOT NULL,
  Myanmar varchar(300) CHARACTER SET utf8 COLLATE utf8_myanmar_ci NOT NULL,
  Norwegian varchar(300) NOT NULL,
  Persian varchar(300) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  Polish varchar(300) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  Portuguese varchar(300) NOT NULL,
  Portuguese_BR varchar(300) NOT NULL,
  Romanian varchar(300) CHARACTER SET utf8 COLLATE utf8_romanian_ci NOT NULL,
  Russian varchar(300) NOT NULL,
  Serbian varchar(300) NOT NULL,
  Sinhala varchar(300) CHARACTER SET utf8 COLLATE utf8_sinhala_ci NOT NULL,
  Slovakian varchar(300) CHARACTER SET utf8 COLLATE utf8_slovak_ci NOT NULL,
  Slovenian varchar(300) CHARACTER SET utf8 COLLATE utf8_slovenian_ci NOT NULL,
  Spanish varchar(300) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  Swedish varchar(300) NOT NULL,
  Taiwanese varchar(300) NOT NULL,
  Turkish varchar(300) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  Ukrainian varchar(300) NOT NULL,
  Vietnamese varchar(300) CHARACTER SET utf8 COLLATE utf8_vietnamese_ci NOT NULL,
  Welsh varchar(300) NOT NULL,
  PRIMARY KEY (phrase),
  KEY ndx_wtz_op (on_page)
) COMMENT='<a name="webcal_translations">webcal_translations</a> translations for Various language "supported" by WebCalendar.';
/*upgrade_1.9.14*/
/*upgrade_1.9.15*/
/*upgrade_10.10.10*/
/*upgrade_17.0.1*/
/* PROBABLY won't take me quite that long. I hope.:( */
