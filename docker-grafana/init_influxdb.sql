PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE `data_source` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `name` TEXT NOT NULL
, `access` TEXT NOT NULL
, `url` TEXT NOT NULL
, `password` TEXT NULL
, `user` TEXT NULL
, `database` TEXT NULL
, `basic_auth` INTEGER NOT NULL
, `basic_auth_user` TEXT NULL
, `basic_auth_password` TEXT NULL
, `is_default` INTEGER NOT NULL
, `json_data` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE INDEX `IDX_data_source_org_id` ON `data_source` (`org_id`);
INSERT INTO "data_source" (org_id, version, type, name, access, url, password, user, database, basic_auth, is_default, created, updated)
VALUES (1,0,'influxdb','<--DASH_NAME-->','proxy','<--PROTO-->://<--HOST-->:<--PORT-->','<--PASS-->','<--USER-->','<--DB_NAME-->',0,1,(SELECT datetime('now')),(SELECT datetime('now')));
COMMIT;
