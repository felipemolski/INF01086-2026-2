// Program Counter (PC) de 8 bits do Neander

module pc_neander (
    input  wire       clk,
    input  wire       rst,
    input  wire       cargaPC,
    input  wire       incrementaPC,
    input  wire [7:0] data_in,
    output reg  [7:0] pc_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 8'h00;
        end else begin
            if (cargaPC) begin
                pc_out <= data_in; // Salto (JMP, JN, JZ)
            end else if (incrementaPC) begin
                pc_out <= pc_out + 8'd1;
            end
        end
    end

endmodule
