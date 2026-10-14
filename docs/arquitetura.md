---
layout: default
title: "Arquitetura Neander"
---

# Microarquitetura do Processador Neander

O **Neander** é um processador didático de arquitetura acumulador de 8 bits baseado no modelo de Von Neumann, amplamente utilizado no ensino de Arquitetura de Computadores no Instituto de Informática da UFRGS.

---

## 1. Características Gerais

- **Largura da Palavra de Dados**: 8 bits
- **Largura do Barramento de Endereços**: 8 bits (endereçamento de até 256 bytes de memória)
- **Modos de Endereçamento**:
  - *Direto*: O operando é fornecido no segundo byte da instrução (endereço de memória).
  - *Implícito*: O operando é o próprio acumulador (ex.: `NOT`).
- **Registradores Internos**:
  - **AC (Acumulador)**: Registrador de dados de 8 bits onde a maioria das operações lógicas e aritméticas é armazenada.
  - **PC (Program Counter)**: Registrador de 8 bits que armazena o endereço da próxima instrução a ser buscada.
  - **REM (Registrador de Endereço de Memória)**: 8 bits, retém o endereço enviado ao barramento da memória.
  - **RDM (Registrador de Dados de Memória)**: 8 bits, retém os dados lidos da ou gravados na memória.
  - **RI (Registrador de Instruções)**: 8 bits, armazena a instrução corrente. Os bits mais significativos `RI[7:4]` contêm o código de operação (*Opcode*).
  - **Flags de Condição**:
    - **N (Negativo)**: Indica se o bit mais significativo de AC é `1` ($AC[7] = 1$).
    - **Z (Zero)**: Indica se todos os bits de AC são `0` ($AC = 8'h00$).

---

## 2. Diagrama em Bloco da Arquitetura

```
                         BARRAMENTO DE DADOS (8 bits)
       ================================================================
             ^                ^            ^              |        |
             |                |            |              v        v
        +---------+      +---------+  +---------+    +--------+ +--------+
        |   PC    |      |   AC    |  |   RDM   |    |   RI   | |   REM  |
        | (8 bits)|      | (8 bits)|  | (8 bits)|    |(8 bits)| | (8 bits)
        +---------+      +---------+  +---------+    +--------+ +--------+
             |                |            |              |          |
             |                v            |              v          v
             |           +---------+       |        Decodificador   Para
             |           |   ULA   |<------+        de Instruções  Memória
             |           | (8 bits)|                      |
             |           +---------+                      v
             |             |     |                 Unidade de
             |             v     v                  Controle
             |          Flags: N, Z
             v
       ================================================================
                       BARRAMENTO DE ENDEREÇOS (8 bits)
```

---

## 3. Conjunto Oficial de Instruções (11 Instruções)

O Neander possui 11 instruções oficiais codificadas nos bits `RI[7:4]`:

| Mnemônico | Opcode (Hex) | Binário `RI[7:4]` | Tamanho (Bytes) | Formato | Operação Realizada | Flags Alteradas |
| :--- | :---: | :---: | :---: | :--- | :--- | :---: |
| **NOP** | `0x0` | `0000` | 1 | `NOP` | Nenhuma operação realizada | Nenhuma |
| **STA** | `0x1` | `0001` | 2 | `STA end` | Memória no endereço recebe AC: $M[\text{end}] \leftarrow AC$ | Nenhuma |
| **LDA** | `0x2` | `0010` | 2 | `LDA end` | Acumulador recebe memória: $AC \leftarrow M[\text{end}]$ | N, Z |
| **ADD** | `0x3` | `0011` | 2 | `ADD end` | Soma acumulador e memória: $AC \leftarrow AC + M[\text{end}]$ | N, Z |
| **OR**  | `0x4` | `0100` | 2 | `OR end`  | Operação OU lógica: $AC \leftarrow AC \lor M[\text{end}]$ | N, Z |
| **AND** | `0x5` | `0101` | 2 | `AND end` | Operação E lógica: $AC \leftarrow AC \land M[\text{end}]$ | N, Z |
| **NOT** | `0x6` | `0110` | 1 | `NOT`     | Inversão lógica de AC: $AC \leftarrow \sim AC$ | N, Z |
| **JMP** | `0x8` | `1000` | 2 | `JMP end` | Desvio incondicional: $PC \leftarrow \text{end}$ | Nenhuma |
| **JN**  | `0x9` | `1001` | 2 | `JN end`  | Desvio condicional se negativo: Se $N=1$, $PC \leftarrow \text{end}$ | Nenhuma |
| **JZ**  | `0xA` | `1010` | 2 | `JZ end`  | Desvio condicional se zero: Se $Z=1$, $PC \leftarrow \text{end}$ | Nenhuma |
| **HLT** | `0xF` | `1111` | 1 | `HLT`     | Para o gerador de ciclos e suspende a execução | Nenhuma |

---

## 4. Ciclos de Busca e Execução ($t_0 \dots t_7$)

A execução de qualquer instrução no Neander é coordenada por um gerador de passos de tempo ($t_0$ até $t_7$):

### 4.1. Ciclo de Busca da Instrução (Comum a todas as instruções)
- **Passo $t_0$**: $\text{REM} \leftarrow \text{PC}$  
  O endereço da instrução a ser buscada é transferido do PC para o REM.
- **Passo $t_1$**: $\text{RDM} \leftarrow M[\text{REM}]$ e $\text{PC} \leftarrow \text{PC} + 1$  
  A memória lê a palavra de instrução no endereço indicado pelo REM; simultaneamente, o PC é incrementado para apontar para o próximo byte.
- **Passo $t_2$**: $\text{RI} \leftarrow \text{RDM}$  
  O código de instrução é carregado no Registrador de Instruções (RI).

### 4.2. Ciclos de Execução de Instruções com 1 Byte
- **NOP**:
  - $t_3$: Reinicia o gerador de ciclos para $t_0$ (nenhuma ação).
- **NOT**:
  - $t_3$: $AC \leftarrow \sim AC$, atualiza flags N e Z, reinicia gerador de ciclos para $t_0$.
- **HLT**:
  - $t_3$: Congela o relógio da máquina / para a contagem do temporizador.

### 4.3. Ciclos de Execução de Instruções com Operando (2 Bytes: LDA, ADD, OR, AND, STA)
- **Passo $t_3$**: $\text{REM} \leftarrow \text{PC}$  
  Transfere o endereço do byte de operando (endereço do dado) para o REM.
- **Passo $t_4$**: $\text{RDM} \leftarrow M[\text{REM}]$ e $\text{PC} \leftarrow \text{PC} + 1$  
  Lê o operando da memória para o RDM e incrementa o PC para apontar para a próxima instrução.
- **Passo $t_5$**: $\text{REM} \leftarrow \text{RDM}$  
  O endereço do dado alvo é colocado no REM.
- **Passo $t_6$**:
  - Para **LDA**: $AC \leftarrow M[\text{REM}]$, atualiza flags N, Z.
  - Para **ADD**: $AC \leftarrow AC + M[\text{REM}]$, atualiza flags N, Z.
  - Para **OR**:  $AC \leftarrow AC \lor M[\text{REM}]$, atualiza flags N, Z.
  - Para **AND**: $AC \leftarrow AC \land M[\text{REM}]$, atualiza flags N, Z.
  - Para **STA**: $M[\text{REM}] \leftarrow AC$ (sinal de escrita na memória ativado).
  - Reinicia o gerador de ciclos para $t_0$.

### 4.4. Ciclos de Execução de Saltos (JMP, JN, JZ)
- **Passo $t_3$**: $\text{REM} \leftarrow \text{PC}$
- **Passo $t_4$**: $\text{RDM} \leftarrow M[\text{REM}]$
- **Passo $t_5$**:
  - Para **JMP**: $\text{PC} \leftarrow \text{RDM}$.
  - Para **JN**: Se $N=1$, $\text{PC} \leftarrow \text{RDM}$; senão $\text{PC} \leftarrow \text{PC} + 1$.
  - Para **JZ**: Se $Z=1$, $\text{PC} \leftarrow \text{RDM}$; senão $\text{PC} \leftarrow \text{PC} + 1$.
  - Reinicia o gerador de ciclos para $t_0$.
