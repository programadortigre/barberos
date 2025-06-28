-- MySQL dump 10.13  Distrib 5.7.39, for Win64 (x86_64)
--
-- Host: localhost    Database: barberia
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `barberia`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barberia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barberia`;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('7b255e9186a3');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuraciones`
--

DROP TABLE IF EXISTS `configuraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuraciones` (
  `clave` varchar(100) NOT NULL,
  `valor` text NOT NULL,
  `descripcion` text,
  `tipo` enum('string','int','bool','json') NOT NULL DEFAULT 'string',
  `creado_por` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`clave`),
  KEY `creado_por` (`creado_por`),
  CONSTRAINT `configuraciones_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES ('clave3','s0','string','string',1,'2025-05-25 21:49:22'),('string','string','string','string',1,'2025-05-25 21:44:57');
/*!40000 ALTER TABLE `configuraciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_usuarios`
--

DROP TABLE IF EXISTS `logs_usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs_usuarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `accion` varchar(255) NOT NULL,
  `tabla_afectada` varchar(100) DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `descripcion` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `detalles_json` text,
  `user_agent` varchar(255) DEFAULT NULL,
  `navegador` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `logs_usuarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_usuarios`
--

LOCK TABLES `logs_usuarios` WRITE;
/*!40000 ALTER TABLE `logs_usuarios` DISABLE KEYS */;
INSERT INTO `logs_usuarios` VALUES (6,12,'2','33',33,'Acceso total al sistema. Puede gestionar usuarios, roles, configuraci├│n y ver todos los reportes y sistema de roles.','121','1233','1313','opera','2025-05-25 19:37:32');
/*!40000 ALTER TABLE `logs_usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfiles`
--

DROP TABLE IF EXISTS `perfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `perfiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `tipo_perfil_id` int NOT NULL,
  `datos_personalizados_json` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_perfiles_persona_tipo` (`persona_id`,`tipo_perfil_id`),
  KEY `tipo_perfil_id` (`tipo_perfil_id`),
  CONSTRAINT `perfiles_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`),
  CONSTRAINT `perfiles_ibfk_2` FOREIGN KEY (`tipo_perfil_id`) REFERENCES `tipos_perfil` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfiles`
--

LOCK TABLES `perfiles` WRITE;
/*!40000 ALTER TABLE `perfiles` DISABLE KEYS */;
INSERT INTO `perfiles` VALUES (2,5,1,'permi2','2025-05-20 23:18:24','2025-05-25 21:36:23'),(5,1,1,'aaaaaaaaaaa aaa','2025-05-25 21:39:24','2025-05-25 21:39:47');
/*!40000 ALTER TABLE `perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permisos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `descripcion` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clave` (`clave`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
INSERT INTO `permisos` VALUES (2,'modulo de usuarios','modulo-ventas','sistema de ventas','2025-05-20 22:50:24'),(6,'modul','admin-f','Solo accede a su agenda, historial de servicios y puede marcar trabajos realizados.','2025-05-20 22:51:29');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personas`
--

DROP TABLE IF EXISTS `personas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(20) NOT NULL,
  `dni` varchar(15) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellido_paterno` varchar(100) NOT NULL,
  `apellido_materno` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero` char(1) NOT NULL COMMENT 'M: Masculino, F: Femenino, O: Otro',
  `direccion_cifrada` blob,
  `telefono_cifrado` tinyblob,
  `correo_cifrado` blob,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`),
  KEY `idx_apellidos` (`apellido_paterno`,`apellido_materno`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personas`
--

LOCK TABLES `personas` WRITE;
/*!40000 ALTER TABLE `personas` DISABLE KEYS */;
INSERT INTO `personas` VALUES (1,'DNI','70202530','Gokusito','Kakarotto','Son','2005-09-30','O',_binary '912144',_binary '912144379',_binary 'aaaaaaa@gmail.com','2025-05-20 13:41:10','2025-05-25 21:13:09'),(2,'DNI','70393528','Luis fernando','castillo','gutierrez','2050-05-30','M',_binary 'centro comercial, Jir├│n Andahuaylas, Cercado de Lima, Per├║',_binary '912144379',_binary 'progradortigre@gmail.com','2025-05-20 14:00:54','2025-05-25 21:13:53'),(5,'DNI','12345678','LUIS','DAS','f','2025-05-20','F',_binary 'lima',_binary '912144372',_binary 'angel@gmail.com','2025-05-20 23:29:04','2025-05-20 23:29:04');
/*!40000 ALTER TABLE `personas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'ADMIN','Acceso total al sistema. Puede gestionar usuarios, roles, configuraci├│n y ver todos los reportes y sistema de roles.','2025-05-20 13:35:04','2025-05-20 14:23:01'),(3,'SUPERVISOR','Supervisa la operaci├│n diaria. Puede ver reportes, gestionar empleados y turnos.','2025-05-20 13:35:27','2025-05-20 13:35:27'),(4,'RECEPCIONISTA','Gestiona las reservas, registra clientes, atiende llamadas. Acceso limitado a usuarios y turnos.','2025-05-20 13:35:52','2025-05-20 13:35:52'),(5,'CAJERO','Acceso a caja diaria, ventas, cobros, boletas y facturas. No puede modificar usuarios.','2025-05-20 13:36:13','2025-05-20 13:36:13'),(6,'CLIENTE','Usuario externo con acceso limitado (puede agendar citas y revisar historial).','2025-05-20 13:36:31','2025-05-20 13:36:31'),(7,'BARBEROS','Solo accede a su agenda, historial de servicios y puede marcar trabajos realizados.','2025-05-20 13:37:09','2025-05-20 21:17:30'),(20,'fe','fernando','2025-05-25 20:47:58','2025-05-25 20:47:58');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permisos`
--

DROP TABLE IF EXISTS `roles_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_permisos` (
  `rol_id` int NOT NULL,
  `permiso_id` int NOT NULL,
  `creado_por` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rol_id`,`permiso_id`),
  KEY `creado_por` (`creado_por`),
  KEY `permiso_id` (`permiso_id`),
  CONSTRAINT `roles_permisos_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `roles_permisos_ibfk_2` FOREIGN KEY (`permiso_id`) REFERENCES `permisos` (`id`),
  CONSTRAINT `roles_permisos_ibfk_3` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permisos`
--

LOCK TABLES `roles_permisos` WRITE;
/*!40000 ALTER TABLE `roles_permisos` DISABLE KEYS */;
INSERT INTO `roles_permisos` VALUES (2,2,1,'2025-05-21 13:08:56'),(3,6,1,'2025-05-21 15:04:04'),(4,6,1,'2025-05-21 14:25:45'),(5,2,1,'2025-05-21 13:16:06'),(5,6,1,'2025-05-21 13:16:11'),(20,2,1,'2025-05-25 21:16:16');
/*!40000 ALTER TABLE `roles_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_perfil`
--

DROP TABLE IF EXISTS `tipos_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipos_perfil` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clave` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `campos_json` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_perfil`
--

LOCK TABLES `tipos_perfil` WRITE;
/*!40000 ALTER TABLE `tipos_perfil` DISABLE KEYS */;
INSERT INTO `tipos_perfil` VALUES (1,'admin-','prueba4','Solo accede a su agenda, historial de servicios y puede marcar trabajos realizados.','aaa','2025-05-20 23:18:14','2025-05-20 23:19:27');
/*!40000 ALTER TABLE `tipos_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens` (
  `token` varchar(36) NOT NULL,
  `usuario_id` int NOT NULL,
  `tipo_token` enum('access','refresh','api') DEFAULT NULL,
  `expiracion` datetime NOT NULL,
  `revocado` tinyint(1) NOT NULL,
  `revocado_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int NOT NULL,
  `estado` enum('activo','suspendido','eliminado') DEFAULT NULL,
  `ultimo_login` datetime DEFAULT NULL,
  `intentos_fallidos` int DEFAULT NULL,
  `api_key_hash` varchar(255) DEFAULT NULL,
  `api_key_expira` datetime DEFAULT NULL,
  `creado_por` int DEFAULT NULL,
  `modificado_por` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_id` (`persona_id`),
  UNIQUE KEY `ix_usuarios_username` (`username`),
  KEY `creado_por` (`creado_por`),
  KEY `modificado_por` (`modificado_por`),
  KEY `rol_id` (`rol_id`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `usuarios_ibfk_3` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`),
  CONSTRAINT `usuarios_ibfk_4` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,1,'admin','$2b$12$D934RFLr6F3oMo7UT4n4MOG2xarK2DLRQdL2p1Gpdn3L084w2nfuK',2,'activo',NULL,0,NULL,NULL,NULL,NULL,'2025-05-20 13:55:44','2025-06-01 20:14:31'),(12,2,'programador','$2b$12$mJW9JZXf51T/EOVQuUEUH.zKN7XExeOezVwAwFSXB/WOJj3eH0pNu',6,'activo',NULL,0,NULL,NULL,NULL,NULL,'2025-05-20 17:32:42','2025-05-25 20:34:44');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-18 11:27:43
