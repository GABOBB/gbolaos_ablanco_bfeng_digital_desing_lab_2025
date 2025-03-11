module p2_tb();
    logic [3:0] A, B;
    logic Cin;
    logic [3:0] S;
    logic Cout;
    
    // Instancia del módulo bajo prueba (DUT)
    p2 DUT(A, B, Cin, S, Cout);
    
    initial begin
        A = 4'b0011; B = 4'b0101; Cin = 0;
        #40;
        
        A = 4'b0111; B = 4'b1000; Cin = 0;
        #40;
        
        A = 4'b1111; B = 4'b0001; Cin = 0;
        #40;
        
        A = 4'b0110; B = 4'b1001; Cin = 0;
        #40;
    end
endmodule