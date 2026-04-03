# fluxoCaixa

Projeto Fluxo de Caixa.

Sistema desktop de controle de fluxo de caixa desenvolvido em Lazarus/Free Pascal, com persistencia em MariaDB.

Criado em Lazarus FPC (Free Pascal Compiler).

## Fontes do projeto

Fontes dos videos da playlist do YouTube:

- https://www.youtube.com/playlist?list=PLiLrXujC4CW2lGeq1YeDbIcxbUP1W94QL

## Dependencias externas

Os componentes abaixo aparecem no projeto e precisam estar instalados no Lazarus para abrir os formularios e compilar sem erros.

| Componente | Pacote no projeto | Onde e usado | Instalacao |
| --- | --- | --- | --- |
| ZeosLib | `zcomponent`, `zcomponentdesign`, `lr_zeosdb` | Conexao com banco via `TZConnection` e consultas `TZQuery` | Instalar separadamente ou pelo Online Package Manager |
| RxLib / Rx New | `rxnew` | `TRxMemoryData`, `TRxDBGrid`, `TCurrencyEdit`, `rxtooledit` | Instalar separadamente ou pelo Online Package Manager |
| ACBr | `ACBr_OFX`, `ACBrDiversos` | Importacao OFX (`TACBrOFX`), `TACBrEnterTab` e funcoes utilitarias `ACBrUtil` | Instalar separadamente |
| LazReport | `lazreport` | Estrutura de relatorios com `LR_Class` e `LR_DBSet` | Normalmente disponivel no Lazarus, mas pode exigir instalacao do pacote |
| Integracao LazReport + Zeos | `lr_zeosdb` | Suporte a datasets Zeos em relatorios | Instalar junto com Zeos/LazReport |
| Fortes Report / RLReport | `frce` | Relatorio em `relatorios/urel_movimento.*` com componentes `TRLReport` | Instalar separadamente |
| PowerPDF | `pack_powerpdf` | Dependencia do ecossistema de relatorio usado pelo projeto | Instalar separadamente quando o pacote nao vier junto |

## Pacotes nativos do Lazarus/FPC

Estes pacotes tambem aparecem no arquivo do projeto, mas normalmente ja fazem parte da instalacao padrao do Lazarus/FPC:

- `LCL`
- `FCL`
- `DateTimeCtrls`
- `DateTimeCtrlsDsgn`

## Evidencias no projeto

Alguns pontos onde as dependencias externas sao usadas:

- `view/importa.pas`: usa `ACBrOFX`, `ACBrEnterTab`, `rxmemds` e `RxDBGrid`.
- `conexao/utabela.pas`: usa `ZConnection` (`TZConnection`).
- `view/umovimento.pas`: usa `ZDataset`, `rxcurredit`, `PReport`, `LR_Class` e `LR_DBSet`.
- `relatorios/urel_movimento.pas`: usa `RLReport` e `RLParser`.
- `fluxocaixa.lpi`: lista os pacotes requeridos pelo projeto.

## Banco de dados

O projeto esta configurado para usar MariaDB/MySQL via Zeos.

- Protocolo configurado: `mariadb`
- Cliente nativo no Windows: `libmariadb.dll`
- Arquivos de exemplo: `fluxocaixa.ini`, `fluxocaixa_linux.ini`

No diretório `dump` existe um backup do esquema do banco sem dados (somente estruturas), que deve ser restaurado em uma base chamada `fluxo_caixa`.

Os dados de conexao nao ficam fixos no sistema. Servidor, porta, usuario, senha e banco podem ser informados pelo usuario na tela de configuracao da conexao com o banco de dados, conforme o ambiente utilizado.

No Windows, a DLL cliente do MariaDB precisa estar acessivel. O repositorio ja possui copias em:

- `MariaDbDLL/x32/libmariadb.dll`
- `MariaDbDLL/x64/libmariadb.dll`

## Como instalar os componentes

Opcao 1: Online Package Manager do Lazarus

1. Abrir o Lazarus.
2. Ir em `Package -> Online Package Manager`.
3. Procurar e instalar os pacotes disponiveis, especialmente:
   `Zeos`, `Rx`, `LazReport` e pacotes relacionados.
4. Recompilar a IDE quando solicitado.

Opcao 2: Instalacao manual

1. Baixar os fontes dos projetos externos.
2. Abrir os arquivos `.lpk` correspondentes no Lazarus.
3. Escolher `Use -> Install`.
4. Recompilar a IDE.

## Instalacao do ACBr

Referencia em video para instalacao do ACBr:

- https://youtu.be/aiytLfagvXU?si=HoIQ9IDFRpfCSMIj

## Instalacao de fontes no Debian e derivados

Para evitar problemas com fontes usadas em relatorios e formularios, instalar:

```bash
sudo apt install ttf-mscorefonts-installer
```

## Observacoes

- O projeto referencia `ACBr_OFX`, portanto nao basta somente instalar um pacote generico do ACBr: o modulo de OFX precisa estar disponivel.
- O relatorio principal usa `RLReport`, entao somente `LazReport` nao cobre todas as dependencias de relatorio deste projeto.
- Se algum formulario abrir com componente faltando, confira primeiro se todos os pacotes listados em `fluxocaixa.lpi` foram instalados na IDE.

**Aviso importante:**

- Os fontes disponibilizados são dos videos da playlist do youtube para fim aprendizagem.
- Testado no Windows e Linux (Ubuntu e Pop!_OS).
- Não há qualquer tipo de garantia de funcionamento ou suporte do autor.
- O autor não se responsabiliza por perdas, danos ou qualquer tipo problema/ bugs ou falhas de comportamento.  