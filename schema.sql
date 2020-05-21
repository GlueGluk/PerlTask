CREATE TABLE `message` (
    `created` DATETIME NOT NULL,
    `id` VARCHAR(200) NOT NULL,
    `int_id` CHAR(16) NOT NULL,
    `str` TEXT NOT NULL,
    `status` BOOL,
    CONSTRAINT `message_id_pk` PRIMARY KEY(`id`)
);
CREATE INDEX `message_created_idx` ON `message` (`created`);
CREATE INDEX `message_int_id_idx` ON `message` (`int_id`);
CREATE TABLE `log` (
    `created` DATETIME NOT NULL,
    `int_id` CHAR(16) NOT NULL,
    `str` TEXT,
    `address` VARCHAR(200)
);
CREATE INDEX `log_address_idx` ON `log` (`address`) USING HASH;
