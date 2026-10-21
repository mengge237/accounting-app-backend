-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: accountingapp
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `accountingapp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `accountingapp` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `accountingapp`;

--
-- Table structure for table `account_records`
--

DROP TABLE IF EXISTS `account_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '所属用户',
  `ledger_id` int NOT NULL DEFAULT '1' COMMENT '所属账本ID',
  `type_id` int NOT NULL COMMENT '账目类型ID',
  `amount` decimal(12,2) NOT NULL COMMENT '金额',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `record_date` date NOT NULL COMMENT '记账日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_record_date` (`record_date`),
  KEY `type_id` (`type_id`),
  KEY `idx_ledger_id` (`ledger_id`),
  CONSTRAINT `account_records_ibfk_ledger` FOREIGN KEY (`ledger_id`) REFERENCES `ledger_books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3 COMMENT='记账记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_records`
--

LOCK TABLES `account_records` WRITE;
/*!40000 ALTER TABLE `account_records` DISABLE KEYS */;
INSERT INTO `account_records` VALUES (1,1,1,1,68.50,'午餐','2024-12-01','2026-04-21 07:00:29'),(2,1,1,1,125.00,'晚餐聚餐','2024-12-02','2026-04-21 07:00:29'),(3,1,1,2,299.00,'双十一买衣服','2024-12-03','2026-04-21 07:00:29'),(4,1,1,3,45.00,'打车上班','2024-12-04','2026-04-21 07:00:29'),(5,1,1,3,12.00,'共享单车月卡','2024-12-05','2026-04-21 07:00:29'),(6,1,1,4,88.00,'看电影','2024-12-06','2026-04-21 07:00:29'),(7,1,1,5,156.00,'感冒药','2024-12-07','2026-04-21 07:00:29'),(8,1,1,9,2500.00,'12月房租','2024-12-01','2026-04-21 07:00:29'),(9,1,1,10,380.00,'电费+水费','2024-12-10','2026-04-21 07:00:29'),(10,1,1,6,15000.00,'12月工资','2024-12-15','2026-04-21 07:00:29'),(11,1,1,7,3000.00,'年终奖','2024-12-20','2026-04-21 07:00:29'),(12,1,1,8,500.00,'基金收益','2024-12-25','2026-04-21 07:00:29'),(13,1,1,11,1200.00,'周末兼职','2024-12-22','2026-04-21 07:00:29'),(14,1,1,12,800.00,'生日红包','2024-12-18','2026-04-21 07:00:29'),(15,2,2,1,45.00,'早餐咖啡+面包','2024-12-01','2026-04-21 07:00:29'),(16,2,2,1,89.00,'午餐便当','2024-12-03','2026-04-21 07:00:29'),(17,2,2,2,599.00,'新鞋子','2024-12-05','2026-04-21 07:00:29'),(18,2,2,3,200.00,'加油','2024-12-07','2026-04-21 07:00:29'),(19,2,2,4,199.00,'游戏充值','2024-12-10','2026-04-21 07:00:29'),(20,2,2,13,300.00,'猫粮+猫砂','2024-12-12','2026-04-21 07:00:29'),(21,2,2,14,800.00,'健身房年费','2024-12-15','2026-04-21 07:00:29'),(22,2,2,9,3500.00,'房租','2024-12-01','2026-04-21 07:00:29'),(23,2,2,6,20000.00,'12月工资','2024-12-20','2026-04-21 07:00:29'),(24,2,2,7,5000.00,'项目奖金','2024-12-22','2026-04-21 07:00:29'),(25,2,2,15,1500.00,'股票分红','2024-12-25','2026-04-21 07:00:29'),(26,1,1,1,158.00,'跨年晚餐','2025-01-01','2026-04-21 07:00:29'),(27,2,2,4,300.00,'元旦看电影+爆米花','2025-01-01','2026-04-21 07:00:29'),(28,1,1,1,68.50,'午餐','2024-12-01','2026-04-21 07:02:56'),(29,1,1,1,125.00,'晚餐聚餐','2024-12-02','2026-04-21 07:02:56'),(30,1,1,2,299.00,'双十一买衣服','2024-12-03','2026-04-21 07:02:56'),(31,1,1,3,45.00,'打车上班','2024-12-04','2026-04-21 07:02:56'),(32,1,1,3,12.00,'共享单车月卡','2024-12-05','2026-04-21 07:02:56'),(33,1,1,4,88.00,'看电影','2024-12-06','2026-04-21 07:02:56'),(34,1,1,5,156.00,'感冒药','2024-12-07','2026-04-21 07:02:56'),(35,1,1,9,2500.00,'12月房租','2024-12-01','2026-04-21 07:02:56'),(36,1,1,10,380.00,'电费+水费','2024-12-10','2026-04-21 07:02:56'),(37,1,1,6,15000.00,'12月工资','2024-12-15','2026-04-21 07:02:56'),(38,1,1,7,3000.00,'年终奖','2024-12-20','2026-04-21 07:02:56'),(39,1,1,8,500.00,'基金收益','2024-12-25','2026-04-21 07:02:56'),(40,1,1,11,1200.00,'周末兼职','2024-12-22','2026-04-21 07:02:56'),(41,1,1,12,800.00,'生日红包','2024-12-18','2026-04-21 07:02:56'),(42,2,2,1,45.00,'早餐咖啡+面包','2024-12-01','2026-04-21 07:02:56'),(43,2,2,1,89.00,'午餐便当','2024-12-03','2026-04-21 07:02:56'),(44,2,2,2,599.00,'新鞋子','2024-12-05','2026-04-21 07:02:56'),(45,2,2,3,200.00,'加油','2024-12-07','2026-04-21 07:02:56'),(46,2,2,4,199.00,'游戏充值','2024-12-10','2026-04-21 07:02:56'),(47,2,2,13,300.00,'猫粮+猫砂','2024-12-12','2026-04-21 07:02:56'),(48,2,2,14,800.00,'健身房年费','2024-12-15','2026-04-21 07:02:56'),(49,2,2,9,3500.00,'房租','2024-12-01','2026-04-21 07:02:56'),(50,2,2,6,20000.00,'12月工资','2024-12-20','2026-04-21 07:02:56'),(51,2,2,7,5000.00,'项目奖金','2024-12-22','2026-04-21 07:02:56'),(52,2,2,15,1500.00,'股票分红','2024-12-25','2026-04-21 07:02:56'),(53,1,1,1,158.00,'跨年晚餐','2025-01-01','2026-04-21 07:02:56'),(54,2,2,4,300.00,'元旦看电影+爆米花','2025-01-01','2026-04-21 07:02:56'),(55,1,1,1,68.50,'午餐','2024-12-01','2026-04-21 07:03:50'),(56,1,1,1,125.00,'晚餐聚餐','2024-12-02','2026-04-21 07:03:50'),(57,1,1,2,299.00,'双十一买衣服','2024-12-03','2026-04-21 07:03:50'),(58,1,1,3,45.00,'打车上班','2024-12-04','2026-04-21 07:03:50'),(59,1,1,3,12.00,'共享单车月卡','2024-12-05','2026-04-21 07:03:50'),(60,1,1,4,88.00,'看电影','2024-12-06','2026-04-21 07:03:50'),(61,1,1,5,156.00,'感冒药','2024-12-07','2026-04-21 07:03:50'),(62,1,1,9,2500.00,'12月房租','2024-12-01','2026-04-21 07:03:50'),(63,1,1,10,380.00,'电费+水费','2024-12-10','2026-04-21 07:03:50'),(64,1,1,6,15000.00,'12月工资','2024-12-15','2026-04-21 07:03:50'),(65,1,1,7,3000.00,'年终奖','2024-12-20','2026-04-21 07:03:50'),(66,1,1,8,500.00,'基金收益','2024-12-25','2026-04-21 07:03:50'),(67,1,1,11,1200.00,'周末兼职','2024-12-22','2026-04-21 07:03:50'),(68,1,1,12,800.00,'生日红包','2024-12-18','2026-04-21 07:03:50'),(69,2,2,1,45.00,'早餐咖啡+面包','2024-12-01','2026-04-21 07:03:50'),(70,2,2,1,89.00,'午餐便当','2024-12-03','2026-04-21 07:03:50'),(71,2,2,2,599.00,'新鞋子','2024-12-05','2026-04-21 07:03:50'),(72,2,2,3,200.00,'加油','2024-12-07','2026-04-21 07:03:50'),(73,2,2,4,199.00,'游戏充值','2024-12-10','2026-04-21 07:03:50'),(74,2,2,13,300.00,'猫粮+猫砂','2024-12-12','2026-04-21 07:03:50'),(75,2,2,14,800.00,'健身房年费','2024-12-15','2026-04-21 07:03:50'),(76,2,2,9,3500.00,'房租','2024-12-01','2026-04-21 07:03:50'),(77,2,2,6,20000.00,'12月工资','2024-12-20','2026-04-21 07:03:50'),(78,2,2,7,5000.00,'项目奖金','2024-12-22','2026-04-21 07:03:50'),(79,2,2,15,1500.00,'股票分红','2024-12-25','2026-04-21 07:03:50'),(80,1,1,1,158.00,'跨年晚餐','2025-01-01','2026-04-21 07:03:50'),(81,2,2,4,300.00,'元旦看电影+爆米花','2025-01-01','2026-04-21 07:03:50');
/*!40000 ALTER TABLE `account_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_types`
--

DROP TABLE IF EXISTS `account_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL DEFAULT '0' COMMENT '用户ID，0表示系统预设',
  `type_name` varchar(50) NOT NULL COMMENT '类型名称',
  `category` enum('income','expense') NOT NULL COMMENT '收入或支出',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标资源名',
  `is_default` tinyint(1) DEFAULT '1' COMMENT '是否系统预设',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_types`
--

LOCK TABLES `account_types` WRITE;
/*!40000 ALTER TABLE `account_types` DISABLE KEYS */;
INSERT INTO `account_types` VALUES (1,0,'餐饮','expense','[餐饮]',1),(2,0,'购物','expense','[购物]',1),(3,0,'交通','expense','[交通]',1),(4,0,'娱乐','expense','[娱乐]',1),(5,0,'医疗','expense','[医疗]',1),(6,0,'工资','income','[工资]',1),(7,0,'奖金','income','[奖金]',1),(8,0,'理财收益','income','[理财]',1),(9,0,'房租','expense','[房租]',1),(10,0,'水电费','expense','[水电]',1),(11,0,'兼职收入','income','[兼职]',1),(12,0,'红包','income','[红包]',1),(13,0,'宠物','expense','[宠物]',1),(14,0,'健身','expense','[健身]',1),(15,0,'股票收益','income','[股票]',1);
/*!40000 ALTER TABLE `account_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_settings`
--

DROP TABLE IF EXISTS `background_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `background_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `bg_type` enum('color','image','gradient') DEFAULT 'color' COMMENT '背景类型',
  `bg_value` varchar(255) NOT NULL COMMENT '背景值（颜色码/图片路径/渐变值）',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_active` (`user_id`,`is_active`),
  CONSTRAINT `background_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COMMENT='背景设置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_settings`
--

LOCK TABLES `background_settings` WRITE;
/*!40000 ALTER TABLE `background_settings` DISABLE KEYS */;
INSERT INTO `background_settings` VALUES (9,1,'color','#1890ff',1,'2026-04-21 07:03:50'),(10,1,'image','/uploads/bg/mountain.jpg',0,'2026-04-21 07:03:50'),(11,2,'gradient','linear-gradient(135deg, #667eea 0%, #764ba2 100%)',1,'2026-04-21 07:03:50'),(12,2,'color','#f0f2f5',0,'2026-04-21 07:03:50');
/*!40000 ALTER TABLE `background_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuisines`
--

DROP TABLE IF EXISTS `cuisines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuisines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '菜系名称',
  `description` text COMMENT '菜系介绍',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COMMENT='菜系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuisines`
--

LOCK TABLES `cuisines` WRITE;
/*!40000 ALTER TABLE `cuisines` DISABLE KEYS */;
INSERT INTO `cuisines` VALUES (1,'全部','显示所有菜谱',NULL,0,1,'2026-05-13 15:18:20'),(2,'川菜','川菜特点：麻辣鲜香，代表菜有麻婆豆腐、宫保鸡丁、水煮鱼',NULL,1,1,'2026-05-13 15:18:20'),(3,'粤菜','粤菜特点：清鲜嫩滑，代表菜有白切鸡、叉烧、蒸鱼',NULL,2,1,'2026-05-13 15:18:20'),(4,'鲁菜','鲁菜特点：咸鲜纯正，代表菜有葱烧海参、糖醋鲤鱼',NULL,3,1,'2026-05-13 15:18:20'),(5,'苏菜','苏菜特点：口味平和，代表菜有松鼠桂鱼、清炖蟹粉狮子头',NULL,4,1,'2026-05-13 15:18:20'),(6,'浙菜','浙菜特点：鲜美脆嫩，代表菜有西湖醋鱼、东坡肉',NULL,5,1,'2026-05-13 15:18:20'),(7,'闽菜','闽菜特点：清淡鲜香，代表菜有佛跳墙、荔枝肉',NULL,6,1,'2026-05-13 15:18:20'),(8,'湘菜','湘菜特点：香辣浓郁，代表菜有剁椒鱼头、小炒黄牛肉',NULL,7,1,'2026-05-13 15:18:20'),(9,'徽菜','徽菜特点：重油重色，代表菜有臭鳜鱼、毛豆腐',NULL,8,1,'2026-05-13 15:18:20'),(10,'西餐','西餐特点：精致多样，代表菜有牛排、披萨、意面',NULL,9,1,'2026-05-13 15:18:20'),(11,'日料','日料特点：清淡精致，代表菜有寿司、刺身、天妇罗',NULL,10,1,'2026-05-13 15:18:20'),(12,'韩餐','韩餐特点：辛辣开胃，代表菜有泡菜、烤肉、拌饭',NULL,11,1,'2026-05-13 15:18:20'),(13,'其他','其他类型菜谱',NULL,12,1,'2026-05-13 15:48:38'),(14,'烘焙','面包、蛋糕、饼干等烘焙美食',NULL,13,1,'2026-05-14 13:18:19'),(15,'汤羹','滋补养生汤品、羹类',NULL,14,1,'2026-05-14 13:18:19');
/*!40000 ALTER TABLE `cuisines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ledger_books`
--

DROP TABLE IF EXISTS `ledger_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ledger_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '所属用户',
  `name` varchar(50) NOT NULL COMMENT '账本名称',
  `icon` varchar(50) DEFAULT '' COMMENT '账本图标',
  `color` varchar(20) DEFAULT '#4CAF50' COMMENT '账本颜色',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否为默认账本',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `ledger_books_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COMMENT='账本表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger_books`
--

LOCK TABLES `ledger_books` WRITE;
/*!40000 ALTER TABLE `ledger_books` DISABLE KEYS */;
INSERT INTO `ledger_books` VALUES (1,1,'默认账本','im','#4CAF50',1,'2026-06-03 01:39:56','2026-06-06 08:25:42'),(2,2,'默认账本','book','#4CAF50',1,'2026-06-03 01:39:56','2026-06-03 01:39:56'),(3,3,'默认账本','book','#4CAF50',1,'2026-06-03 01:39:56','2026-06-03 01:39:56'),(4,1,'123','','#00BCD4',0,'2026-06-06 08:46:16','2026-06-06 08:46:16');
/*!40000 ALTER TABLE `ledger_books` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_ledger_books` BEFORE INSERT ON `ledger_books` FOR EACH ROW BEGIN
    DECLARE ledger_count INT;
    SELECT COUNT(*) INTO ledger_count FROM `ledger_books` WHERE `user_id` = NEW.`user_id`;
    IF ledger_count = 0 THEN
        SET NEW.`is_default` = 1;
    END IF;
    
    IF NEW.`icon` IS NULL THEN
        SET NEW.`icon` = '';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe_cuisine`
--

DROP TABLE IF EXISTS `recipe_cuisine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe_cuisine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int NOT NULL COMMENT '菜谱ID',
  `cuisine_id` int NOT NULL COMMENT '菜系ID',
  PRIMARY KEY (`id`),
  KEY `idx_recipe_id` (`recipe_id`),
  KEY `idx_cuisine_id` (`cuisine_id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb3 COMMENT='菜谱菜系关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe_cuisine`
--

LOCK TABLES `recipe_cuisine` WRITE;
/*!40000 ALTER TABLE `recipe_cuisine` DISABLE KEYS */;
INSERT INTO `recipe_cuisine` VALUES (111,5,2),(112,7,2),(113,11,2),(114,15,2),(115,16,2),(116,12,3),(117,17,3),(118,18,4),(119,19,5),(120,6,6),(121,14,6),(122,20,6),(123,21,7),(124,13,8),(125,22,8),(126,23,9),(127,8,10),(128,9,10),(129,10,10),(130,24,14),(131,25,15),(132,5,13),(133,6,13),(134,7,13);
/*!40000 ALTER TABLE `recipe_cuisine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '所属用户，0表示系统预设菜谱',
  `name` varchar(100) NOT NULL COMMENT '菜谱名称',
  `description` text COMMENT '描述',
  `ingredients` text COMMENT '所需食材（JSON格式或文本）',
  `steps` text COMMENT '制作步骤',
  `cook_time` int DEFAULT NULL COMMENT '烹饪时间（分钟）',
  `difficulty` enum('easy','medium','hard') DEFAULT 'medium' COMMENT '难度',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片路径',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否系统预设',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  FULLTEXT KEY `ft_name_description` (`name`,`description`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COMMENT='菜谱表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipes`
--

LOCK TABLES `recipes` WRITE;
/*!40000 ALTER TABLE `recipes` DISABLE KEYS */;
INSERT INTO `recipes` VALUES (5,0,'番茄炒蛋','经典家常菜，酸甜可口','[\"番茄 2个\", \"鸡蛋 3个\", \"盐 适量\", \"糖 适量\", \"葱花 少许\"]','[\"番茄洗净切块\", \"鸡蛋打散加盐\", \"热锅倒油炒鸡蛋盛出\", \"炒番茄出汁\", \"加入鸡蛋翻炒\", \"加糖盐调味\", \"撒葱花出锅\"]',15,'easy','/images/tomato_egg.jpg',1,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(6,0,'红烧肉','肥而不腻，入口即化','[\"五花肉 500g\", \"姜片 5片\", \"葱 2根\", \"八角 2个\", \"冰糖 20g\", \"生抽 2勺\", \"老抽 1勺\", \"料酒 1勺\"]','[\"五花肉切块焯水\", \"锅中放冰糖炒糖色\", \"加入五花肉翻炒上色\", \"加入姜葱八角\", \"加生抽老抽料酒\", \"加水没过肉块\", \"小火炖40分钟\", \"大火收汁\"]',60,'medium','/images/hongshaorou.jpg',1,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(7,0,'酸辣土豆丝','爽脆开胃的快手菜','[\"土豆 2个\", \"干辣椒 3个\", \"蒜 3瓣\", \"醋 1勺\", \"盐 适量\", \"青椒 1个\"]','[\"土豆切丝泡水去淀粉\", \"蒜切片青椒切丝\", \"热油爆香干辣椒蒜片\", \"加入土豆丝大火快炒\", \"加醋和盐调味\", \"加入青椒丝翻炒\", \"出锅前再淋少许醋\"]',10,'easy','/images/potato.jpg',1,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(8,1,'自制披萨','家庭版披萨，料足味美','[\"高筋面粉 200g\", \"酵母 3g\", \"披萨酱 3勺\", \"马苏里拉芝士 150g\", \"香肠 50g\", \"青椒 半个\", \"洋葱 半个\"]','[\"面粉加酵母揉成面团发酵\", \"擀成饼底扎孔\", \"涂披萨酱撒一层芝士\", \"铺香肠青椒洋葱\", \"再撒一层芝士\", \"200度烤15分钟\"]',45,'medium','/uploads/pizza.jpg',0,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(9,1,'懒人电饭煲焖饭','一锅出，超简单','[\"大米 2杯\", \"腊肠 2根\", \"土豆 1个\", \"胡萝卜 半根\", \"玉米粒 50g\", \"生抽 2勺\", \"蚝油 1勺\"]','[\"大米洗净放入电饭煲\", \"腊肠土豆胡萝卜切丁\", \"所有食材铺在米上\", \"加生抽蚝油和正常水量\", \"按煮饭键\", \"煮好拌匀即可\"]',30,'easy','/uploads/rice.jpg',0,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(10,2,'减肥鸡胸肉沙拉','低脂健康餐','[\"鸡胸肉 1块\", \"生菜 1颗\", \"圣女果 8个\", \"黄瓜 半根\", \"牛油果 半个\", \"油醋汁 适量\"]','[\"鸡胸肉用黑胡椒盐腌制\", \"煎熟切块\", \"生菜撕小片\", \"圣女果对切黄瓜切片\", \"所有食材混合\", \"淋油醋汁拌匀\"]',20,'easy','/uploads/salad.jpg',0,'2026-04-21 07:03:50','2026-04-21 07:03:50'),(11,0,'宫保鸡丁','麻辣鲜香，川菜经典代表菜，鸡肉嫩滑，花生酥脆','[\"鸡胸肉 300g\", \"花生米 50g\", \"干辣椒 8个\", \"花椒 20粒\", \"姜片 3片\", \"蒜瓣 3瓣\", \"葱白 2根\", \"生抽 2勺\", \"老抽 1勺\", \"醋 1勺\", \"白糖 1勺\", \"淀粉 1勺\", \"料酒 1勺\"]','[\"鸡胸肉切丁，加料酒、生抽、淀粉腌制15分钟\", \"调宫保汁：生抽2勺+老抽1勺+醋1勺+白糖1勺+淀粉1勺+清水2勺\", \"冷锅冷油下花生米，小火炸至微黄捞出\", \"热锅凉油，下花椒和干辣椒爆香\", \"加入姜蒜片炒香，倒入鸡丁滑炒至变色\", \"倒入宫保汁快速翻炒\", \"加入炸好的花生米和葱段\", \"大火收汁，翻炒均匀出锅\"]',25,'medium','/images/kungpao_chicken.jpg',1,'2026-05-14 06:01:37','2026-05-14 06:01:37'),(12,0,'白切鸡','粤菜经典，皮脆肉嫩，原汁原味','[\"三黄鸡 1只\", \"姜片 10片\", \"葱结 2个\", \"料酒 2勺\", \"沙姜 1块\", \"蒜末 3瓣\", \"生抽 3勺\", \"花生油 2勺\"]','[\"锅中加水烧开，放入姜片、葱结、料酒\", \"提着鸡头将鸡浸入开水中10秒，提起，重复3次\", \"将鸡完全浸入水中，小火保持微开状态煮15分钟\", \"关火焖20分钟\", \"捞出放入冰水中浸泡10分钟\", \"斩件装盘\", \"制作蘸料：沙姜末+蒜末+生抽+热花生油\"]',45,'medium','/images/white_cut_chicken.jpg',1,'2026-05-14 06:01:37','2026-05-14 06:01:37'),(13,0,'剁椒鱼头','湘菜经典，鲜辣开胃，肉质鲜嫩','[\"胖头鱼头 1个\", \"剁椒 150g\", \"姜末 15g\", \"蒜末 15g\", \"葱花 10g\", \"蒸鱼豉油 3勺\", \"料酒 2勺\", \"白胡椒粉 1勺\", \"热油 2勺\"]','[\"鱼头处理干净，从背部切开，抹上料酒和白胡椒粉腌制15分钟\", \"盘底铺姜片，放上鱼头\", \"剁椒+姜末+蒜末混合均匀铺在鱼头上\", \"淋上蒸鱼豉油\", \"上锅大火蒸12分钟\", \"撒上葱花，淋热油即可\"]',30,'medium','/images/fish_head.jpg',1,'2026-05-14 06:01:37','2026-05-14 06:01:37'),(14,0,'东坡肉','浙菜名菜，肥而不腻，酥烂如豆腐','[\"五花肉 500g\", \"绍兴黄酒 300ml\", \"酱油 4勺\", \"冰糖 40g\", \"姜片 10片\", \"葱结 2个\"]','[\"五花肉切3cm方块，冷水下锅焯水5分钟\", \"砂锅底铺姜片和葱结\", \"肉皮朝下码入锅中\", \"加入黄酒、酱油、冰糖\", \"大火烧开转小火慢炖1小时\", \"将肉翻面（皮朝上），再炖30分钟\", \"取出装盘，淋上汤汁\"]',90,'medium','/images/dongpo_pork.jpg',1,'2026-05-14 06:01:37','2026-05-14 06:01:37'),(15,0,'麻婆豆腐','川菜经典，麻辣鲜香，豆腐嫩滑','[\"嫩豆腐 400g\", \"猪肉末 100g\", \"豆瓣酱 2勺\", \"豆豉 1勺\", \"蒜末 15g\", \"姜末 10g\", \"葱花 10g\", \"花椒粉 1勺\", \"水淀粉 2勺\", \"生抽 1勺\"]','[\"豆腐切小块，盐水浸泡5分钟去豆腥\", \"热锅凉油，下肉末炒至变色\", \"加入豆瓣酱、豆豉、姜蒜末炒香\", \"加适量水煮开\", \"轻轻放入豆腐，煮3-5分钟\", \"淋入水淀粉勾芡\", \"撒花椒粉和葱花出锅\"]',20,'easy','/images/mapo_tofu.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(16,0,'鱼香肉丝','酸甜微辣，开胃下饭','[\"猪里脊肉 250g\", \"木耳 50g\", \"胡萝卜 50g\", \"青椒 1个\", \"豆瓣酱 1勺\", \"蒜末 10g\", \"姜末 5g\", \"葱花 10g\", \"醋 2勺\", \"糖 2勺\", \"生抽 1勺\", \"淀粉 1勺\"]','[\"猪肉切丝，加淀粉料酒腌制\", \"木耳、胡萝卜、青椒切丝\", \"调鱼香汁：醋+糖+生抽+淀粉+水\", \"热锅凉油滑炒肉丝至变色盛出\", \"炒香豆瓣酱和姜蒜\", \"加入配菜翻炒\", \"倒入肉丝和鱼香汁\", \"大火收汁撒葱花出锅\"]',25,'medium','/images/yuxiang_shredded_pork.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(17,0,'蜜汁叉烧','粤菜经典，甜咸适口，色泽红亮','[\"梅花肉 500g\", \"叉烧酱 3勺\", \"蜂蜜 2勺\", \"生抽 2勺\", \"老抽 1勺\", \"料酒 1勺\", \"蒜末 10g\", \"姜片 5片\"]','[\"梅花肉洗净，用叉子扎孔便于入味\", \"叉烧酱+生抽+老抽+料酒+蒜+姜调成腌料\", \"将肉放入腌料中腌制4小时以上\", \"烤箱预热200度\", \"肉放烤架上，刷蜂蜜\", \"烤20分钟翻面再刷蜂蜜\", \"再烤15分钟，取出切片\"]',50,'medium','/images/char_siu.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(18,0,'葱烧海参','鲁菜名菜，海参软糯，葱香浓郁','[\"水发海参 300g\", \"大葱 3根\", \"姜片 5片\", \"高汤 200ml\", \"生抽 2勺\", \"老抽 1勺\", \"料酒 1勺\", \"糖 1勺\", \"水淀粉 2勺\"]','[\"海参切长条，葱切段\", \"海参加姜片料酒焯水去腥\", \"热油爆香葱段至金黄捞出\", \"锅中留底油，加高汤、生抽、老抽、糖\", \"放入海参和炸过的葱段\", \"小火煨5分钟入味\", \"水淀粉勾芡，淋明油出锅\"]',30,'medium','/images/scallion_sea_cucumber.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(19,0,'松鼠桂鱼','苏菜经典，酸甜可口，造型美观','[\"桂鱼 1条\", \"番茄酱 3勺\", \"糖 3勺\", \"醋 2勺\", \"盐 适量\", \"淀粉 适量\", \"松子仁 20g\", \"青豆 20g\"]','[\"桂鱼处理干净，去骨留尾\", \"鱼肉切菱形花刀\", \"鱼身拍淀粉\", \"热油将鱼炸至金黄定型\", \"调汁：番茄酱+糖+醋+水煮开\", \"淋水淀粉勾芡\", \"将汁浇在鱼上\", \"撒松子仁和青豆\"]',40,'hard','/images/squirrel_fish.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(20,0,'西湖醋鱼','浙菜名菜，酸甜清香，鱼肉鲜嫩','[\"草鱼 1条\", \"姜末 15g\", \"糖 3勺\", \"醋 4勺\", \"生抽 2勺\", \"料酒 1勺\", \"水淀粉 2勺\"]','[\"鱼处理干净，沿脊骨剖开\", \"锅中水烧开，放入鱼煮8分钟\", \"捞出装盘\", \"锅中留鱼汤少许，加姜末、糖、醋、生抽\", \"煮开后勾芡\", \"将芡汁均匀浇在鱼上\"]',25,'medium','/images/west_lake_fish.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(21,0,'佛跳墙','闽菜之首，荤香浓郁，营养丰富','[\"鲍鱼 4只\", \"海参 2条\", \"鱼翅 50g\", \"干贝 20g\", \"花菇 4朵\", \"鸡肉 100g\", \"猪蹄 100g\", \"火腿 50g\", \"绍兴黄酒 200ml\", \"高汤 500ml\"]','[\"所有干货提前泡发\", \"肉类焯水去腥\", \"所有食材放入坛中\", \"加入黄酒和高汤\", \"荷叶封口，小火煨3小时\"]',240,'hard','/images/buddha_jumps_over_wall.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(22,0,'小炒黄牛肉','湘菜经典，香辣下饭，牛肉嫩滑','[\"黄牛肉 300g\", \"小米椒 5个\", \"杭椒 3个\", \"蒜末 15g\", \"姜末 10g\", \"香菜 20g\", \"生抽 2勺\", \"老抽 1勺\", \"淀粉 1勺\"]','[\"牛肉切薄片，加生抽老抽淀粉腌制\", \"辣椒切圈\", \"热油滑炒牛肉至变色盛出\", \"爆香姜蒜辣椒\", \"倒入牛肉快速翻炒\", \"加香菜段，翻炒均匀出锅\"]',15,'easy','/images/stir_fried_beef.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(23,0,'臭鳜鱼','徽菜名菜，闻臭吃香，肉质紧实','[\"鳜鱼 1条\", \"臭豆腐乳 3块\", \"姜片 10g\", \"蒜瓣 10g\", \"干辣椒 5个\", \"生抽 2勺\", \"老抽 1勺\", \"糖 1勺\"]','[\"鱼处理干净，表面划刀\", \"臭豆腐乳压碎涂抹鱼身腌制2小时\", \"热油煎鱼至两面金黄\", \"爆香姜蒜辣椒\", \"加生抽老抽糖和水\", \"放入鱼小火炖15分钟\"]',35,'medium','/images/stinky_mandarin_fish.jpg',1,'2026-05-14 12:48:08','2026-05-14 12:48:08'),(24,0,'戚风蛋糕','口感绵软，经典基础蛋糕','[\"鸡蛋 5个\", \"低筋面粉 90g\", \"玉米油 50g\", \"牛奶 50g\", \"细砂糖 80g\", \"柠檬汁 几滴\"]','[\"蛋白蛋黄分离\", \"蛋黄加玉米油牛奶拌匀\", \"筛入低粉拌匀\", \"蛋白加糖打发至干性发泡\", \"混合蛋白蛋黄糊\", \"倒入模具震出气泡\", \"150度烤50分钟\", \"倒扣冷却脱模\"]',60,'medium','/images/chiffon_cake.jpg',1,'2026-05-14 13:18:19','2026-05-14 13:18:19'),(25,0,'玉米排骨汤','清甜可口，营养丰富','[\"排骨 500g\", \"玉米 2根\", \"胡萝卜 1根\", \"姜片 5片\", \"盐 适量\", \"枸杞 10g\"]','[\"排骨焯水去血沫\", \"玉米胡萝卜切块\", \"所有材料放入砂锅\", \"加水没过食材\", \"大火烧开转小火炖1小时\", \"出锅前加盐调味\"]',70,'easy','/images/corn_rib_soup.jpg',1,'2026-05-14 13:18:19','2026-05-14 13:18:19');
/*!40000 ALTER TABLE `recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `title` varchar(100) NOT NULL COMMENT '标题',
  `type` enum('recipe','event','salary','bill','reminder') DEFAULT 'event' COMMENT '类型',
  `content` text COMMENT '内容详情',
  `related_id` int DEFAULT NULL COMMENT '关联ID（菜谱ID等）',
  `scheduled_date` date NOT NULL COMMENT '计划日期',
  `scheduled_time` time DEFAULT NULL COMMENT '计划时间',
  `priority` tinyint DEFAULT '1' COMMENT '优先级 1低 2中 3高',
  `is_completed` tinyint DEFAULT '0' COMMENT '是否完成',
  `reminder_minutes` int DEFAULT NULL COMMENT '提前提醒分钟数',
  `repeat_type` enum('none','daily','weekly','monthly','yearly') DEFAULT 'none' COMMENT '重复类型',
  `note` text COMMENT '备注',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_scheduled_date` (`scheduled_date`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COMMENT='日程表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,0,'发工资啦','salary','记得记录本月工资收入',NULL,'2026-05-15',NULL,2,0,60,'none',NULL,'2026-05-14 13:24:05','2026-05-14 13:24:05'),(2,0,'制作宫保鸡丁','recipe','尝试制作川菜经典宫保鸡丁',NULL,'2026-05-16',NULL,1,0,30,'none',NULL,'2026-05-14 13:24:05','2026-05-14 13:24:05'),(3,0,'交水电费','bill','本月水电费缴纳',NULL,'2026-05-20',NULL,3,0,120,'none',NULL,'2026-05-14 13:24:05','2026-05-14 13:24:05'),(4,0,'买菜','event','购买周末食材',NULL,'2026-05-17',NULL,2,0,60,'none',NULL,'2026-05-14 13:24:05','2026-05-14 13:24:05'),(5,1,'发工资啦','salary','记得记录本月工资收入',NULL,'2026-05-15','10:00:00',2,0,60,'none','工资日','2026-05-25 05:20:34','2026-05-25 05:52:43'),(6,1,'制作宫保鸡丁','recipe','尝试制作川菜经典宫保鸡丁',NULL,'2026-05-16','18:30:00',1,0,30,'none','需要买鸡胸肉','2026-05-25 05:20:34','2026-05-25 05:52:48'),(7,1,'交水电费','bill','本月水电费缴纳',NULL,'2026-05-20','09:00:00',3,0,120,'none','记得核对账单','2026-05-25 05:20:34','2026-05-25 05:20:34'),(8,1,'买菜','event','购买周末食材',NULL,'2026-05-17','08:00:00',2,0,60,'none','超市购物清单','2026-05-25 05:20:34','2026-05-25 05:20:34'),(9,1,'项目会议','event','讨论Q2项目进度',NULL,'2026-05-15','14:00:00',3,1,30,'none','准备汇报材料','2026-05-25 05:20:34','2026-05-25 06:01:40'),(10,1,'健身','reminder','去健身房锻炼',NULL,'2026-05-16','19:00:00',2,0,15,'weekly','带运动服','2026-05-25 05:20:34','2026-05-25 05:52:47'),(11,1,'看牙医','reminder','定期检查牙齿',NULL,'2026-05-18','10:30:00',1,0,120,'none','提前预约','2026-05-25 05:20:34','2026-05-25 05:20:34'),(12,1,'学习Android','event','学习Jetpack Compose',NULL,'2026-05-15','20:00:00',2,1,10,'daily','每天学习1小时','2026-05-25 05:20:34','2026-05-25 05:29:26'),(13,1,'买菜','event','购买周末食材',NULL,'2026-05-21','09:00:00',2,0,60,'weekly','周末采购','2026-05-25 05:20:34','2026-05-25 05:20:34'),(14,1,'提交报告','event','提交月度工作报告',NULL,'2026-05-22','17:00:00',3,0,180,'none','周五前完成','2026-05-25 05:20:34','2026-05-25 05:20:34');
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_favorite_recipes`
--

DROP TABLE IF EXISTS `user_favorite_recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_favorite_recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `recipe_id` int NOT NULL,
  `favorited_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_recipe` (`user_id`,`recipe_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `user_favorite_recipes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_favorite_recipes_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COMMENT='用户收藏菜谱表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorite_recipes`
--

LOCK TABLES `user_favorite_recipes` WRITE;
/*!40000 ALTER TABLE `user_favorite_recipes` DISABLE KEYS */;
INSERT INTO `user_favorite_recipes` VALUES (4,1,5,'2025-01-01 04:00:00'),(7,2,6,'2024-12-28 12:00:00');
/*!40000 ALTER TABLE `user_favorite_recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '加密密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像路径',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2b$10$qXqrqmnJZy0ojig1kanvl.RMWOCUY6Z/4n0OayaOm/O9vJA9q/Sqa','test@example.com',NULL,'2026-04-15 01:29:25','2026-04-21 07:42:43'),(2,'张三','$2a$10$YourHashedPasswordHere','zhangsan@example.com','/avatars/zhangsan.jpg','2026-04-21 07:02:21','2026-04-21 07:03:30'),(3,'李四','$2a$10$YourHashedPasswordHere','lisi@example.com','/avatars/lisi.jpg','2026-04-21 07:02:21','2026-04-21 07:03:44');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'accountingapp'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-21 19:34:22
