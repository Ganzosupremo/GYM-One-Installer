SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `calendar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_name` varchar(255) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `color` varchar(7) NOT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT 1,
  `recurring_day` varchar(10) DEFAULT NULL,
  `trainer_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `current_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL DEFAULT 0,
  `ticketname` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `buydate` date NOT NULL,
  `expiredate` date NOT NULL,
  `opportunities` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL DEFAULT 0,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('paid','unpaid') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `route` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `lockers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lockernum` int(11) NOT NULL,
  `gender` enum('Male','Female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT NULL,
  `action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `actioncolor` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'info',
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Részletes információk JSON formátumban' CHECK (json_valid(`details`)),
  `time` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_userid` (`userid`) USING BTREE,
  KEY `idx_time` (`time`) USING BTREE,
  KEY `idx_actioncolor` (`actioncolor`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `opening_hours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` int(11) NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `day` (`day`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `opening_hours_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `barcode` varchar(128) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `barcode` (`barcode`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `revenu_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `bank_card` decimal(10,2) DEFAULT 0.00,
  `cash` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `showcase_ads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `showcase_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Sankris Gymnastics: programas de gimnasia (grupos por edad y nivel)
CREATE TABLE IF NOT EXISTS `programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `age_min` int(11) DEFAULT NULL,
  `age_max` int(11) DEFAULT NULL,
  `max_students` int(11) DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '#90278e',
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `temp_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `temp_dailyworkout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `number_of_people` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `temp_loggeduser` (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `userid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `login_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `lockerid` int(20) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expire_days` int(11) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `occasions` int(11) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `timetable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `day_of_week` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `program_id` int(11) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `is_evaluation` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `day_of_week` (`day_of_week`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `trainers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price_1hour` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price_10sessions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `userid` bigint(20) unsigned NOT NULL,
  `firstname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('Male','Female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `birthdate` date NOT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `street` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `house_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `registration_date` datetime NOT NULL,
  `confirmed` enum('Yes','No') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `lastip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `profile_balance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `program_id` int(11) DEFAULT NULL,
  `gym_level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `guardian_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `guardian_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `medical_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `workers` (
  `userid` bigint(20) NOT NULL,
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_boss` tinyint(1) NOT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE IF NOT EXISTS `workout_stats` (
  `workout_id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL DEFAULT 0,
  `duration` int(11) DEFAULT NULL,
  `workout_date` date DEFAULT NULL,
  PRIMARY KEY (`workout_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `opening_hours` (`id`, `day`, `open_time`, `close_time`) VALUES
	(1, 1, NULL, NULL),
	(2, 2, NULL, NULL),
	(3, 3, NULL, NULL),
	(4, 4, NULL, NULL),
	(5, 5, NULL, NULL),
	(6, 6, NULL, NULL),
	(7, 7, NULL, NULL);

-- Sankris Gymnastics: programas, horarios y cuotas 2026
-- Fuente: Servicios, Horarios y Precios 2026. Precios en quetzales (GTQ).
-- Importante: los nombres de los días están en español, por eso LANG_CODE debe ser ES.

INSERT INTO `programs` (`id`, `name`, `age_min`, `age_max`, `max_students`, `duration_minutes`, `area`, `description`, `color`, `sort_order`) VALUES
	(1, 'Baby Gymnastics', 3, 5, 6, 55, 'BabyGym', 'Clases para bebés de 3 a 5 años. Grupos de 6 gimnastas.', '#eb008b', 1),
	(2, 'Start Gymnastics', 6, NULL, 6, 55, 'Gym', 'Clases para niñas y niños desde 6 años. Grupos de 6 participantes.', '#90278e', 2),
	(3, 'Intermediate Gymnastics', 6, 12, 10, 55, 'Gym', 'Clases para niñas de 6 a 12 años. Grupos de 10 gimnastas.', '#6a50a0', 3),
	(4, 'Advanced Gymnastics - Recreativo', 6, 15, 10, 55, 'Gym', 'Clases para niñas de 6 a 15 años. Grupos de 10 gimnastas.', '#3d59a7', 4),
	(5, 'Advanced Gymnastics - Competitivo', 6, 15, 15, 150, 'Gym', 'Clases de 2.5 horas para niñas de 6 a 15 años, niveles 1, 2 y 3+. Hasta 15 gimnastas por grupo. Horarios específicos por nivel: consultar en administración.', '#1f3a7a', 5),
	(6, 'Tae Kwon Do', 6, 15, 15, 55, 'Gym', 'Clases para niñas y niños de 6 a 15 años. Hasta 15 participantes por grupo.', '#e07b00', 6),
	(7, 'Golden Gymnastics', 50, NULL, 8, 60, 'Gym', 'Gimnasia para adultos desde los 50 años, adaptada al nivel de cada participante. Mejora equilibrio, fuerza y movilidad. Clases seguras y supervisadas de 6 a 8 adultos.', '#c9a227', 7);

INSERT INTO `timetable` (`event_name`, `start_time`, `end_time`, `day_of_week`, `color`, `program_id`, `capacity`, `is_evaluation`) VALUES
	('Golden Gymnastics', '09:00:00', '10:00:00', 'Lunes', '#c9a227', 7, 8, 0),
	('Baby 3 años', '15:00:00', '15:55:00', 'Lunes', '#eb008b', 1, 6, 0),
	('Start Gymnastics', '15:30:00', '16:25:00', 'Lunes', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '16:00:00', '16:55:00', 'Lunes', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '16:30:00', '17:25:00', 'Lunes', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '16:30:00', '17:25:00', 'Lunes', '#6a50a0', 3, 10, 0),
	('Advanced Recreativo', '16:30:00', '17:25:00', 'Lunes', '#3d59a7', 4, 10, 0),
	('Start Gymnastics', '17:30:00', '18:25:00', 'Lunes', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '17:30:00', '18:25:00', 'Lunes', '#6a50a0', 3, 10, 0),
	('Advanced Recreativo', '17:30:00', '18:25:00', 'Lunes', '#3d59a7', 4, 10, 0),
	('Tae Kwon Do', '18:30:00', '19:25:00', 'Lunes', '#e07b00', 6, 15, 0),
	('Evaluación inicial Tae Kwon Do', '18:30:00', '19:25:00', 'Lunes', '#2e9d6b', 6, 15, 1),
	('Baby 3 años', '15:00:00', '15:55:00', 'Martes', '#eb008b', 1, 6, 0),
	('Baby 4 y 5 años', '15:00:00', '15:55:00', 'Martes', '#f06bb8', 1, 6, 0),
	('Evaluación inicial Baby', '15:00:00', '15:55:00', 'Martes', '#2e9d6b', 1, 6, 1),
	('Start Gymnastics', '15:30:00', '16:25:00', 'Martes', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '16:00:00', '16:55:00', 'Martes', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '16:30:00', '17:25:00', 'Martes', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '16:30:00', '17:25:00', 'Martes', '#6a50a0', 3, 10, 0),
	('Baby 4 y 5 años', '17:00:00', '17:55:00', 'Martes', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '17:30:00', '18:25:00', 'Martes', '#90278e', 2, 6, 0),
	('Evaluación inicial Start', '17:30:00', '18:25:00', 'Martes', '#2e9d6b', 2, 6, 1),
	('Intermediate Gymnastics', '17:30:00', '18:25:00', 'Martes', '#6a50a0', 3, 10, 0),
	('Golden Gymnastics', '09:00:00', '10:00:00', 'Miércoles', '#c9a227', 7, 8, 0),
	('Start Gymnastics', '15:30:00', '16:25:00', 'Miércoles', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '16:00:00', '16:55:00', 'Miércoles', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '16:30:00', '17:25:00', 'Miércoles', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '16:30:00', '17:25:00', 'Miércoles', '#6a50a0', 3, 10, 0),
	('Advanced Recreativo', '16:30:00', '17:25:00', 'Miércoles', '#3d59a7', 4, 10, 0),
	('Start Gymnastics', '17:30:00', '18:25:00', 'Miércoles', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '17:30:00', '18:25:00', 'Miércoles', '#6a50a0', 3, 10, 0),
	('Advanced Recreativo', '17:30:00', '18:25:00', 'Miércoles', '#3d59a7', 4, 10, 0),
	('Baby 4 y 5 años', '15:00:00', '15:55:00', 'Jueves', '#f06bb8', 1, 6, 0),
	('Evaluación inicial Baby', '15:00:00', '15:55:00', 'Jueves', '#2e9d6b', 1, 6, 1),
	('Start Gymnastics', '15:30:00', '16:25:00', 'Jueves', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '16:00:00', '16:55:00', 'Jueves', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '16:30:00', '17:25:00', 'Jueves', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '16:30:00', '17:25:00', 'Jueves', '#6a50a0', 3, 10, 0),
	('Baby 4 y 5 años', '17:00:00', '17:55:00', 'Jueves', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '17:30:00', '18:25:00', 'Jueves', '#90278e', 2, 6, 0),
	('Evaluación inicial Start', '17:30:00', '18:25:00', 'Jueves', '#2e9d6b', 2, 6, 1),
	('Intermediate Gymnastics', '17:30:00', '18:25:00', 'Jueves', '#6a50a0', 3, 10, 0),
	('Baby 4 y 5 años', '15:00:00', '15:55:00', 'Viernes', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '15:30:00', '16:25:00', 'Viernes', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '16:00:00', '16:55:00', 'Viernes', '#f06bb8', 1, 6, 0),
	('Start Gymnastics', '16:30:00', '17:25:00', 'Viernes', '#90278e', 2, 6, 0),
	('Start Gymnastics', '17:30:00', '18:25:00', 'Viernes', '#90278e', 2, 6, 0),
	('Baby 4 y 5 años', '08:00:00', '08:55:00', 'Sábado', '#f06bb8', 1, 6, 0),
	('Evaluación inicial Baby', '08:00:00', '08:55:00', 'Sábado', '#2e9d6b', 1, 6, 1),
	('Start Gymnastics', '08:00:00', '08:55:00', 'Sábado', '#90278e', 2, 6, 0),
	('Baby 3 años', '09:00:00', '09:55:00', 'Sábado', '#eb008b', 1, 6, 0),
	('Start Gymnastics', '09:00:00', '09:55:00', 'Sábado', '#90278e', 2, 6, 0),
	('Evaluación inicial Start', '09:00:00', '09:55:00', 'Sábado', '#2e9d6b', 2, 6, 1),
	('Start Gymnastics', '10:00:00', '10:55:00', 'Sábado', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '10:00:00', '10:55:00', 'Sábado', '#6a50a0', 3, 10, 0),
	('Start Gymnastics', '11:00:00', '11:55:00', 'Sábado', '#90278e', 2, 6, 0),
	('Intermediate Gymnastics', '11:00:00', '11:55:00', 'Sábado', '#6a50a0', 3, 10, 0);

INSERT INTO `tickets` (`name`, `expire_days`, `price`, `occasions`, `program_id`) VALUES
	('Inscripción anual Gimnasia', 365, 585.0, NULL, NULL),
	('Inscripción anual Tae Kwon Do', 365, 300.0, NULL, 6),
	('Inscripción anual Golden Gym', 365, 450.0, NULL, 7),
	('Baby Gym - 1 clase x semana', 30, 770.0, 4, 1),
	('Baby Gym - 2 clases x semana', 30, 975.0, 8, 1),
	('Start - 1 clase x semana', 30, 770.0, 4, 2),
	('Start - 2 clases x semana', 30, 975.0, 8, 2),
	('Start - 3 clases x semana', 30, 1200.0, 12, 2),
	('Intermediate - 2 clases x semana', 30, 975.0, 8, 3),
	('Intermediate - 3 clases x semana', 30, 1200.0, 12, 3),
	('Adv. Recreativo - 2 clases x semana', 30, 975.0, 8, 4),
	('Adv. Competitivo - 3 clases x semana', 30, 1500.0, 12, 5),
	('Tae Kwon Do - 1 clase x semana', 30, 450.0, 4, 6),
	('Golden Gym - 1 clase x semana', 30, 450.0, 4, 7),
	('Golden Gym - 2 clases x semana', 30, 575.0, 8, 7),
	('Clase de evaluación inicial', 7, 0.0, 1, NULL);

UPDATE `opening_hours` SET `open_time` = '09:00:00', `close_time` = '19:30:00' WHERE `day` = 1;
UPDATE `opening_hours` SET `open_time` = '15:00:00', `close_time` = '18:30:00' WHERE `day` = 2;
UPDATE `opening_hours` SET `open_time` = '09:00:00', `close_time` = '18:30:00' WHERE `day` = 3;
UPDATE `opening_hours` SET `open_time` = '15:00:00', `close_time` = '18:30:00' WHERE `day` = 4;
UPDATE `opening_hours` SET `open_time` = '15:00:00', `close_time` = '18:30:00' WHERE `day` = 5;
UPDATE `opening_hours` SET `open_time` = '08:00:00', `close_time` = '12:00:00' WHERE `day` = 6;
UPDATE `opening_hours` SET `open_time` = NULL, `close_time` = NULL WHERE `day` = 7;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
