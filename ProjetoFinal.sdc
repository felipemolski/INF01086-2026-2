# Synopsys Design Constraints (SDC) para o Projeto Final Neander
# Dispositivo: Altera Cyclone III EP3C16F484C6 (Placa DE0)

# Relogio principal de 50 MHz da placa (periodo de 20.0 ns)
create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]

# Derivacao de incerteza de clock
derive_clock_uncertainty

# Relogios lentos internos definidos com periodos seguros para o TimeQuest (1 MHz / 1000 ns)
create_clock -name clk_div -period 1000.000 [get_registers {etapa4_pc_divisor:pc_disp_inst|clock_divider:div_inst|clk_out}]
create_clock -name step_clk -period 1000.000 [get_registers {etapa4_pc_divisor:pc_disp_inst|run_step_ctrl:run_step_inst|step_clk_reg}]

# Dominios de clock assincronos
set_clock_groups -asynchronous \
    -group [get_clocks {CLOCK_50}] \
    -group [get_clocks {clk_div}] \
    -group [get_clocks {step_clk}]

# Entradas manuais assincronas (chaves e botoes)
set_false_path -from [get_ports {BUTTON[*]}]
set_false_path -from [get_ports {SW[*]}]

# Saidas visuais estaticas (LEDs e Displays de 7 segmentos)
set_false_path -to [get_ports {LEDG[*]}]
set_false_path -to [get_ports {HEX0[*]}]
set_false_path -to [get_ports {HEX1[*]}]
set_false_path -to [get_ports {HEX2[*]}]
set_false_path -to [get_ports {HEX3[*]}]
