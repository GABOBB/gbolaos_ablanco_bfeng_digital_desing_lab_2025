module SumadorCompleto1Bit (
    input logic A, B, Cin,
    output logic S, Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

module p2 (
    input logic [9:0] SW,  // Switches de entrada
    output logic [6:0] HEX0, HEX1, HEX2, HEX3 // 4 Displays de 7 segmentos
);
    logic [3:0] A, B, S;
    logic Cin;
    logic Cout;
    
    assign A = SW[3:0];  // Primer operando (4 switches)
    assign B = SW[7:4];  // Segundo operando (4 switches)
    assign Cin = SW[8];  // Acarreo de entrada (1 switch)

    logic [4:0] C;
    assign C[0] = Cin;

    SumadorCompleto1Bit Sumador0 (.A(A[0]), .B(B[0]), .Cin(C[0]), .S(S[0]), .Cout(C[1]));
    SumadorCompleto1Bit Sumador1 (.A(A[1]), .B(B[1]), .Cin(C[1]), .S(S[1]), .Cout(C[2]));
    SumadorCompleto1Bit Sumador2 (.A(A[2]), .B(B[2]), .Cin(C[2]), .S(S[2]), .Cout(C[3]));
    SumadorCompleto1Bit Sumador3 (.A(A[3]), .B(B[3]), .Cin(C[3]), .S(S[3]), .Cout(C[4]));

    // Asignación de los displays de 7 segmentos para mostrar el resultado de la suma
    always_comb begin
        // Asignación a HEX0 (Primer nibble de S)
        case (S[3:0]) // 4 bits de la suma
            4'h0: HEX0 = 7'b1000000; // 0
            4'h1: HEX0 = 7'b1111001; // 1
            4'h2: HEX0 = 7'b0100100; // 2
            4'h3: HEX0 = 7'b0110000; // 3
            4'h4: HEX0 = 7'b0011001; // 4
            4'h5: HEX0 = 7'b0010010; // 5
            4'h6: HEX0 = 7'b0000010; // 6
            4'h7: HEX0 = 7'b1111000; // 7
            4'h8: HEX0 = 7'b0000000; // 8
            4'h9: HEX0 = 7'b0010000; // 9
            4'hA: HEX0 = 7'b0001000; // A
            4'hB: HEX0 = 7'b0000011; // B
            4'hC: HEX0 = 7'b1000110; // C
            4'hD: HEX0 = 7'b0100001; // D
            4'hE: HEX0 = 7'b0000110; // E
            4'hF: HEX0 = 7'b0001110; // F
            default: HEX0 = 7'b1111111; // Apagado
        endcase

        // Asignación a HEX1 (Segundo nibble de S)
        case (S[3:0]) // 4 bits de la suma
            4'h0: HEX1 = 7'b1000000; // 0
            4'h1: HEX1 = 7'b1111001; // 1
            4'h2: HEX1 = 7'b0100100; // 2
            4'h3: HEX1 = 7'b0110000; // 3
            4'h4: HEX1 = 7'b0011001; // 4
            4'h5: HEX1 = 7'b0010010; // 5
            4'h6: HEX1 = 7'b0000010; // 6
            4'h7: HEX1 = 7'b1111000; // 7
            4'h8: HEX1 = 7'b0000000; // 8
            4'h9: HEX1 = 7'b0010000; // 9
            4'hA: HEX1 = 7'b0001000; // A
            4'hB: HEX1 = 7'b0000011; // B
            4'hC: HEX1 = 7'b1000110; // C
            4'hD: HEX1 = 7'b0100001; // D
            4'hE: HEX1 = 7'b0000110; // E
            4'hF: HEX1 = 7'b0001110; // F
            default: HEX1 = 7'b1111111; // Apagado
        endcase
        
        // Asignación a HEX2 (Tercer nibble de S)
        case (S[3:0]) // 4 bits de la suma
            4'h0: HEX2 = 7'b1000000; // 0
            4'h1: HEX2 = 7'b1111001; // 1
            4'h2: HEX2 = 7'b0100100; // 2
            4'h3: HEX2 = 7'b0110000; // 3
            4'h4: HEX2 = 7'b0011001; // 4
            4'h5: HEX2 = 7'b0010010; // 5
            4'h6: HEX2 = 7'b0000010; // 6
            4'h7: HEX2 = 7'b1111000; // 7
            4'h8: HEX2 = 7'b0000000; // 8
            4'h9: HEX2 = 7'b0010000; // 9
            4'hA: HEX2 = 7'b0001000; // A
            4'hB: HEX2 = 7'b0000011; // B
            4'hC: HEX2 = 7'b1000110; // C
            4'hD: HEX2 = 7'b0100001; // D
            4'hE: HEX2 = 7'b0000110; // E
            4'hF: HEX2 = 7'b0001110; // F
            default: HEX2 = 7'b1111111; // Apagado
        endcase
        
        // Asignación a HEX3 (Cuarto nibble de S)
        case (S[3:0]) // 4 bits de la suma
            4'h0: HEX3 = 7'b1000000; // 0
            4'h1: HEX3 = 7'b1111001; // 1
            4'h2: HEX3 = 7'b0100100; // 2
            4'h3: HEX3 = 7'b0110000; // 3
            4'h4: HEX3 = 7'b0011001; // 4
            4'h5: HEX3 = 7'b0010010; // 5
            4'h6: HEX3 = 7'b0000010; // 6
            4'h7: HEX3 = 7'b1111000; // 7
            4'h8: HEX3 = 7'b0000000; // 8
            4'h9: HEX3 = 7'b0010000; // 9
            4'hA: HEX3 = 7'b0001000; // A
            4'hB: HEX3 = 7'b0000011; // B
            4'hC: HEX3 = 7'b1000110; // C
            4'hD: HEX3 = 7'b0100001; // D
            4'hE: HEX3 = 7'b0000110; // E
            4'hF: HEX3 = 7'b0001110; // F
            default: HEX3 = 7'b1111111; // Apagado
        endcase
    end
endmodule
