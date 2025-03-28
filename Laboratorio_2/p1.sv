module p1 #(parameter N = 4)(
    input logic [7:0] SW,    // Switches de la FPGA para A y B
    input logic [3:0] KEY,   // Botones para seleccionar operación
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [N-1:0] result,
    output logic carry, overflow, zero, negative
);

    logic [N-1:0] A, B;
    logic [3:0] op;
    logic [N-1:0] sum;
    logic [N:0] carry_internal; // Bit extra para el acarreo entre etapas
    logic [2*N-1:0] product;    // Espacio para multiplicación

    // Asignar entradas A y B a los switches
    assign A = SW[3:0]; // SW[3:0] para A
    assign B = SW[7:4]; // SW[7:4] para B

    // Asignar la operación a los botones KEY
    assign op = KEY; // Los 4 botones controlan la operación

    always_comb begin
        // Inicialización de variables internas
        sum = 0;
        product = 0;
        result = 0;
        
        // Inicialización de banderas 
        carry = 0;
        overflow = 0;
        zero = 0;
        negative = 0;
        carry_internal = 0; // Acarrreo inicial en 0

        case (op)
            4'b0000: begin // Suma usando circuitos básicos
                // Implementación de sumador Ripple-Carry
                for (int i = 0; i < N; i++) begin
                    sum[i] = A[i] ^ B[i] ^ carry_internal[i]; // XOR para suma
                    carry_internal[i+1] = (A[i] & B[i]) | (A[i] & carry_internal[i]) | (B[i] & carry_internal[i]); // Carry
                end
                
                result = sum;
                
                // Banderas para suma
                carry = carry_internal[N];
                overflow = (A[N-1] == B[N-1]) && (result[N-1] != A[N-1]);
                negative = result[N-1];
            end

            4'b0001: begin // AND lógico 
                result = A & B;
                
                // Banderas para AND
                carry = 0;
                overflow = 0;
                negative = result[N-1]; 
            end

            4'b0010: begin // OR lógico
                result = A | B;
                
                // Banderas para OR
                carry = 0;
                overflow = 0;
                negative = result[N-1];
            end

            4'b0011: begin // Multiplicación (operación aritmética)
                product = A * B;
                result = product[N-1:0];
                
                // Banderas para multiplicación
                carry = |product[2*N-1:N]; // Carry si hay bits superiores
                overflow = carry;  // Overflow si resultado no cabe en N bits
                negative = result[N-1];  
            end

            4'b0100: begin // Resta
                sum = A - B;
                result = sum;
                
                // Banderas para resta
                carry = sum[N-1] == 1 ? 1 : 0;
                overflow = (A[N-1] == B[N-1]) && (sum[N-1] != A[N-1]);
                negative = result[N-1];
            end

            4'b0101: begin // División
                if (B != 0) begin
                    result = A / B;
                    carry = 0; // No hay acarreo en división
                end else begin
                    result = 0; // Si B es 0, el resultado es 0
                    carry = 1;  // Bandera de error
                end
                overflow = 0;  // No hay overflow en la división
                negative = result[N-1];
            end

            4'b0110: begin // Módulo
                if (B != 0) begin
                    result = A % B;
                end else begin
                    result = 0; // Si B es 0, el resultado es 0
                end
                carry = 0;
                overflow = 0;
                negative = result[N-1];
            end

            4'b0111: begin // XOR
                result = A ^ B;
                
                // Banderas para XOR
                carry = 0;
                overflow = 0;
                negative = result[N-1];
            end

            4'b1000: begin // Shift left
                result = A << 1;  // Desplazamiento a la izquierda
                carry = A[N-1];   // El bit desplazado se coloca en carry
                overflow = 0;     // No se genera overflow en un shift normal
                negative = result[N-1]; // Bandera negativa
            end

            4'b1001: begin // Shift right
                result = A >> 1;  // Desplazamiento a la derecha
                carry = A[0];     // El bit desplazado se coloca en carry
                overflow = 0;     // No se genera overflow en un shift normal
                negative = result[N-1]; // Bandera negativa
            end
        endcase
        
        // Bandera Zero común a todas las operaciones
        zero = (result == 0);
    end
    
    // Decodificador de 7 segmentos
    function logic [6:0] seven_seg_decoder(input logic [3:0] value);
        case (value)
            4'h0: seven_seg_decoder = 7'b1000000;
            4'h1: seven_seg_decoder = 7'b1111001;
            4'h2: seven_seg_decoder = 7'b0100100;
            4'h3: seven_seg_decoder = 7'b0110000;
            4'h4: seven_seg_decoder = 7'b0011001;
            4'h5: seven_seg_decoder = 7'b0010010;
            4'h6: seven_seg_decoder = 7'b0000010;
            4'h7: seven_seg_decoder = 7'b1111000;
            4'h8: seven_seg_decoder = 7'b0000000;
            4'h9: seven_seg_decoder = 7'b0010000;
            4'hA: seven_seg_decoder = 7'b0001000;
            4'hB: seven_seg_decoder = 7'b0000011;
            4'hC: seven_seg_decoder = 7'b1000110;
            4'hD: seven_seg_decoder = 7'b0100001;
            4'hE: seven_seg_decoder = 7'b0000110;
            4'hF: seven_seg_decoder = 7'b0001110;
            default: seven_seg_decoder = 7'b1111111;
        endcase
    endfunction

    // Asignar valores a los displays
    always_comb begin
        HEX0 = seven_seg_decoder(result[3:0]);
        HEX1 = seven_seg_decoder({3'b000, negative});
        HEX2 = seven_seg_decoder(B[3:0]);
        HEX3 = seven_seg_decoder({3'b000, B[3]});
        HEX4 = seven_seg_decoder(A[3:0]);
        HEX5 = seven_seg_decoder({3'b000, A[3]});
    end

endmodule
