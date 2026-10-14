---
layout: default
title: "Etapas do Checkpoint 16/10"
---

# Detalhamento das Etapas I a IV (Checkpoint 16/10)

O cronograma da disciplina estabelece o Checkpoint de 16/10 com a entrega das primeiras 4 etapas completas e validadas:

```
[Etapa I: Decodificador] ---> [Etapa II: Codificador ULA] ---> [Etapa III: ULA + Displays]
                                                                      |
[Etapa IV: PC + Divisor + Controle RUN/STEP] ------------------------+
                                                                      v
                                                            [ProjetoFinal Top-Level]
```

---

## Etapa I: Decodificador de Instruções (`decoder_neander.v`)

O módulo decodifica o código de operação de 4 bits `ri[3:0]` (correspondente aos bits `RI[7:4]` da instrução) em 11 sinais de controle ativos em nível alto (`1`):

- **Entrada**:
  - `ri[3:0]`: Nibble superior da instrução.
- **Saídas (1 bit cada)**:
  - `nop`, `sta`, `lda`, `add`, `or_op`, `and_op`, `not_op`, `jmp`, `jn`, `jz`, `hlt`.
- **Implementação**:
  - Bloco combinacional `always @(*)` com instrução `case (ri)`.
  - Garantia de inicialização em zero de todas as saídas no início do bloco para evitar a síntese de latches indesejados.

---

## Etapa II: Codificador de Operações da ULA (`codificador_ula.v`)

Converte os sinais de instrução aritmética/lógica do Neander nas linhas de controle de operação da Unidade Lógica e Aritmética (`selUAL[2:0]`):

- **Entradas**:
  - `lda`, `add`, `or_op`, `and_op`, `not_op`, `neg`.
- **Saídas**:
  - `selUAL[2:0]`: Barramento de seleção de função da ULA.
- **Tabela de Codificação**:
  - `lda = 1` $\implies$ `selUAL = 3'b000` (passagem de Y para carga em AC)
  - `add = 1` $\implies$ `selUAL = 3'b001` (soma: $X + Y$)
  - `or_op = 1` $\implies$ `selUAL = 3'b010` (OU lógico: $X \lor Y$)
  - `and_op = 1` $\implies$ `selUAL = 3'b011` (E lógico: $X \land Y$)
  - `not_op = 1` $\implies$ `selUAL = 3'b100` (Inversão: $\sim X$)
  - `neg = 1` $\implies$ `selUAL = 3'b101` (Negação em comp. de 2: $-X$)
  - Nenhuma ativa $\implies$ `selUAL = 3'b000` (valor seguro padrão)

---

## Etapa III: ULA Neander e Displays de 7 Segmentos

Compreende três submódulos integrados:

### 1. Unidade Lógica e Aritmética (`ula_neander.v`)
- **Entradas**:
  - `X[7:0]`: Operando vindo do Acumulador (AC).
  - `Y[7:0]`: Operando vindo da Memória (RDM / Chaves na bancada).
  - `selUAL[2:0]`: Código da operação da ULA.
- **Saídas**:
  - `saida[7:0]`: Resultado da operação de 8 bits.
  - `flag_n`: Flag de resultado negativo ($saida[7]$).
  - `flag_z`: Flag de resultado zero ($saida == 8'b0$).
- **Detecção das Flags**:
  - Cálculo simultâneo com atribuição contínua (`assign flag_n = saida[7]; assign flag_z = (saida == 8'h00);`).

### 2. Conversor Binário para 7 Segmentos (`hex_to_7seg.v`)
- **Entrada**: `hex[3:0]` (dígito hexadecimal de 0 a F).
- **Saída**: `seg[6:0]` (segmentos de `a` até `g`, catodos/anodos ativos em nível `0`).
- **Padrão Altera DE0**: Displays de anodo comum onde `0` liga o segmento e `1` desliga.

### 3. Integração ULA e Displays (`etapa3_ula_display.v`)
- Conecta a ULA a dois conversores de 7 segmentos:
  - `disp_high`: Converte `saida[7:4]` para `hex1`.
  - `disp_low`: Converte `saida[3:0]` para `hex0`.
- Exporta o resultado nos displays e as flags em LEDs para observação imediata.

---

## Etapa IV: Program Counter (PC) e Divisor de Frequência

Compreende o subsistema de sequenciamento e controle de passo:

### 1. Contador de Programa de 8 bits (`pc_neander.v`)
- **Entradas**:
  - `clk`: Sinal de relógio de disparo.
  - `reset`: Reset assíncrono (ativo alto).
  - `pc_inc`: Habilitação de incremento ($PC \leftarrow PC + 1$).
  - `pc_load`: Habilitação de carga paralela ($PC \leftarrow data\_in$).
  - `data_in[7:0]`: Valor para salto incondicional/condicional.
- **Saída**:
  - `pc_out[7:0]`: Valor atual do contador.

### 2. Divisor de Frequência (`clock_divider.v`)
- Reduz a frequência base do oscilador de 50 MHz da placa para aproximadamente **2 Hz** (visível a olho nu na bancada).
- **Equação**:
  $$Módulo = \frac{50.000.000}{2 \times 2} = 12.500.000 \text{ pulsos por semiciclo}$$
- Contador interno de 24 bits (`reg [23:0] counter`) que inverte a saída `clk_out` a cada $12.500.000$ ciclos.

### 3. Controlador RUN / STEP (`run_step_ctrl.v`)
- Permite alternar entre execução contínua e passo a passo manual:
  - `run_mode = 1` (Chave `SW[0]` para cima): O clock efetivo é o clock lento gerado pelo divisor (~2 Hz).
  - `run_mode = 0` (Chave `SW[0]` para baixo): O clock efetivo é disparado manualmente pelo botão de pulso `step_btn` (`BUTTON[1]`), através de um detector de borda de descida com sincronização por flip-flop.

### 4. Integração Top-Level da Etapa IV (`etapa4_pc_divisor.v`)
- Conecta o divisor, o controlador de passo e o PC.
- Exibe o valor do PC nos displays `HEX3` (`pc_out[7:4]`) e `HEX2` (`pc_out[3:0]`).
- Fornece a indicação visual de pulso de clock no LED `LEDG[2]`.
