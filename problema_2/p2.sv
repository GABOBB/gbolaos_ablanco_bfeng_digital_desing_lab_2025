module SumadorCompleto1Bit (
    input logic A, B, Cin,
    output logic S, Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

module p2 (
    input logic [3:0] A, B,
    input logic Cin,
    output logic [3:0] S,
    output logic Cout
);
    logic [4:0] C;
    assign C[0] = Cin;
    
    SumadorCompleto1Bit Sumador0 (.A(A[0]), .B(B[0]), .Cin(C[0]), .S(S[0]), .Cout(C[1]));
    SumadorCompleto1Bit Sumador1 (.A(A[1]), .B(B[1]), .Cin(C[1]), .S(S[1]), .Cout(C[2]));
    SumadorCompleto1Bit Sumador2 (.A(A[2]), .B(B[2]), .Cin(C[2]), .S(S[2]), .Cout(C[3]));
    SumadorCompleto1Bit Sumador3 (.A(A[3]), .B(B[3]), .Cin(C[3]), .S(S[3]), .Cout(C[4]));
    
    assign Cout = C[4];
endmodule