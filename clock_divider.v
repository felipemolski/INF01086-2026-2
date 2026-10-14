// Divisor de clock de 50 MHz para aproximadamente 2 Hz

module clock_divider #(
    parameter DIVISOR = 25000000 // Inverte a cada 12.500.000 ciclos para obter 2 Hz
)(
    input  wire clk_in,
    input  wire rst,
    output reg  clk_out
);

    reg [31:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            clk_out <= 1'b0;
        end else begin
            if (counter >= (DIVISOR / 2) - 1) begin
                counter <= 32'd0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 32'd1;
            end
        end
    end

endmodule
