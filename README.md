# Fontes do projeto Fluxo de Caixa em Lazarus FPC

Sistema desktop de controle de fluxo de caixa desenvolvido em Lazarus/Free Pascal, com bando de dados MariaDB.

Criado em Lazarus FPC (Free Pascal Compiler).
  
## 🚀 Este projeto te ajudou?

Se esse conteúdo foi útil pra você, considere apoiar o canal 💛  

Isso ajuda a continuar produzindo mais conteúdos gratuitos e projetos como este.

### ☕ Apoie com um PIX (qualquer valor já ajuda!)
<p align="center">
<br>
  <img src="https://raw.githubusercontent.com/infocotidiano/infocotidiano/main/images/pixdane.jpeg" width="180"/>
</p>  

## 📺 Playlist completa no YouTube:

- https://www.youtube.com/playlist?list=PLiLrXujC4CW2lGeq1YeDbIcxbUP1W94QL

<img src="imagem/fluxocaixa.png" width="50%" alt="Fluxo Caixa">  

## Dependências externas

Os componentes abaixo aparecem no projeto e precisam estar instalados no Lazarus para abrir os formulários e compilar sem erros.

| Componente | Pacote no projeto | Onde é usado | Instalação |
| --- | --- | --- | --- |
| ZeosLib | `zcomponent`, `zcomponentdesign`, `lr_zeosdb` | Conexão com banco via `TZConnection` e consultas `TZQuery` | Instalar separadamente ou pelo Online Package Manager |
| RxLib / Rx New | `rxnew` | `TRxMemoryData`, `TRxDBGrid`, `TCurrencyEdit`, `rxtooledit` | Instalar separadamente ou pelo Online Package Manager |
| ACBr | `ACBr_OFX`, `ACBrDiversos` | Importação OFX (`TACBrOFX`), `TACBrEnterTab` e funções utilitárias `ACBrUtil` | Instalar separadamente |
| LazReport | `lazreport` | Estrutura de relatórios com `LR_Class` e `LR_DBSet` | Normalmente disponível no Lazarus, mas pode exigir instalação do pacote |
| Integração LazReport + Zeos | `lr_zeosdb` | Suporte a datasets Zeos em relatórios | Instalar junto com Zeos/LazReport |
| Fortes Report / RLReport | `frce` | Relatório em `relatorios/urel_movimento.*` com componentes `TRLReport` | Instalar separadamente https://github.com/fortesinformatica/fortesreport-ce |
| PowerPDF | `pack_powerpdf` | Dependência do ecossistema de relatórios usado pelo projeto | Instalar separadamente quando o pacote não vier junto |

## Evidências no projeto

Alguns pontos onde as dependências externas são utilizadas:

- `view/importa.pas`: usa `ACBrOFX`, `ACBrEnterTab`, `rxmemds` e `RxDBGrid`.
- `conexao/utabela.pas`: usa `ZConnection` (`TZConnection`).
- `view/umovimento.pas`: usa `ZDataset`, `rxcurredit`, `PReport`, `LR_Class` e `LR_DBSet`.
- `relatorios/urel_movimento.pas`: usa `RLReport` e `RLParser`.
- `fluxocaixa.lpi`: lista os pacotes requeridos pelo projeto.

## Banco de dados

O projeto está configurado para usar MariaDB/MySQL via Zeos.

- Protocolo configurado: `mariadb`
- Cliente nativo no Windows: `libmariadb.dll`
- Arquivos de exemplo: `fluxocaixa.ini`, `fluxocaixa_linux.ini`

No diretório `dump` existe um backup do esquema do banco.

### ⚠️ Atenção ao restaurar o banco

**Cuidado ao restaurar o arquivo `fluxo_caixa.sql`:**

- Você **perderá todos os dados já cadastrados**
- O script irá **sobrescrever sua base atual com dados de teste**

### Como restaurar com segurança

Se desejar utilizar a base de testes sem afetar seus dados atuais:

create database fluxo_caixa;

Depois execute:

mysql -uroot -p fluxo_caixa < fluxo_caixa.sql

O arquivo está na pasta:

dump/

## Configuração no Linux

No Linux, é necessário ter o MariaDB e o cliente instalados.

Instale com:

sudo apt update && sudo apt install mariadb-client

### 🎥 Tutorial de instalação MariaDB (Linux)

https://www.youtube.com/watch?v=KKosoq157_Y

## Cliente MariaDB no Windows

No Windows, a DLL cliente do MariaDB precisa estar acessível. O repositório já possui cópias em:

- MariaDbDLL/x32/libmariadb.dll
- MariaDbDLL/x64/libmariadb.dll

## Como instalar os componentes

### Opção 1: Online Package Manager do Lazarus

1. Abrir o Lazarus  
2. Ir em Package -> Online Package Manager  
3. Instalar:
   - Zeos  
   - Rx  
   - LazReport  
4. Recompilar a IDE  

### Opção 2: Instalação manual

1. Baixar os fontes dos projetos externos  
2. Abrir os .lpk no Lazarus  
3. Use -> Install  
4. Recompilar a IDE  

## Instalação do ACBr

Referência em vídeo:

https://youtu.be/aiytLfagvXU?si=HoIQ9IDFRpfCSMIj

## Instalação de fontes no Debian e derivados

sudo apt install ttf-mscorefonts-installer

## Observações

- O projeto utiliza ACBr_OFX, portanto esse módulo deve estar disponível  
- O relatório principal usa RLReport, então apenas o LazReport não cobre tudo  
- Se houver erro de componente, verifique os pacotes do fluxocaixa.lpi  

## Aviso importante

- Projeto com fins educacionais (baseado na playlist)  
- Testado no Windows e Linux  
- Sem garantia de funcionamento ou suporte  
- O autor não se responsabiliza por perdas de dados ou problemas
