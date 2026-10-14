// Top-level: Projeto Final - Processador Neander
// Integracao dos modulos: Decoder, Codificador ULA, ULA com Display, PC com Divisor

module ProjetoFinal (
    input  wire        CLOCK_50,
    input  wire [2:0]  BUTTON,
    input  wire [9:0]  SW,
    output wire [9:0]  LEDG,
    output wire [6:0]  HEX0,
    output wire [6:0]  HEX1,
    output wire [6:0]  HEX2,
    output wire [6:0]  HEX3
);

    wire rst = ~BUTTON[0];

    // Decodificador de instrucoes
    wire dec_nop, dec_sta, dec_lda, dec_add, dec_or, dec_and, dec_not;
    wire dec_jmp, dec_jn, dec_jz, dec_hlt;

    decoder_neander decoder_inst (
        .opcode (SW[7:4]),
        .nop    (dec_nop),
        .sta    (dec_sta),
        .lda    (dec_lda),
        .add    (dec_add),
        .or_op  (dec_or),
        .and_op (dec_and),
        .not_op (dec_not),
        .jmp    (dec_jmp),
        .jn     (dec_jn),
        .jz     (dec_jz),
        .hlt    (dec_hlt)
    );

    // Codificador da ULA
    wire [2:0] selUAL_gerado;
    wire cmd_ula_y   = dec_lda | SW[1];
    wire cmd_ula_add = dec_add | SW[2];
    wire cmd_ula_and = dec_and | SW[3];
    wire cmd_ula_or  = dec_or;
    wire cmd_ula_not = dec_not;

    codificador_ula cod_ula_inst (
        .ula_y   (cmd_ula_y),
        .ula_add (cmd_ula_add),
        .ula_and (cmd_ula_and),
        .ula_or  (cmd_ula_or),
        .ula_not (cmd_ula_not),
        .selUAL  (selUAL_gerado)
    );

    // ULA e displays HEX1 e HEX0
    wire [7:0] ula_x = {4'b0000, SW[9:8], 2'b01};
    wire [7:0] ula_y = {4'b0000, SW[3:0]};
    wire [7:0] ula_res;
    wire       flag_n_sig, flag_z_sig;

    etapa3_ula_display ula_disp_inst (
        .x       (ula_x),
        .y       (ula_y),
        .selUAL  (selUAL_gerado),
        .ula_out (ula_res),
        .flag_n  (flag_n_sig),
        .flag_z  (flag_z_sig),
        .hex1    (HEX1),
        .hex0    (HEX0)
    );

    // PC e displays HEX3 e HEX2
    wire       clk_eff;
    wire [7:0] pc_val;
    wire       carga_pc_cmd = (dec_jmp | dec_jn | dec_jz);
    wire       inc_pc_cmd   = ~BUTTON[2] | (~carga_pc_cmd & ~dec_hlt);

    etapa4_pc_divisor #(.DIVISOR(25000000)) pc_disp_inst (
        .clk_50mhz    (CLOCK_50),
        .rst          (rst),
        .run_debug    (SW[0]),
        .step_btn_n   (BUTTON[1]),
        .cargaPC      (carga_pc_cmd),
        .incrementaPC (inc_pc_cmd),
        .data_in      (ula_res),
        .clk_effective(clk_eff),
        .pc_out       (pc_val),
        .hex3         (HEX3),
        .hex2         (HEX2)
    );

    // LEDs
    assign LEDG[0] = flag_n_sig;
    assign LEDG[1] = flag_z_sig;
    assign LEDG[2] = clk_eff;
    assign LEDG[3] = dec_lda;
    assign LEDG[4] = dec_add;
    assign LEDG[5] = dec_hlt;
    assign LEDG[6] = dec_jmp;
    assign LEDG[7] = selUAL_gerado[0];
    assign LEDG[8] = selUAL_gerado[1];
    assign LEDG[9] = selUAL_gerado[2];

endmodule
