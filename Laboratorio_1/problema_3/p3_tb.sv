module p3_tb();

	// Parámetros para las pruebas
	parameter N1 = 2;
	parameter N2 = 4;
	parameter N3 = 6;
	
	// Prueba para N = 2 bits
	logic decrementar1, reset1, mas1, menos1;
	logic [N1-1:0] inicial1;
	
	p3 #(N1) uut1 (
		.decrementar(decrementar1),
		.reset(reset1),
		.mas(mas1),
		.menos(menos1),
		.inicial(inicial1)
	);
	
	initial begin
		reset1 = 1; decrementar1 = 1; mas1 = 1; menos1 = 1; 
		#10 reset1 = 0; #10 reset1 =1;
		#10 mas1 = 0; #10 mas1 = 1;
		#10 mas1 = 0; #10 mas1 = 1;
		#10 mas1 = 0; #10 mas1 = 1;
		#10 menos1 = 0; #10 menos1 = 1;
		#10 decrementar1 = 0; #10 decrementar1 = 1;
		$display("Test N=2 bits, Final Value: %b", inicial1);
	end
	
	// Prueba para N = 4 bits
	logic decrementar2, reset2, mas2, menos2;
	logic [N2-1:0] inicial2;
	
	p3 #(N2) uut2 (
		.decrementar(decrementar2),
		.reset(reset2),
		.mas(mas2),
		.menos(menos2),
		.inicial(inicial2)
	);
	
	initial begin
		reset2 = 1; decrementar2 = 1; mas2 = 1; menos2 = 1; 
		#10 reset2 = 0; #10 reset2 =1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 mas2 = 0; #10 mas2 = 1;
		#10 menos2 = 0; #10 menos2 = 1;
		#10 decrementar2 = 0; #10 decrementar2 = 1;
		$display("Test N=4 bits, Final Value: %b", inicial2);
	end
	
	// Prueba para N = 6 bits
	logic decrementar3, reset3, mas3, menos3;
	logic [N3-1:0] inicial3;
	
	p3 #(N3) uut3 (
		.decrementar(decrementar3),
		.reset(reset3),
		.mas(mas3),
		.menos(menos3),
		.inicial(inicial3)
	);
	
	initial begin
		reset3 = 1; decrementar3 = 1; mas3 = 1; menos3 = 1; 
		#10 reset3 = 0; #10 reset3 =1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 mas3 = 0; #10 mas3 = 1;
		#10 menos3 = 0; #10 menos3 = 1;
		#10 decrementar3 = 0; #10 decrementar3 = 1;
		$display("Test N=6 bits, Final Value: %b", inicial3);
	end
	
endmodule