module p1 #(parameter N = 4)(
    input logic [N-1:0] A, B,
    input logic [1:0] op,
    output logic [N-1:0] result,
    output logic carry, overflow, zero, negative
);

    logic [N:0] sum;            // Bit extra para acarreo
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

        case (op)
            2'b00: begin // Suma (operación aritmética)
                sum = {1'b0, A} + {1'b0, B};  // Suma con bit extra para carry
                result = sum[N-1:0];
                
                // Banderas para suma
                carry = sum[N];  // Acarreo en operación sin signo
                overflow = (A[N-1] == B[N-1]) && (result[N-1] != A[N-1]);  // Overflow con signo
                negative = result[N-1];  // Negativo si MSB es 1 (complemento a 2)
            end
            
            2'b01: begin // AND lógico
                result = A & B;
                // Banderas para operación lógica
                carry = 0;
                overflow = 0;
                negative = 0;  // Operaciones lógicas no tienen signo
            end
            
            2'b10: begin // OR lógico
                result = A | B;
                // Banderas para operación lógica
                carry = 0;
                overflow = 0;
                negative = 0;  // Operaciones lógicas no tienen signo
            end
            
            2'b11: begin // Multiplicación (operación aritmética)
                product = A * B;
                result = product[N-1:0];
                
                // Banderas para multiplicación
                carry = |product[2*N-1:N];  // Carry si hay bits superiores
                overflow = carry;  // Overflow si resultado no cabe en N bits
                negative = result[N-1];  // Negativo si MSB es 1
            end
        endcase
        
        // Bandera Zero común a todas las operaciones
        zero = (result == 0);
    end

endmodule