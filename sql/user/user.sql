
DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
    `user_id`               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `defaultlogin_id`       INT UNSIGNED UNIQUE DEFAULT NULL,
    `googlelogin_id`        INT UNSIGNED UNIQUE DEFAULT NULL,
    `wallet_restriction_id` INT UNSIGNED NOT NULL UNIQUE,
    `nickname`              VARCHAR(30) CHARACTER SET utf32 COLLATE utf32_unicode_ci NOT NULL,
    `verified`              BOOLEAN NOT NULL,
    `change_uid`            BINARY(16) UNIQUE,
    `change_expire_date`    DATETIME,
    `session_id`            VARCHAR(64) DEFAULT NULL UNIQUE,
    `created_time`          DATETIME DEFAULT CURRENT_TIMESTAMP,
    `avatar_state`          ENUM('default', 'custom') NOT NULL DEFAULT 'default',
    `email`                 VARCHAR(60) NOT NULL UNIQUE,
    `new_email`             VARCHAR(60) UNIQUE DEFAULT NULL,
    PRIMARY KEY(`user_id`),
    CONSTRAINT `CHECK_nickname` CHECK (
        `nickname` REGEXP '^[A-Za-z0-9_\-]{5,20}$'
    ),
    CONSTRAINT `CHECK_logins_present` CHECK (
        ((`defaultlogin_id` IS NOT NULL) OR (`googlelogin_id` IS NOT NULL)) != FALSE
    ),
    CONSTRAINT `CHECK_email` CHECK (
        `email` REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$'
    ),
    CONSTRAINT `CHECK_new_email` CHECK (
        `new_email` REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$' 
    ),
    FOREIGN KEY (`defaultlogin_id`) REFERENCES `DefaultLogins` (`defaultlogin_id`) ON UPDATE RESTRICT,
    FOREIGN KEY (`googlelogin_id`) REFERENCES `GoogleLogins` (`googlelogin_id`) ON UPDATE RESTRICT,
    FOREIGN KEY (`wallet_restriction_id`) REFERENCES `WalletRestrictions` (`wallet_restriction_id`) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- when a user is deleted, the associated data will also be deleted
CREATE TRIGGER `TRIGG_users_delete_before` 
BEFORE DELETE ON `Users`
FOR EACH ROW
BEGIN
    SET @deleting = 1;
END;


-- when a user is deleted, the associated data will also be deleted
CREATE TRIGGER `TRIGG_users_delete_after` 
AFTER DELETE ON `Users`
FOR EACH ROW
BEGIN
    -- delete DefaultLogins
    DELETE FROM `DefaultLogins` WHERE `DefaultLogins`.`defaultlogin_id` = `OLD`.`defaultlogin_id`;
    -- delete GoogleLogins
    DELETE FROM `GoogleLogins` WHERE `GoogleLogins`.`googlelogin_id` = `OLD`.`googlelogin_id`;
    -- delete WalletRestrictions
    DELETE FROM `WalletRestrictions` WHERE `WalletRestrictions`.`wallet_restriction_id` = `OLD`.`wallet_restriction_id`;

    SET @deleting = NULL;
END;

-- 
CREATE TRIGGER `TRIGG_users_update` 
BEFORE UPDATE ON `Users`
FOR EACH ROW
BEGIN
    IF ((`NEW`.`change_uid` = NULL AND `NEW`.`change_expire_date` <> NULL) OR
        (`NEW`.`change_uid` <> NULL AND `NEW`.`change_expire_date` = NULL))
    THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INVALID_CHANGE_META_STATE';
    END IF;

    IF ((`NEW`.`defaultlogin_id` IS NULL) AND (`NEW`.`googlelogin_id` IS NULL))
    THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'INVALID_LOGIN_STATE';
    END IF;
END;

-- =========
-- FUNCTIONS
-- =========

-- generate a UUID. Used for change_uid.
CREATE FUNCTION POEM_UUID() RETURNS BINARY(16)
    NO SQL
    SQL SECURITY INVOKER
RETURN UNHEX(REPLACE(UUID(), '-', ''));

-- Creates a date that is far in the future
CREATE FUNCTION POEM_DATE_INFINITY() RETURNS DATETIME
    NO SQL
    SQL SECURITY INVOKER
RETURN ADDDATE(NOW(), INTERVAL 1000 YEAR);

-- Create a data that is two weeks from now
CREATE FUNCTION POEM_DATE_TWO_WEEKS() RETURNS DATETIME
    NO SQL
    SQL SECURITY INVOKER
RETURN ADDDATE(NOW(), INTERVAL 2 WEEK);

