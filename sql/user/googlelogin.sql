DROP TABLE IF EXISTS `GoogleLogins`;

CREATE TABLE `GoogleLogins` (
    `googlelogin_id`    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `google_uid`        VARCHAR(21) NOT NULL UNIQUE, -- Google UIDs are 21 chars long
    PRIMARY KEY(`googlelogin_id`)
);

-- emulate foreign key ON DELETE SET NULL in Users
CREATE TRIGGER `TIGG_google_logins_delete` 
BEFORE DELETE ON `GoogleLogins`
FOR EACH ROW
BEGIN
    IF @deleting IS NULL THEN
        UPDATE `Users` SET `Users`.`googlelogin_id` = NULL WHERE `Users`.`googlelogin_id` = `OLD`.`googlelogin_id`;
    END IF; 
END;
