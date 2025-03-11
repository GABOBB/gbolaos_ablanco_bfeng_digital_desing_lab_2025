module switchReader (
	input logic [3:0] switches,
	output logic [3:0] out
);
	assign out = switches[3:0];

endmodule

module B_to_BCD(
	input logic[3:0] b_n,
	output logic[3:0] BCD_n1,
	output logic[3:0] BCD_n2
	);
	
	always_comb begin
		if(b_n >= 10) begin
			BCD_n1 = 1;
			BCD_n2 = b_n-10;
		end else begin
			BCD_n1 = 0;
			BCD_n2 = b_n;
		end
	end
		
endmodule

module BCD_to_7Seg(
    input logic [3:0] BCD,
    output logic [6:0] seg
);
    always_comb begin
        case (BCD)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b0000000; // Apagado
        endcase
    end
endmodule
	

module P1(

	input logic[3:0] switches,
	output logic[6:0] seg_decenas,
	output logic[6:0] seg_unidades
);
	logic[3:0] b_num;
	logic[3:0] decenas;
	logic[3:0] unidades;
	
	
	switchReader sw (
		.switches(switches),
		.out(b_num)
	);
	
	
	B_to_BCD BCD(
		.b_n(b_num),
		.BCD_n1(decenas),
		.BCD_n2(unidades)
	);
	
	 BCD_to_7Seg display_decenas (
        .BCD(decenas),
        .seg(seg_decenas)
    );

    BCD_to_7Seg display_unidades (
        .BCD(unidades),
        .seg(seg_unidades)
    );
	
	
	
	

endmodule



