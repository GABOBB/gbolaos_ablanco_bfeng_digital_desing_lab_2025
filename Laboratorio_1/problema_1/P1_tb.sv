module P1_tb();

	logic [3:0] A;
	logic [6:0] B;
	logic [6:0] S;

	// Instancia del módulo P1
	P1 prueva1 (
		.switches(A),
		.seg_decenas(B),
		.seg_unidades(S)
	);

	// Bloque de prueba
	initial begin
		A = 4'b1111;
		#40;
		
		A = 4'b1110;  
		#40; 
	
		A = 4'b1011;  
		#40;
		
		A = 4'b0011;  
		#40;
		
		A = 4'b0001;
		#40;
		
		A = 4'b1100;
		#40;
		
		A = 4'b0101;
		#40;
		
		A = 4'b0000;
		$finish;
	end

endmodule
