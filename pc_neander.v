// Program Counter (PC) de 8 bits do Neander - Descricao Estrutural
// Instancia somador de incremento (somador8) e registrador (registrador8b)

module pc_neander (
    input  wire       clk,
    input  wire       rst,
    input  wire       cargaPC,
    input  wire       incrementaPC,
    input  wire [7:0] data_in,
    output wire [7:0] pc_out
);

    // Incrementador estrutural (+1)
    wire [7:0] pc_inc;
    wire       cout_inc;
    somador8 inc_inst (
        .a   (pc_out),
        .b   (8'h01),
        .cin (1'b0),
        .s   (pc_inc),
        .cout(cout_inc)
    );

    // Multiplexador de proximo valor estrutural
    wire [7:0] pc_next = cargaPC ? data_in :
                         (incrementaPC ? pc_inc : pc_out);

    wire pc_load_en = cargaPC | incrementaPC;

    // Registrador estrutural de 8 bits
    registrador8b reg_inst (
        .clk (clk),
        .rst (rst),
        .load(pc_load_en),
        .d   (pc_next),
        .q   (pc_out)
    );

endmodule
