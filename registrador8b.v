// Registrador de 8 bits com carga paralela e reset assincrono
// Bloco sequencial estrutural para o Neander

module registrador8b (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [7:0] d,
    output reg  [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'h00;
        else if (load)
            q <= d;
    end

endmodule
