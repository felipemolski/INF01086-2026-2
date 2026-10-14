---
layout: default
title: "Simulação e Testbenches (ModelSim)"
---

# Simulação e Testbenches no ModelSim

Todos os blocos do projeto foram validados funcionalmente através de testbenches individuais e integrados desenvolvidos em Verilog HDL e executados no simulador **ModelSim-Altera 10.1d**.

---

## 1. Testbenches Desenvolvidos

| Arquivo de Testbench | Módulo sob Teste (UUT) | Escopo dos Testes Realizados | Resultado |
| :--- | :--- | :--- | :---: |
| [`tb_decoder_neander.v`](../tb_decoder_neander.v) | `decoder_neander.v` | Varredura de todos os 16 valores possíveis de opcode (`0x0` a `0xF`), checando se apenas a linha correta é acionada. | **100% Pass** |
| [`tb_codificador_ula.v`](../tb_codificador_ula.v) | `codificador_ula.v` | Ativação individual de cada linha de controle (`lda`, `add`, `or_op`, `and_op`, `not_op`, `neg`) e conferência do barramento `selUAL[2:0]`. | **100% Pass** |
| [`tb_ula_neander.v`](../tb_ula_neander.v) | `ula_neander.v` | Teste exaustivo das 6 operações com múltiplos pares de operandos, teste de geração de flags Negativo ($N=1$) e Zero ($Z=1$), além de casos de borda ($0x00$, $0xFF$, carry e complemento de 2). | **100% Pass** |
| [`tb_pc_neander.v`](../tb_pc_neander.v) | `pc_neander.v` | Teste de reset assíncrono, incremento contínuo sequencial, carga paralela (*jump*), contagem circular de $0xFF \to 0x00$ e prioridade de sinais. | **100% Pass** |
| [`tb_checkpoint_integrado.v`](../tb_checkpoint_integrado.v) | `ProjetoFinal.v` + `ROM_teste.vhd` | Simulação integrada do sistema com leitura da memória ROM contendo o programa de teste oficial das Etapas I a IV. | **100% Pass** |

---

## 2. Como Executar as Simulações no ModelSim

1. Abra o **ModelSim-Altera**.
2. No menu principal, acesse **File > Change Directory...** e aponte para o diretório raiz do projeto: `D:/Projeto Final`.
3. No console do ModelSim, execute os comandos de compilação da biblioteca de trabalho (`work`):
   ```tcl
   vlib work
   vmap work work
   ```
4. Compile os módulos Verilog e o testbench desejado. Por exemplo, para a simulação integrada:
   ```tcl
   vlog decoder_neander.v codificador_ula.v ula_neander.v hex_to_7seg.v etapa3_ula_display.v clock_divider.v run_step_ctrl.v pc_neander.v etapa4_pc_divisor.v ProjetoFinal.v tb_checkpoint_integrado.v
   vcom -93 ROM_teste.vhd
   ```
5. Inicie a simulação:
   ```tcl
   vsim work.tb_checkpoint_integrado
   ```
6. Adicione as formas de onda de interesse e execute:
   ```tcl
   add wave -radix hex sim:/tb_checkpoint_integrado/*
   run 5000 ns
   ```

---

## 3. Cobertura de Casos Críticos de Teste

### 3.1. ULA: Detecção de Zero e Negativo
- Operação com resultado zero: $X = 0x55, Y = 0x55$, seleção `selUAL = 3'b011` (AND):
  $$S = 0x55, \quad Z = 0, \quad N = 0$$
- Operação NOT com valor $0xFF$:
  $$S = \sim (0xFF) = 0x00 \implies Z = 1, \quad N = 0$$
- Operação ADD gerando valor com bit 7 em 1:
  $$X = 0x40, \quad Y = 0x40 \implies S = 0x80 \implies N = 1, \quad Z = 0$$

### 3.2. PC: Incremento e Saltos
- Reset assíncrono em qualquer instante força $PC = 0x00$ imediatamente, independente da borda do clock.
- Incremento com $PC = 0xFF$ realiza o wrap-around seguro para $0x00$ sem travar o contador.
- Carga paralela (`pc_load = 1`) tem precedência sobre o sinal de incremento (`pc_inc = 1`), simulando fielmente o comportamento de desvios na Unidade de Controle.
