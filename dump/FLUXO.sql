-- --------------------------------------------------------
-- Servidor:                     localhost
-- Versão do servidor:           10.8.3-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para fluxo_caixa
DROP DATABASE IF EXISTS `fluxo_caixa`;
CREATE DATABASE IF NOT EXISTS `fluxo_caixa` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fluxo_caixa`;

-- Copiando dados para a tabela fluxo_caixa.contas: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `contas` DISABLE KEYS */;
INSERT INTO `contas` (`id_conta`, `descricao`, `banco`, `agencia`, `conta`) VALUES
	(1, 'CONTA BANCO DO BRASIL', '001', '1234', '1234-5'),
	(2, 'SANTANDER', '', '', '');
/*!40000 ALTER TABLE `contas` ENABLE KEYS */;

-- Copiando dados para a tabela fluxo_caixa.lancamentos: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `lancamentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `lancamentos` ENABLE KEYS */;

-- Copiando dados para a tabela fluxo_caixa.planos: ~14 rows (aproximadamente)
/*!40000 ALTER TABLE `planos` DISABLE KEYS */;
INSERT INTO `planos` (`id_plano`, `descricao`, `tipo`) VALUES
	(1, 'SALDO INICIAL', 'C'),
	(2, 'SALDO INICIAL NEG', 'D'),
	(3, 'SALARIO', 'C'),
	(4, 'PGTO MECANICO MOTO', 'D'),
	(5, 'TESTE DE INCLUSAO 2', 'C'),
	(6, 'CONTA DE ENERGIA CPFL X', 'D'),
	(7, 'CONTA AGUA E ESGOTO', 'D'),
	(9, 'PGTO MECANICO CARRO', 'D'),
	(10, 'TESTE 51', 'C'),
	(11, 'TESTE DE INCLUSAO 13082022', 'D'),
	(13, 'TESTE TESTE', 'C'),
	(14, 'JOSE TESTE', 'C'),
	(15, 'TESTE', 'C'),
	(19, 'TESTE JOAO', 'C');
/*!40000 ALTER TABLE `planos` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
