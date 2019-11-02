
DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
    `user_id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `defaultlogin_id` INT UNSIGNED UNIQUE,
    `wallet_restriction_id` INT UNSIGNED NOT NULL UNIQUE,
    `google_uid` VARCHAR(21) UNIQUE, -- Google UIDs are 21 chars long
    `nickname` VARCHAR(30) CHARACTER SET utf32 COLLATE utf32_unicode_ci NOT NULL,
    `verified` BOOLEAN NOT NULL,
    `change_uid` BINARY(16) UNIQUE,
    `change_expire_date` DATETIME,
    `session_id` VARCHAR(64) DEFAULT NULL UNIQUE,
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `avatar_state` ENUM('default', 'custom') NOT NULL DEFAULT 'default',
    PRIMARY KEY(`user_id`),
    CONSTRAINT `CHECK_nickname` CHECK (
        `nickname` REGEXP '^[A-Za-z0-9_\-]{5,20}$'
    ),
    CONSTRAINT `CHECK_logins_present` CHECK (
        (`defaultlogin_id` IS NOT NULL) OR (`google_uid` IS NOT NULL)
    ),
    FOREIGN KEY (`defaultlogin_id`) REFERENCES `DefaultLogins` (`defaultlogin_id`),
    FOREIGN KEY (`wallet_restriction_id`) REFERENCES `WalletRestrictions` (`wallet_restriction_id`)
);

-- when a user is deleted, the associated data will also be deleted
CREATE TRIGGER `TRIGG_delete_defaultlogin_on_user_delete` 
AFTER DELETE ON `Users`
FOR EACH ROW
BEGIN
    -- delete DefaultLogins
    DELETE FROM `DefaultLogins` WHERE `DefaultLogins`.`defaultlogin_id` = `OLD`.`defaultlogin_id`;
    -- delete WalletRestrictions
    DELETE FROM `WalletRestrictions` WHERE `WalletRestrictions`.`wallet_restriction_id` = `OLD`.`wallet_restriction_id`;
END;

-- 
CREATE TRIGGER `TRIGG_change_meta_null_at_the_same_time` 
BEFORE UPDATE ON `Users`
FOR EACH ROW
BEGIN
    IF ((`NEW`.`change_uid` = NULL AND `NEW`.`change_expire_date` <> NULL) OR
        (`NEW`.`change_uid` <> NULL AND `NEW`.`change_expire_date` = NULL))
    THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INVALID_CHANGE_META_STATE';
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

