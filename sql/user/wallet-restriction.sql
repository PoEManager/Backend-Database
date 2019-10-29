DROP TABLE IF EXISTS `WalletRestrictions`;

CREATE TABLE `WalletRestrictions` (
    `wallet_restriction_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ignore_alt`     INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_fuse`    INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_alch`    INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_chaos`   INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_gcp`     INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_exa`     INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_chrom`   INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_jew`     INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_chance`  INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_chisel`  INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_scour`   INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_blessed` INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_regret`  INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_regal`   INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_divine`  INT UNSIGNED NOT NULL DEFAULT 0,
    `ignore_vaal`    INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY(`wallet_restriction_id`)
);
