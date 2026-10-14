---
layout: default
title: "Pinout e Mapeamento Altera DE0"
---

# Mapeamento de Pinos da Placa Altera DE0

O projeto está configurado para o FPGA **Altera Cyclone III EP3C16F484C6** conforme as especificações do arquivo [`ProjetoFinal.qsf`](../ProjetoFinal.qsf) e o manual oficial da placa DE0.

---

## 1. Padrão Elétrico Geral
- **Família**: Cyclone III
- **Dispositivo**: `EP3C16F484C6`
- **I/O Standard Padrão**: `3.3-V LVTTL`

---

## 2. Entradas de Clock e Pulsadores

| Nome do Sinal | Pino FPGA | Tipo de Componente na DE0 | Descrição no Projeto |
| :--- | :---: | :--- | :--- |
| `CLOCK_50` | `PIN_G21` | Oscilador de 50 MHz | Clock base mestre para o divisor de frequência |
| `BUTTON[0]` | `PIN_H2` | Push-button (Ativo Baixo) | Reset Geral assíncrono do sistema |
| `BUTTON[1]` | `PIN_G3` | Push-button (Ativo Baixo) | Pulso manual de Step (Modo Debug) |
| `BUTTON[2]` | `PIN_F1` | Push-button (Ativo Baixo) | Reservado para expansão futura |

---

## 3. Chaves Deslizantes (Slide Switches `SW`)

| Nome do Sinal | Pino FPGA | Descrição / Função no Projeto |
| :--- | :---: | :--- |
| `SW[0]` | `PIN_J6` | Seletor de Modo: `1` = RUN contínuo (~2Hz) / `0` = DEBUG (Passo a passo manual) |
| `SW[1]` | `PIN_H5` | Entrada de teste / Operando ULA Y bit 1 (ou controle) |
| `SW[2]` | `PIN_H6` | Entrada de teste / Operando ULA Y bit 2 |
| `SW[3]` | `PIN_G4` | Entrada de teste / Operando ULA Y bit 3 |
| `SW[4]` | `PIN_G5` | Bit 0 do Opcode (`RI[4]`) no modo de teste |
| `SW[5]` | `PIN_J7` | Bit 1 do Opcode (`RI[5]`) no modo de teste |
| `SW[6]` | `PIN_H7` | Bit 2 do Opcode (`RI[6]`) no modo de teste |
| `SW[7]` | `PIN_E3` | Bit 3 do Opcode (`RI[7]`) no modo de teste |
| `SW[8]` | `PIN_E4` | Chave auxiliar para controle de operandos |
| `SW[9]` | `PIN_D2` | Chave geral de habilitação |

---

## 4. LEDs Verdes de Status (`LEDG`)

| Nome do Sinal | Pino FPGA | Indicação Visual |
| :--- | :---: | :--- |
| `LEDG[0]` | `PIN_J1` | **Flag Negativo (N)** da ULA |
| `LEDG[1]` | `PIN_J2` | **Flag Zero (Z)** da ULA |
| `LEDG[2]` | `PIN_J3` | **Clock Efetivo** (pisca a ~2 Hz em RUN ou a cada pulso de Step) |
| `LEDG[3]` | `PIN_H1` | Instrução **LDA** ativa no decodificador |
| `LEDG[4]` | `PIN_F2` | Instrução **ADD** ativa no decodificador |
| `LEDG[5]` | `PIN_E1` | Instrução **HLT** ativa (parada) |
| `LEDG[6]` | `PIN_C1` | Sinal de controle interno / Carry |
| `LEDG[7]` | `PIN_C2` | Linha de controle da ULA `selUAL[0]` |
| `LEDG[8]` | `PIN_B2` | Linha de controle da ULA `selUAL[1]` |
| `LEDG[9]` | `PIN_B1` | Linha de controle da ULA `selUAL[2]` |

---

## 5. Displays de 7 Segmentos (HEX0 a HEX3)

Todos os segmentos dos displays de 7 segmentos da placa DE0 são ativos em nível lógico **baixo `0`** (anodo comum).

### 5.1. Display HEX0 (ULA - Nibble Menos Significativo: bits 3 a 0)
- `HEX0[0]` (Segmento a): `PIN_E11`
- `HEX0[1]` (Segmento b): `PIN_F11`
- `HEX0[2]` (Segmento c): `PIN_H12`
- `HEX0[3]` (Segmento d): `PIN_H13`
- `HEX0[4]` (Segmento e): `PIN_G12`
- `HEX0[5]` (Segmento f): `PIN_F12`
- `HEX0[6]` (Segmento g): `PIN_F13`

### 5.2. Display HEX1 (ULA - Nibble Mais Significativo: bits 7 a 4)
- `HEX1[0]` (Segmento a): `PIN_A13`
- `HEX1[1]` (Segmento b): `PIN_B13`
- `HEX1[2]` (Segmento c): `PIN_C13`
- `HEX1[3]` (Segmento d): `PIN_A14`
- `HEX1[4]` (Segmento e): `PIN_B14`
- `HEX1[5]` (Segmento f): `PIN_E14`
- `HEX1[6]` (Segmento g): `PIN_A15`

### 5.3. Display HEX2 (PC - Nibble Menos Significativo: bits 3 a 0)
- `HEX2[0]` (Segmento a): `PIN_D15`
- `HEX2[1]` (Segmento b): `PIN_A16`
- `HEX2[2]` (Segmento c): `PIN_B16`
- `HEX2[3]` (Segmento d): `PIN_E15`
- `HEX2[4]` (Segmento e): `PIN_A17`
- `HEX2[5]` (Segmento f): `PIN_B17`
- `HEX2[6]` (Segmento g): `PIN_F14`

### 5.4. Display HEX3 (PC - Nibble Mais Significativo: bits 7 a 4)
- `HEX3[0]` (Segmento a): `PIN_B18`
- `HEX3[1]` (Segmento b): `PIN_F15`
- `HEX3[2]` (Segmento c): `PIN_A19`
- `HEX3[3]` (Segmento d): `PIN_B19`
- `HEX3[4]` (Segmento e): `PIN_C19`
- `HEX3[5]` (Segmento f): `PIN_D19`
- `HEX3[6]` (Segmento g): `PIN_G15`
