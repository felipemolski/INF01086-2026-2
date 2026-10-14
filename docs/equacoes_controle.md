---
layout: default
title: "Equações de Controle e Tabelas Verdade"
---

# Equações Booleanas e Tabelas de Controle

Esta seção documenta a modelagem lógica, tabelas verdade e equações booleanas formais de todos os circuitos combinacionais e sequenciais projetados nas Etapas I a IV.

---

## 1. Decodificador de Instruções (Etapa I)

O decodificador converte o nibble mais significativo do registrador de instrução $RI[7:4]$, denominado $ri[3:0] = \{ri_3, ri_2, ri_1, ri_0\}$, em 11 sinais de controle exclusivos:

### 1.1. Tabela Verdade

| $ri_3$ | $ri_2$ | $ri_1$ | $ri_0$ | Hex | NOP | STA | LDA | ADD | OR | AND | NOT | JMP | JN | JZ | HLT |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | 0 | 0 | `0` | **1** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 0 | 1 | `1` | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | `2` | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | `3` | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 0 | `4` | 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 | `5` | 0 | 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 | `6` | 0 | 0 | 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 | `7` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 0 | `8` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 |
| 1 | 0 | 0 | 1 | `9` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | **1** | 0 | 0 |
| 1 | 0 | 1 | 0 | `A` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | **1** | 0 |
| 1 | 0 | 1 | 1 | `B` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 0 | 0 | `C` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 0 | 1 | `D` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | `E` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 1 | `F` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | **1** |

### 1.2. Equações em Forma Canônica (Soma de Produtos / Mintermos)

$$NOP = \overline{ri_3} \cdot \overline{ri_2} \cdot \overline{ri_1} \cdot \overline{ri_0} = m_0$$

$$STA = \overline{ri_3} \cdot \overline{ri_2} \cdot \overline{ri_1} \cdot ri_0 = m_1$$

$$LDA = \overline{ri_3} \cdot \overline{ri_2} \cdot ri_1 \cdot \overline{ri_0} = m_2$$

$$ADD = \overline{ri_3} \cdot \overline{ri_2} \cdot ri_1 \cdot ri_0 = m_3$$

$$OR = \overline{ri_3} \cdot ri_2 \cdot \overline{ri_1} \cdot \overline{ri_0} = m_4$$

$$AND = \overline{ri_3} \cdot ri_2 \cdot \overline{ri_1} \cdot ri_0 = m_5$$

$$NOT = \overline{ri_3} \cdot ri_2 \cdot ri_1 \cdot \overline{ri_0} = m_6$$

$$JMP = ri_3 \cdot \overline{ri_2} \cdot \overline{ri_1} \cdot \overline{ri_0} = m_8$$

$$JN = ri_3 \cdot \overline{ri_2} \cdot \overline{ri_1} \cdot ri_0 = m_9$$

$$JZ = ri_3 \cdot \overline{ri_2} \cdot ri_1 \cdot \overline{ri_0} = m_{10}$$

$$HLT = ri_3 \cdot ri_2 \cdot ri_1 \cdot ri_0 = m_{15}$$

---

## 2. Codificador de Operações da ULA (Etapa II)

O bloco gera as linhas de seleção $selUAL[2:0] = \{s_2, s_1, s_0\}$ a partir dos sinais decodificados das instruções aritméticas e lógicas:

### 2.1. Tabela Verdade

| LDA | ADD | OR | AND | NOT | NEG | $s_2$ | $s_1$ | $s_0$ | Operação Selecionada |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Passagem de Y ($S = Y$) |
| 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | Soma ($S = X + Y$) |
| 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | OU Lógico ($S = X \lor Y$) |
| 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 1 | E Lógico ($S = X \land Y$) |
| 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | Inversão ($S = \sim X$) |
| 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 1 | Negação ($S = -X$) |

### 2.2. Equações Booleanas Simplificadas

$$s_0 = ADD + AND + NEG$$

$$s_1 = OR + AND$$

$$s_2 = NOT + NEG$$

---

## 3. Unidade Lógica e Aritmética (Etapa III)

### 3.1. Operações Aritméticas e Lógicas

Para operandos $X[7:0]$ e $Y[7:0]$:

- **Soma ($selUAL = 001$)**:
  $$S[7:0] = X[7:0] + Y[7:0]$$
- **Operação OU ($selUAL = 010$)**:
  $$S[i] = X[i] \lor Y[i], \quad \forall i \in \{0, \dots, 7\}$$
- **Operação E ($selUAL = 011$)**:
  $$S[i] = X[i] \land Y[i], \quad \forall i \in \{0, \dots, 7\}$$
- **Operação NOT ($selUAL = 100$)**:
  $$S[i] = \overline{X[i]}, \quad \forall i \in \{0, \dots, 7\}$$
- **Operação NEG ($selUAL = 101$)**:
  $$S[7:0] = \overline{X}[7:0] + 1$$

### 3.2. Detecção de Flags de Condição

- **Flag Negativo (N)**:
  $$N = S[7]$$
- **Flag Zero (Z)**:
  $$Z = \overline{S[7]} \cdot \overline{S[6]} \cdot \overline{S[5]} \cdot \overline{S[4]} \cdot \overline{S[3]} \cdot \overline{S[2]} \cdot \overline{S[1]} \cdot \overline{S[0]} = \overline{\bigvee_{i=0}^{7} S[i]}$$
- **Detecção de Overflow ($V$)** (em soma com sinal em complemento de 2):
  $$V = (X[7] \equiv Y[7]) \land (S[7] \not\equiv X[7]) = (X[7] \cdot Y[7] \cdot \overline{S[7]}) + (\overline{X[7]} \cdot \overline{Y[7]} \cdot S[7])$$

---

## 4. Decodificador Hexadecimal para 7 Segmentos (`hex_to_7seg.v`)

O display da placa Altera DE0 é do tipo **anodo comum** (os segmentos acendem quando o sinal correspondente está em nível lógico **baixo `0`**).

```
        a
      +---+
    f |   | b
      +---+  <- g
    e |   | c
      +---+
        d
```

### 4.1. Tabela Verdade (Segmentos $seg[6:0] = \{g, f, e, d, c, b, a\}$)

| Dígito | $hex[3:0]$ | $a$ | $b$ | $c$ | $d$ | $e$ | $f$ | $g$ | $seg[6:0]$ (Hex) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0** | `0000` | 0 | 0 | 0 | 0 | 0 | 0 | 1 | `7'b1000000` (`0x40`) |
| **1** | `0001` | 1 | 0 | 0 | 1 | 1 | 1 | 1 | `7'b1111001` (`0x79`) |
| **2** | `0010` | 0 | 0 | 1 | 0 | 0 | 1 | 0 | `7'b0100100` (`0x24`) |
| **3** | `0011` | 0 | 0 | 0 | 0 | 1 | 1 | 0 | `7'b0110000` (`0x30`) |
| **4** | `0100` | 1 | 0 | 0 | 1 | 1 | 0 | 0 | `7'b0011001` (`0x19`) |
| **5** | `0101` | 0 | 1 | 0 | 0 | 1 | 0 | 0 | `7'b0010010` (`0x12`) |
| **6** | `0110` | 0 | 1 | 0 | 0 | 0 | 0 | 0 | `7'b0000010` (`0x02`) |
| **7** | `0111` | 0 | 0 | 0 | 1 | 1 | 1 | 1 | `7'b1111000` (`0x78`) |
| **8** | `1000` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | `7'b0000000` (`0x00`) |
| **9** | `1001` | 0 | 0 | 0 | 0 | 1 | 0 | 0 | `7'b0010000` (`0x10`) |
| **A** | `1010` | 0 | 0 | 0 | 1 | 0 | 0 | 0 | `7'b0001000` (`0x08`) |
| **B** | `1011` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | `7'b0000011` (`0x03`) |
| **C** | `1100` | 0 | 1 | 1 | 0 | 0 | 0 | 1 | `7'b1000110` (`0x46`) |
| **D** | `1101` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | `7'b0100001` (`0x21`) |
| **E** | `1110` | 0 | 1 | 1 | 0 | 0 | 0 | 0 | `7'b0000110` (`0x06`) |
| **F** | `1111` | 0 | 1 | 1 | 1 | 0 | 0 | 0 | `7'b0001110` (`0x0E`) |

---

## 5. Contador de Programa (PC) e Divisor (Etapa IV)

### 5.1. Equação de Transição de Estados do PC

$$PC(t+1) = \begin{cases} 
8'b00000000 & \text{se } reset = 1 \\
data\_in & \text{se } reset = 0 \text{ e } pc\_load = 1 \\
PC(t) + 1 & \text{se } reset = 0 \text{ e } pc\_load = 0 \text{ e } pc\_inc = 1 \\
PC(t) & \text{caso contrário}
\end{cases}$$

### 5.2. Equação do Divisor de Frequência

A frequência de entrada é $f_{in} = 50\,\text{MHz}$ ($T_{in} = 20\,\text{ns}$). Para gerar uma frequência visual de teste $f_{out} \approx 2\,\text{Hz}$:

$$N_{\text{semiciclo}} = \frac{f_{in}}{2 \times f_{out}} = \frac{50.000.000}{4} = 12.500.000$$

A cada $12.500.000$ pulsos de `clk_50MHz`, o flip-flop `clk_out` inverte seu estado lógico ($clk\_out \leftarrow \overline{clk\_out}$).
