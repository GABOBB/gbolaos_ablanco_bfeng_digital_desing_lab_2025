module Problema3_tb();

    parameter N = 6;
    logic clk, rst, decrementar;
    logic [N-1:0] inicial;
    logic [N-1:0] out;
    
    Problema3 #(N) uut (
        .clk(clk),
        .rst(rst),
        .inicial(inicial),
        .decrementar(decrementar),
        .out(out)
    );

    // Generación del reloj
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        inicial = 6'b100101; // Valor inicial arbitrario
        decrementar = 0;
        #10 rst = 0;  // Se desactiva el reset
        #10 decrementar = 1; 
        #10 decrementar = 0; 
        #10 decrementar = 1; 
        #10 decrementar = 1; 
        #10 decrementar = 0; 
        #10 $stop;
    end

endmodule
