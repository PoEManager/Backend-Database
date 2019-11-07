DROP TABLE IF EXISTS `DefaultLogins`;

CREATE TABLE `DefaultLogins` (
    `defaultlogin_id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `password`          VARCHAR(60) NOT NULL,
    `new_password`      VARCHAR(60) DEFAULT NULL,
    PRIMARY KEY(`defaultlogin_id`)
);

-- emulate foreign key ON DELETE SET NULL in Users
CREATE TRIGGER `TIGG_default_logins_delete` 
BEFORE DELETE ON `DefaultLogins`
FOR EACH ROW
BEGIN
    IF @deleting IS NULL THEN
        UPDATE `Users` SET `Users`.`defaultlogin_id` = NULL WHERE `Users`.`defaultlogin_id` = `OLD`.`defaultlogin_id`;
    END IF; 
END;
