// Modos RUN e DEBUG (passo a passo via botao)

module run_step_ctrl (
    input  wire clk_fast,
    input  wire rst,
    input  wire clk_div,
    input  wire run_debug,   // 1: RUN, 0: DEBUG
    input  wire step_btn_n,  // BUTTON1 (ativo baixo)
    output wire clk_effective
);

    reg step_sync0, step_sync1, step_sync2;

    always @(posedge clk_fast or posedge rst) begin
        if (rst) begin
            step_sync0 <= 1'b1;
            step_sync1 <= 1'b1;
            step_sync2 <= 1'b1;
        end else begin
            step_sync0 <= step_btn_n;
            step_sync1 <= step_sync0;
            step_sync2 <= step_sync1;
        end
    end

    wire step_pressed = (step_sync2 == 1'b1 && step_sync1 == 1'b0);

    reg step_clk_reg;
    always @(posedge clk_fast or posedge rst) begin
        if (rst) begin
            step_clk_reg <= 1'b0;
        end else if (step_pressed) begin
            step_clk_reg <= ~step_clk_reg;
        end
    end

    assign clk_effective = (run_debug) ? clk_div : step_clk_reg;

endmodule
