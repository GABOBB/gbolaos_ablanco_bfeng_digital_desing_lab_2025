module p1 #(parameter N = 4)(
    input logic [N-1:0] A, B,
    input logic [3:0] op,  // Se cambia a 4 bits para más operaciones
    output logic [N-1:0] result,
    output logic carry, overflow, zero, negative
);

    logic [N-1:0] sum;
    logic [N:0] carry_internal; // Bit extra para el acarreo entre etapas
    logic [2*N-1:0] product;    // Espacio para multiplicación

    always_comb begin
        // Inicialización de variables internas
        sum = 0;
        product = 0;
        result = 0;
        
        // Inicialización de banderas (evita latches)
        carry = 0;
        overflow = 0;
        zero = 0;
        negative = 0;
        carry_internal = 0; // Acarreo inicial en 0

        case (op)
            4'b0000: begin // Suma usando circuitos básicos (Ripple-Carry Adder)
                for (int i = 0; i < N; i++) begin
                    sum[i] = A[i] ^ B[i] ^ carry_internal[i];  // XOR para suma
                    carry_internal[i+1] = (A[i] & B[i]) | (A[i] & carry_internal[i]) | (B[i] & carry_internal[i]); // Carry
                end
                
                result = sum;
                carry = carry_internal[N]; // Acarreo final
                overflow = (A[N-1] == B[N-1]) && (result[N-1] != A[N-1]); // Overflow con signo
                negative = result[N-1];  // Negativo si MSB es 1
            end
            
            4'b0001: begin // AND lógico
                result = A & B;
            end
            
            4'b0010: begin // OR lógico
                result = A | B;
            end
            
            4'b0011: begin // Multiplicación (operación aritmética)
                product = A * B;
                result = product[N-1:0];
                carry = |product[2*N-1:N];  // Carry si hay bits superiores
                overflow = carry;  // Overflow si resultado no cabe en N bits
                negative = result[N-1];  
            end

            4'b0100: begin // Resta 
                
            end

            4'b0101: begin // División
                
            end

            4'b0110: begin // Módulo 
                
            end

            4'b0111: begin // XOR
                
            end

            4'b1000: begin // Shift left 
                
            end

            4'b1001: begin // Shift right 
                
            end
        endcase

        // Bandera Zero común a todas las operaciones
        zero = (result == 0);
    end

endmodule
