module p1_tb;

    // Definir señales
    logic [7:0] SW;        // Switches de entrada
    logic [3:0] KEY;       // Botones de selección de operación
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // Salidas de los displays
    logic [3:0] result;    // Resultado de la operación
    logic carry, overflow, zero, negative; // Banderas

    // Instanciar el módulo a probar
    p1 #(4) uut (
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .result(result),
        .carry(carry),
        .overflow(overflow),
        .zero(zero),
        .negative(negative)
    );

    // Procedimiento inicial para probar las operaciones
    initial begin
        // Inicialización de señales
        SW = 8'b00000000; // Inicializar switches
        KEY = 4'b0000;    // Inicializar botones

        // Verificar operación de suma
        #10;
        SW = 8'b00000011; // A = 3, B = 3
        KEY = 4'b0000;    // Operación: suma
        #10;
        $display("Suma: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación AND
        #10;
        KEY = 4'b0001;    // Operación: AND
        #10;
        $display("AND: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación OR
        #10;
        KEY = 4'b0010;    // Operación: OR
        #10;
        $display("OR: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación multiplicación
        #10;
        KEY = 4'b0011;    // Operación: multiplicación
        SW = 8'b00000011; // A = 3, B = 3
        #10;
        $display("Multiplicación: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación resta
        #10;
        KEY = 4'b0100;    // Operación: resta
        SW = 8'b00010011; // A = 19, B = 3
        #10;
        $display("Resta: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación división
        #10;
        KEY = 4'b0101;    // Operación: división
        SW = 8'b00010011; // A = 19, B = 3
        #10;
        $display("División: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación módulo
        #10;
        KEY = 4'b0110;    // Operación: módulo
        SW = 8'b00010011; // A = 19, B = 3
        #10;
        $display("Módulo: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación XOR
        #10;
        KEY = 4'b0111;    // Operación: XOR
        SW = 8'b00010011; // A = 19, B = 3
        #10;
        $display("XOR: A = %d, B = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], SW[7:4], result, carry, overflow, negative);

        // Verificar operación shift left
        #10;
        KEY = 4'b1000;    // Operación: shift left
        SW = 8'b00010011; // A = 19
        #10;
        $display("Shift Left: A = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], result, carry, overflow, negative);

        // Verificar operación shift right
        #10;
        KEY = 4'b1001;    // Operación: shift right
        SW = 8'b00010011; // A = 19
        #10;
        $display("Shift Right: A = %d, result = %d, carry = %d, overflow = %d, negative = %d", SW[3:0], result, carry, overflow, negative);

        // Finalizar la simulación
        #10;
        $finish;
    end

endmodule
