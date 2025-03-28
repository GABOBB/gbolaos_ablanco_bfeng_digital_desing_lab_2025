`timescale 1ns / 1ps

module p1_tb();
    parameter N = 4;

    // Simulación de los switches y botones del FPGA
    logic [7:0] SW;   // Switches para A y B
    logic [3:0] KEY;  // Botones para operación

    logic [N-1:0] result;
    logic carry, overflow, zero, negative;

    // Instanciamos el módulo p1, usando switches y botones
    p1 #(N) uut (
        .SW(SW), 
        .KEY(KEY), 
        .result(result), 
        .carry(carry), 
        .overflow(overflow), 
        .zero(zero), 
        .negative(negative)
    );

    initial begin
        $display("=== PRUEBAS DE SUMA ===");
        // Suma 1: Normal sin carry/overflow
        SW = 8'b0000_0010; KEY = 4'b0000; #10; // A = 2, B = 1, op = 0000 (suma)
        $display("Suma1: %b + %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // Suma 2: Con carry sin overflow (sin signo)
        SW = 8'b0001_1111; KEY = 4'b0000; #10; // A = 15, B = 1
        $display("Suma2: %b + %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // Suma 3: Con overflow (con signo)
        SW = 8'b0111_0111; KEY = 4'b0000; #10; // A = 7, B = 7
        $display("Suma3: %b + %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);

        $display("\n=== PRUEBAS DE AND ===");
        // AND 1: Resultado no cero
        SW = 8'b1100_1010; KEY = 4'b0001; #10; // A = 1010, B = 1100, op = 0001 (AND)
        $display("AND1:  %b & %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // AND 2: Resultado cero
        SW = 8'b0101_1010; KEY = 4'b0001; #10; // A = 1010, B = 0101
        $display("AND2:  %b & %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);

        $display("\n=== PRUEBAS DE OR ===");
        // OR 1: Resultado no cero
        SW = 8'b1100_1010; KEY = 4'b0010; #10; // A = 1010, B = 1100, op = 0010 (OR)
        $display("OR1:   %b | %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // OR 2: Resultado todos unos
        SW = 8'b0101_1010; KEY = 4'b0010; #10; // A = 1010, B = 0101
        $display("OR2:   %b | %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);

        $display("\n=== PRUEBAS DE MULTIPLICACIÓN ===");
        // Mult 1: Normal sin overflow
        SW = 8'b0010_0011; KEY = 4'b0011; #10; // A = 3, B = 2, op = 0011 (multiplicación)
        $display("Mult1: %b * %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // Mult 2: Con overflow
        SW = 8'b1111_1111; KEY = 4'b0011; #10; // A = 15, B = 15
        $display("Mult2: %b * %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);
        
        // Mult 3: Resultado cero
        SW = 8'b1111_0000; KEY = 4'b0011; #10; // A = 0, B = 15
        $display("Mult3: %b * %b = %b | N:%b Z:%b C:%b V:%b", SW[3:0], SW[7:4], result, negative, zero, carry, overflow);

        $stop;
    end 
endmodule
