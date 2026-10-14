---
layout: default
title: "INF01086 2026/2 - Processador Neander"
---

# Projeto Final: Processador Neander em FPGA

Repositório da disciplina de **Arquitetura e Organização de Computadores I (INF01086)** do **Instituto de Informática da UFRGS** (Semestre 2026/2).

Este projeto implementa a arquitetura clássica do processador acumulador **Neander** descrita em Verilog HDL e sintetizada para a placa educacional **Altera DE0** (FPGA **Cyclone III EP3C16F484C6**) utilizando o ambiente **Altera Quartus II 13.0 SP1**.

---

## 📌 Sumário da Documentação

A documentação do projeto está dividida nos seguintes módulos técnicos:

1. [**Arquitetura do Processador Neander**](arquitetura.md)  
   Visão geral da microarquitetura Neander, registradores (AC, PC, RI, REM, RDM), tabela das 11 instruções oficiais, ciclos de busca e execução ($t_0 \dots t_7$).

2. [**Etapas de Implementação (Checkpoint 16/10)**](etapas.md)  
   Detalhamento de blocos das Etapas I a IV: Decodificador de Instruções, Codificador ULA, ULA com cálculo de flags (N e Z), Displays de 7 segmentos, Program Counter e Divisor de Clock com controle RUN / DEBUG.

3. [**Equações Booleanas e Tabelas de Controle**](equacoes_controle.md)  
   Restauração integral de todas as tabelas verdade, equações lógicas dos sinais de controle, mintermos do decodificador, mapas de Karnaugh dos displays de 7 segmentos e lógica de detecção de flags da ULA.

4. [**Simulação e Testbenches (ModelSim)**](simulacao_testbenches.md)  
   Relatório de simulação de todos os módulos com os testbenches desenvolvidos, diagramas temporais e validação de casos de teste.

5. [**Mapeamento de Pinos e Pinout da Placa DE0**](pinout_de0.md)  
   Pinagem completa atribuída no Quartus II (`.qsf`), interface de entrada/saída (chaves, botões, LEDs e displays de 7 segmentos).

6. [**Guia de Operação e Testes na Placa (README)**](../README.md)  
   Passo a passo de verificação no Quartus II, gravação via USB-Blaster e roteiro de validação na bancada.

---

## 🚀 Status do Projeto (Checkpoint de 16/10)

| Etapa | Módulo | Descrição | Status |
| :---: | :--- | :--- | :---: |
| **I** | `decoder_neander.v` | Decodificador de instruções (4 bits $\to$ 11 instruções) | Concluído / Verificado |
| **II** | `codificador_ula.v` | Codificador de operações da ULA (`selUAL[2:0]`) | Concluído / Verificado |
| **III** | `ula_neander.v` + `hex_to_7seg.v` | ULA Neander de 8 bits com flags N e Z + 2 displays | Concluído / Verificado |
| **IV** | `pc_neander.v` + `clock_divider.v` + `run_step_ctrl.v` | PC de 8 bits + Divisor ~2Hz + Controle RUN/STEP | Concluído / Verificado |
| **TOP** | `ProjetoFinal.v` | Integração de todas as etapas no topo do projeto | Compilado (0 erros) |

### Síntese no Quartus II 13.0 SP1
- **Dispositivo Alvo**: Altera Cyclone III `EP3C16F484C6`
- **Total Logic Elements**: `120 / 15,408` (< 1%)
- **Total Pins**: `52 / 347` (15%)
- **Frequência de Clock do Sistema**: 50 MHz (`CLOCK_50`)
- **Arquivo de Carga Gerado**: `output_files/ProjetoFinal.sof`

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem**: Verilog HDL (IEEE 1364-2001) e VHDL (ROM de teste)
- **EDA / IDE**: Altera Quartus II 13.0 SP1 (Web Edition)
- **Simulador**: Mentor Graphics ModelSim-Altera 10.1d
- **Hardware**: Placa de Desenvolvimento Altera DE0 (Cyclone III)
- **Controle de Versão**: Git & GitHub Pages
