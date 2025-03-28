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

    // Variables añadidas para complemento a 2 y visualización decimal
    logic signed [N:0] A_signed, B_signed; // Un bit extra para el signo
    logic signed [N:0] result_signed;
    logic is_negative;
    logic [3:0] abs_value; // Valor absoluto para mostrar

    // Asignar entradas A y B a los switches
    assign A = SW[3:0]; // SW[3:0] para A
    assign B = SW[7:4]; // SW[7:4] para B

    // Convertir a valores con signo (complemento a 2)
    assign A_signed = {A[N-1], A}; // Extender el bit de signo
    assign B_signed = {B[N-1], B};

    // Asignar la operación a los botones KEY
    assign op = KEY; // Los 4 botones controlan la operación

    always_comb begin
        // Inicialización de variables internas
        sum = 0;
        product = 0;
        result = 0;
        result_signed = 0;
        
        // Inicialización de banderas 
        carry = 0;
        overflow = 0;
        zero = 0;
        negative = 0;
        carry_internal = 0; // Acarreo inicial en 0

        case (op)
            4'b0000: begin // Suma usando circuitos básicos
                // Implementación de sumador Ripple-Carry
                for (int i = 0; i < N; i++) begin
                    sum[i] = A[i] ^ B[i] ^ carry_internal[i]; // XOR para suma
                    carry_internal[i+1] = (A[i] & B[i]) | (A[i] & carry_internal[i]) | (B[i] & carry_internal[i]); //Carry
                end
                
                result = sum;
                
                // Banderas para suma
                carry = carry_internal[N];
                overflow = (A[N-1] == B[N-1]) && (result[N-1] != A[N-1]);
                negative = result[N-1];
                result_signed = A_signed + B_signed; // Suma con signo
            end

            4'b0001: begin // AND lógico 
                result = A & B;
                
                // Banderas para AND
                carry = 0;
                overflow = 0;
                negative = result[N-1]; 
                result_signed = A_signed & B_signed;
            end
            
            4'b0010: begin // OR lógico
                result = A | B;
                
                // Banderas para OR
                carry = 0;
                overflow = 0;
                negative = result[N-1];
                result_signed = A_signed | B_signed;
            end
            
            4'b0011: begin // Multiplicación sin operadores
                product = 0;  // Inicializar el resultado del producto
                for (int i = 0; i < B; i++) begin  // Repetir B veces
                    product = product + A;  // Sumar A a sí mismo B veces
                end
                result = product[N-1:0];  // Obtener el resultado truncado a N bits

                // Banderas para multiplicación
                carry = |product[2*N-1:N];  // Carry si hay bits superiores
                overflow = carry;  // Overflow si el resultado no cabe en N bits
                negative = result[N-1];  
                result_signed = A_signed * B_signed;  // Suma con signo
            end

            4'b0100: begin // Resta sin operadores
                // Complemento a 2: A + (~B + 1)
                reg [N-1:0] B_complement;  
				 
					 B_complement = B ^ {N{1'b1}}; 

					 sum = A ^ B_complement;  
					 
					 result = sum ^ 1; 
					 // Banderas para resta
					 carry = sum[N-1] == 1 ? 1 : 0;
					 overflow = (A[N-1] == B[N-1]) && (result[N-1] != A[N-1]);
					 negative = result[N-1];
					 result_signed = A_signed - B_signed; 
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
                result_signed = (B != 0) ? (A_signed / B_signed) : 0;
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
                result_signed = (B != 0) ? (A_signed % B_signed) : 0;
            end

            4'b0111: begin // XOR
                result = A ^ B;
                
                // Banderas para XOR
                carry = 0;
                overflow = 0;
                negative = result[N-1];
                result_signed = A_signed ^ B_signed;
            end

            4'b1000: begin // Shift left
                result = A << B;  // Desplazamiento a la izquierda, cantidad B veces
                carry = A[N-1];   // El bit desplazado se coloca en carry
                overflow = 0;     // No se genera overflow en un shift normal
                negative = result[N-1]; // Bandera negativa
                result_signed = A_signed << B; // Shift aritmético para mantener signo
            end

            4'b1001: begin // Shift right
                result = A >> B;  // Desplazamiento a la derecha, cantidad B veces
                carry = A[0];     // El bit desplazado se coloca en carry
                overflow = 0;     // No se genera overflow en un shift normal
                negative = result[N-1]; // Bandera negativa
                result_signed = A_signed >>> B; // Shift aritmético para mantener signo
            end
        endcase
        
        // Bandera Zero común a todas las operaciones
        zero = (result == 0);
        
        // Determinar si el resultado es negativo y su valor absoluto
        is_negative = result_signed[N];
        abs_value = is_negative ? (-result_signed) : result_signed;
    end
    
    // Decodificador de 7 segmentos para dígitos decimales (0-9)
    function logic [6:0] seven_seg_decoder(input logic [3:0] value);
        case (value)
            4'h0: seven_seg_decoder = 7'b1000000; // 0
            4'h1: seven_seg_decoder = 7'b1111001; // 1
            4'h2: seven_seg_decoder = 7'b0100100; // 2
            4'h3: seven_seg_decoder = 7'b0110000; // 3
            4'h4: seven_seg_decoder = 7'b0011001; // 4
            4'h5: seven_seg_decoder = 7'b0010010; // 5
            4'h6: seven_seg_decoder = 7'b0000010; // 6
            4'h7: seven_seg_decoder = 7'b1111000; // 7
            4'h8: seven_seg_decoder = 7'b0000000; // 8
            4'h9: seven_seg_decoder = 7'b0010000; // 9
            default: seven_seg_decoder = 7'b1111111; // Apagado para valores >9
        endcase
    endfunction
    
    // Decodificador para el signo negativo
    function logic [6:0] sign_decoder(input logic negative);
        sign_decoder = negative ? 7'b0111111 : 7'b1111111; // "-" o apagado
    endfunction

    // Asignar valores a los displays
    always_comb begin
        // Mostrar resultado (con signo)
        if (abs_value <= 9) begin
            HEX0 = seven_seg_decoder(abs_value[3:0]); // Dígito decimal
            HEX1 = sign_decoder(is_negative);        // Signo negativo si es necesario
        end else begin
            // Para valores >9, mostrar en hexadecimal
            HEX0 = seven_seg_decoder(result[3:0]); // Mostrar en hex si no es decimal
            HEX1 = sign_decoder(is_negative);      // Signo negativo si es necesario
        end
        
        // Mostrar entradas A y B (con signo)
        // Para A
        if (A_signed <= 9 && A_signed >= -9) begin
            HEX4 = seven_seg_decoder(A_signed[N] ? (-A_signed) : A_signed);
            HEX5 = sign_decoder(A_signed[N]);
        end else begin
            HEX4 = seven_seg_decoder(A);
            HEX5 = sign_decoder(A[N-1]);
        end
        
        // Para B
        if (B_signed <= 9 && B_signed >= -9) begin
            HEX2 = seven_seg_decoder(B_signed[N] ? (-B_signed) : B_signed);
            HEX3 = sign_decoder(B_signed[N]);
        end else begin
            HEX2 = seven_seg_decoder(B);
            HEX3 = sign_decoder(B[N-1]);
        end
    end

endmodule
