// ULA de 8 bits do Neander
// 000: Y, 001: ADD, 010: AND, 011: OR, 100: NOT
// Flags: N (negativo, bit 7), Z (zero)

module ula_neander (
    input  wire [7:0] x,
    input  wire [7:0] y,
    input  wire [2:0] selUAL,
    output reg  [7:0] out,
    output wire       flag_n,
    output wire       flag_z
);

    always @(*) begin
        case (selUAL)
            3'b000: out = y;      // transfere Y
            3'b001: out = x + y;  // soma
            3'b010: out = x & y;  // and
            3'b011: out = x | y;  // or
            3'b100: out = ~x;     // not
            default: out = 8'h00;
        endcase
    end

    // Flag negativo: bit mais significativo
    assign flag_n = out[7];

    // Flag zero: resultado igual a zero
    assign flag_z = (out == 8'b00000000);

endmodule
