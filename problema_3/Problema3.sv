module Problema3 #(parameter N = 6) (
    input logic clk,
    input logic rst,
    input logic [N-1:0] inicial,
    input logic decrementar,
    output logic [N-1:0] out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        out <= inicial;  // Reset asíncrono, establece el valor inicial
    else if (decrementar)
        out <= out - 1;
end

endmodule
