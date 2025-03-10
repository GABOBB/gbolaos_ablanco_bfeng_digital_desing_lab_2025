module Problema3_tb();

    // Parámetros para las pruebas
    parameter N1 = 2;
    parameter N2 = 4;
    parameter N3 = 6;

    // ==== Prueba para N = 2 bits ====
    logic clk1, rst1, decrementar1;
    logic [N1-1:0] inicial1, out1;

    Problema3 #(N1) uut1 (
        .clk(clk1),
        .rst(rst1),
        .inicial(inicial1),
        .decrementar(decrementar1),
        .out(out1)
    );

    always #5 clk1 = ~clk1;

    initial begin
        clk1 = 0; rst1 = 1; inicial1 = 2'b10; decrementar1 = 0;
        #10 rst1 = 0;
        #10 decrementar1 = 1; #10 decrementar1 = 0;
        #10 decrementar1 = 1; #10 decrementar1 = 1;
        #10 decrementar1 = 0; #10;
        $display("Test N=2 bits, Final Value: %b", out1);
    end

    // ==== Prueba para N = 4 bits ====
    logic clk2, rst2, decrementar2;
    logic [N2-1:0] inicial2, out2;

    Problema3 #(N2) uut2 (
        .clk(clk2),
        .rst(rst2),
        .inicial(inicial2),
        .decrementar(decrementar2),
        .out(out2)
    );

    always #5 clk2 = ~clk2;

    initial begin
        clk2 = 0; rst2 = 1; inicial2 = 4'b1010; decrementar2 = 0;
        #10 rst2 = 0;
        #10 decrementar2 = 1; #10 decrementar2 = 0;
        #10 decrementar2 = 1; #10 decrementar2 = 1;
        #10 decrementar2 = 0; #10;
        $display("Test N=4 bits, Final Value: %b", out2);
    end

    // ==== Prueba para N = 6 bits ====
    logic clk3, rst3, decrementar3;
    logic [N3-1:0] inicial3, out3;

    Problema3 #(N3) uut3 (
        .clk(clk3),
        .rst(rst3),
        .inicial(inicial3),
        .decrementar(decrementar3),
        .out(out3)
    );

    always #5 clk3 = ~clk3;

    initial begin
        clk3 = 0; rst3 = 1; inicial3 = 6'b100110; decrementar3 = 0;
        #10 rst3 = 0;
        #10 decrementar3 = 1; #10 decrementar3 = 0;
        #10 decrementar3 = 1; #10 decrementar3 = 1;
        #10 decrementar3 = 0; #10;
        $display("Test N=6 bits, Final Value: %b", out3);
        $stop; // Finaliza la simulación
    end

endmodule

