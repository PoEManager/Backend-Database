DROP TABLE IF EXISTS `DefaultLogins`;

CREATE TABLE `DefaultLogins` (
    `defaultlogin_id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email`             VARCHAR(60) NOT NULL UNIQUE,
    `password`          VARCHAR(60) NOT NULL,
    `new_email`         VARCHAR(60) UNIQUE DEFAULT NULL,
    `new_password`      VARCHAR(60) DEFAULT NULL,
    PRIMARY KEY(`defaultlogin_id`),
    CONSTRAINT `CHECK_email` CHECK (
        `email` REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$'
    ),
    CONSTRAINT `CHECK_new_email` CHECK (
        `new_email` REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$' 
    )
);
