# INF01086 2026/2 - Projeto Final: Processador Neander (Checkpoint 16/10)

Aqui está o guia passo a passo completo para verificar o projeto no **Quartus II**, carregar o arquivo compilado na placa **Altera DE0 (Cyclone III EP3C16F484C6)** e realizar todos os testes práticos na bancada correspondentes às Etapas I a IV (Checkpoint de 16/10).

> 📖 **Documentação Completa da Arquitetura**: A documentação detalhada da microarquitetura Neander, tabelas de controle, equações booleanas completas, testbenches e pinout da DE0 está disponível na pasta [`docs/`](docs/) e publicada via GitHub Pages.

---

### 1. Como Verificar Tudo no Quartus II

1. **Abrir o Projeto**:
   - Abra o Quartus II 13.0 SP1.
   - Acesse **File > Open Project** e selecione o arquivo [`ProjetoFinal.qpf`](ProjetoFinal.qpf).

2. **Verificar os Relatórios de Compilação**:
   - Na aba **Tasks**, dê duplo clique em **Compilation Report** (ou abra pelo menu lateral).
   - Verifique os seguintes sumários gerados:
     - **Flow Summary**: Confirme o status *Successful*, o dispositivo `EP3C16F484C6` e o consumo de **120 Logic Elements** (< 1%) e **52 pinos**.
     - **Fitter > Pin-Out File**: Confirme que os pinos de `CLOCK_50`, `BUTTON`, `SW`, `LEDG`, `HEX0`, `HEX1`, `HEX2` e `HEX3` foram atribuídos conforme configurado no [`ProjetoFinal.qsf`](ProjetoFinal.qsf).

3. **Inspecionar a Arquitetura no RTL Viewer**:
   - Acesse **Tools > Netlist Viewers > RTL Viewer**.
   - Você verá os blocos integrados das 4 etapas:
     - `decoder_inst` ([`decoder_neander.v`](decoder_neander.v))
     - `cod_ula_inst` ([`codificador_ula.v`](codificador_ula.v))
     - `ula_disp_inst` ([`etapa3_ula_display.v`](etapa3_ula_display.v))
     - `pc_disp_inst` ([`etapa4_pc_divisor.v`](etapa4_pc_divisor.v))

4. **Conferir o Mapeamento de Pinos no Pin Planner**:
   - Acesse **Assignments > Pin Planner**.
   - Verifique graficamente se os pinos de I/O estão posicionados nos bancos corretos do chip `EP3C16F484C6`.

---

### 2. Como Subir o Firmware na Placa DE0

1. **Conexão Física da Placa**:
   - Conecte a fonte de alimentação de 7.5V na entrada DC da placa DE0.
   - Conecte o cabo USB entre o computador e o conector **USB Blaster** da placa.
   - Pressione o botão vermelho **POWER ON/OFF** da placa (o LED azul de power deve acender).
   - Certifique-se de que a chave seletora **RUN/PROG** da placa (ao lado dos displays) esteja na posição **RUN** (modo normal de operação JTAG).

2. **Abrir o Gravador (Programmer)**:
   - No menu do Quartus II, clique em **Tools > Programmer** (ou no ícone correspondente na barra de ferramentas).

3. **Configurar o Hardware de Gravação**:
   - No canto superior esquerdo da janela do Programmer, clique no botão **Hardware Setup...**.
   - No menu suspenso *Currently selected hardware*, selecione **USB-Blaster [USB-0]** e clique em **Close**.
     *(Se não aparecer, certifique-se de que o driver Altera USB-Blaster está instalado em seu Windows).*
   - No campo **Mode**, certifique-se de que está selecionado **JTAG**.

4. **Selecionar e Gravar o Arquivo `.sof`**:
   - Caso o arquivo não apareça na lista central, clique em **Add File...**, navegue até a pasta `output_files/` e selecione o arquivo [`output_files/ProjetoFinal.sof`](output_files/ProjetoFinal.sof).
   - O dispositivo associado na lista deve ser o **EP3C16**.
   - Marque a caixa de seleção **Program/Configure**.
   - Clique no botão **Start** no canto esquerdo.
   - Acompanhe a barra **Progress**: ao atingir **100% (Successful)**, o circuito estará gravado e rodando na FPGA.

---

### 3. Roteiro de Testes para Realizar na Placa

Os testes a seguir validam diretamente os requisitos do Checkpoint de 16/10 (Etapas I a IV):

```
+---------------------------------------------------------------------------------+
|                       DISPLAYS DE 7 SEGMENTOS                                   |
|   [ HEX3 ] [ HEX2 ]             [ HEX1 ] [ HEX0 ]                               |
|   PC Alto  PC Baixo             ULA Alto ULA Baixo                              |
|                                                                                 |
|   LEDS:                                                                         |
|   LEDG0: Flag N (Negativo)      LEDG3: LDA Ativo          LEDG9..7: selUAL      |
|   LEDG1: Flag Z (Zero)          LEDG4: ADD Ativo          LEDG2: Clock Efetivo  |
|   LEDG5: HLT Ativo                                                              |
|                                                                                 |
|   CHAVES / BOTÕES:                                                              |
|   SW[0]: 1=RUN / 0=DEBUG (Passo a passo)                                        |
|   SW[7:4]: Opcode do Neander (RI[7:4])                                          |
|   SW[3:0]: Operando Y da ULA                                                    |
|   BUTTON[0]: Reset Geral (Ativo Baixo)                                          |
|   BUTTON[1]: Step Up (Modo Debug)                                               |
+---------------------------------------------------------------------------------+
```

#### Teste 1: Reset Geral do Sistema
- **Ação**: Pressione e solte `BUTTON[0]`.
- **Resultado Esperado**:
  - Os displays `HEX3` e `HEX2` (PC) devem zerar exibindo `00`.
  - As flags e estados voltam para o valor padrão de inicialização.

#### Teste 2: Etapa IV (PC e Divisor de Frequência - Modo RUN e DEBUG)
- **Modo RUN Automático**:
  - Coloque a chave `SW[0]` para cima (`1`).
  - **Resultado**: O `LEDG[2]` começará a piscar com o clock lento (~2 Hz gerado pelo divisor) e os displays `HEX3` e `HEX2` começarão a contar automaticamente em hexadecimal: `00`, `01`, `02`, ..., `0F`, `10`, etc.
- **Modo DEBUG (Passo a Passo Manual)**:
  - Mude a chave `SW[0]` para baixo (`0`).
  - **Resultado**: A contagem automática é congelada imediatamente.
  - Pressione o botão `BUTTON[1]` uma vez e solte: o PC avançará exatamente um valor no display (`HEX3` e `HEX2`) a cada pressão.

#### Teste 3: Etapa I (Decodificador de Instruções do Neander)
Com o sistema operando, teste os opcodes colocando os 4 bits da instrução nas chaves `SW[7:4]`:
1. **Instrução NOP (`0000`)**:
   - `SW[7:4] = 0 0 0 0` -> Nenhum LED de instrução aceso.
2. **Instrução LDA (`0010`)**:
   - `SW[7:4] = 0 0 1 0` -> O LED `LEDG[3]` acende; os LEDs de controle da ULA `LEDG[9:7]` indicam `000` (operação Y).
3. **Instrução ADD (`0011`)**:
   - `SW[7:4] = 0 0 1 1` -> O LED `LEDG[4]` acende; `LEDG[9:7]` indicam `001` (operação ADD).
4. **Instrução HLT (`1111`)**:
   - `SW[7:4] = 1 1 1 1` -> O LED `LEDG[5]` acende (sinal HLT ativado).

#### Teste 4: Etapas II e III (Codificador ULA, ULA e Displays de 7 Segmentos)
- **Visualização da Saída**: O resultado das operações da ULA é visualizado em tempo real nos displays `HEX1` (nibble mais significativo) e `HEX0` (nibble menos significativo).
- **Variação de Operandos**:
  - Altere as chaves `SW[3:0]` e observe o dígito correspondente mudar no display `HEX0`.
- **Verificação das Flags**:
  - **Flag Zero (`LEDG[1]`)**: Quando a saída da ULA for `00`, o LED `LEDG[1]` deve acender.
  - **Flag Negativo (`LEDG[0]`)**: Se a operação gerar um valor negativo em complemento de 2 (bit mais significativo em 1, ou seja, valores de `80` a `FF`), o LED `LEDG[0]` deve acender.

---

### Estrutura de Diretórios do Repositório

```text
├── moodle_docs/                 # Documentos de especificação e roteiros originais (PDFs, PNG)
├── docs/                        # Documentação técnica completa estruturada para GitHub Pages
│   ├── _config.yml              # Configuração Jekyll do GitHub Pages
│   ├── index.md                 # Página inicial e índice geral do projeto
│   ├── arquitetura.md           # Microarquitetura do Neander, 11 opcodes, ciclos de busca/execução
│   ├── etapas.md                # Descrição detalhada das Etapas I, II, III e IV
│   ├── equacoes_controle.md     # Tabelas verdade e equações booleanas completas
│   ├── simulacao_testbenches.md # Testbenches ModelSim e casos de teste
│   └── pinout_de0.md            # Mapeamento e pinout completo da placa Altera DE0
├── output_files/
│   └── ProjetoFinal.sof         # Arquivo binário compilado para carga na FPGA
├── ProjetoFinal.qpf             # Arquivo de Projeto do Quartus II 13.0 SP1
├── ProjetoFinal.qsf             # Configurações de Fitter, pinagem e assignments
├── ProjetoFinal.v               # Módulo top-level integrador
├── decoder_neander.v            # Etapa I: Decodificador de instruções
├── codificador_ula.v            # Etapa II: Codificador de operações da ULA
├── ula_neander.v                # Etapa III: Unidade Lógica e Aritmética
├── hex_to_7seg.v                # Etapa III: Decodificador binário para 7 segmentos
├── etapa3_ula_display.v         # Etapa III: Top-level ULA + Displays
├── clock_divider.v              # Etapa IV: Divisor de frequência 50MHz -> ~2Hz
├── run_step_ctrl.v              # Etapa IV: Multiplexador de controle RUN / DEBUG
├── pc_neander.v                 # Etapa IV: Contador de Programa de 8 bits
├── etapa4_pc_divisor.v          # Etapa IV: Top-level PC + Divisor + Displays
├── ROM_teste.vhd                # Memória ROM com programa teste do Neander
├── *.bsf                        # Símbolos esquemáticos gerados pelo Quartus II
└── tb_*.v                       # Testbenches de verificação de cada bloco
```
