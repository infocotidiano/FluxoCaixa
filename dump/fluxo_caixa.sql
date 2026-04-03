-- MariaDB dump 10.19  Distrib 10.9.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: fluxo_caixa
-- ------------------------------------------------------
-- Server version	10.9.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `contas`
--

DROP TABLE IF EXISTS `contas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contas` (
  `id_conta` int(11) NOT NULL,
  `descricao` varchar(80) NOT NULL,
  `banco` varchar(20) DEFAULT NULL,
  `agencia` varchar(15) DEFAULT NULL,
  `conta` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id_conta`),
  KEY `idx_conta_desc` (`descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entidades`
--

DROP TABLE IF EXISTS `entidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entidades` (
  `id_entidade` int(11) NOT NULL,
  `nome` varchar(80) NOT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_entidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lancamentos`
--

DROP TABLE IF EXISTS `lancamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lancamentos` (
  `conta` int(11) NOT NULL,
  `id_lcto` int(11) NOT NULL,
  `data_mvto` date NOT NULL,
  `plano` int(11) NOT NULL,
  `descricao` varchar(180) DEFAULT NULL,
  `valor` decimal(15,2) DEFAULT NULL,
  `idbanco` varchar(36) DEFAULT NULL,
  `idReceber` int(11) DEFAULT NULL,
  `idPagar` int(11) DEFAULT NULL,
  PRIMARY KEY (`conta`,`data_mvto`,`id_lcto`),
  KEY `fk_lcto_plano` (`plano`),
  CONSTRAINT `fk_lcto_conta` FOREIGN KEY (`conta`) REFERENCES `contas` (`id_conta`) ON UPDATE NO ACTION,
  CONSTRAINT `fk_lcto_plano` FOREIGN KEY (`plano`) REFERENCES `planos` (`id_plano`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pagar`
--

DROP TABLE IF EXISTS `pagar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagar` (
  `id_pagar` int(11) NOT NULL,
  `descricao` varchar(180) DEFAULT NULL,
  `dtlancamento` date DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `dtvencimento` date DEFAULT NULL,
  `valorpago` decimal(10,2) DEFAULT NULL,
  `situacao` char(1) DEFAULT NULL,
  `plano` int(11) DEFAULT NULL,
  `dtrecebimento` date DEFAULT NULL,
  `codconta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_pagar`),
  KEY `plano` (`plano`),
  CONSTRAINT `pagar_ibfk_1` FOREIGN KEY (`plano`) REFERENCES `planos` (`id_plano`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `planos`
--

DROP TABLE IF EXISTS `planos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planos` (
  `id_plano` int(11) NOT NULL,
  `descricao` varchar(80) NOT NULL,
  `tipo` char(1) DEFAULT NULL,
  PRIMARY KEY (`id_plano`),
  KEY `idx_plano_desc` (`descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `receber`
--

DROP TABLE IF EXISTS `receber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `receber` (
  `id_receber` int(11) NOT NULL,
  `descricao` varchar(180) DEFAULT NULL,
  `dtlancamento` date DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `dtvencimento` date DEFAULT NULL,
  `valorrecebido` decimal(10,2) DEFAULT NULL,
  `situacao` char(1) DEFAULT NULL,
  `plano` int(11) DEFAULT NULL,
  `dtrecebimento` date DEFAULT NULL,
  `codconta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_receber`),
  KEY `plano` (`plano`),
  CONSTRAINT `receber_ibfk_1` FOREIGN KEY (`plano`) REFERENCES `planos` (`id_plano`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teste`
--

DROP TABLE IF EXISTS `teste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teste` (
  `col1` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) DEFAULT NULL,
  `senha` varbinary(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-05  9:20:39
