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
- **Implementação Estrutural**:
  - Descrição puramente estrutural através de equações booleanas dos mintermos ($m_0 \dots m_{15}$) com portas lógicas AND/NOT, eliminando qualquer descrição comportamental algorítmica.

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
- **Implementação Estrutural**:
  - Instancia o somador Ripple Carry de 8 bits [`somador8.v`](../somador8.v) encadeando 8 módulos [`full_adder.v`](../full_adder.v).
  - Executa as operações aritméticas de soma ($X + Y$) e negação em complemento de 2 ($-X = \sim X + 1$).
  - As operações lógicas (AND, OR, NOT) são geradas em paralelo por vias estruturais.
  - O resultado final é roteado através do multiplexador estrutural [`mux8_8to1.v`](../mux8_8to1.v) controlado pelo barramento `selUAL[2:0]`.
  - Flags de status $N = out[7]$ e $Z = \sim(|out)$ derivadas estruturalmente.

### 2. Conversor Binário para 7 Segmentos (`hex_to_7seg.v`)
- **Implementação Estrutural**:
  - Implementado integralmente através das equações booleanas minimizadas de cada segmento ($a, b, c, d, e, f, g$) via Mapas de Karnaugh para anodo comum (ativo baixo).

### 3. Integração ULA e Displays (`etapa3_ula_display.v`)
- Conecta a ULA estrutural aos dois decodificadores de 7 segmentos:
  - `dec_hex1`: Exibe `out[7:4]` em `HEX1`.
  - `dec_hex0`: Exibe `out[3:0]` em `HEX0`.

---

## Etapa IV: Program Counter (PC) e Divisor de Frequência

Compreende o subsistema de sequenciamento e controle de passo:

### 1. Contador de Programa de 8 bits (`pc_neander.v`)
- **Implementação Estrutural**:
  - Instancia um somador [`somador8.v`](../somador8.v) configurado como incrementador ($PC + 1$).
  - Instancia o módulo sequencial [`registrador8b.v`](../registrador8b.v) com carga síncrona e reset assíncrono.
  - Multiplexador estrutural seleciona entre manter o valor atual, carregar novo endereço de salto (`cargaPC`) ou avançar (`incrementaPC`).
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
