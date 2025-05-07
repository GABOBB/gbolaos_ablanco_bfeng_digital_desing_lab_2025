module VGA #(parameter
HActive = 10'd640,
HFP = 10'd16,
HSync = 10'd96,
HBP = 10'd48,
HMax = HActive + HFP + HSync + HBP,
VBP = 10'd33,
VActive = 10'd480,
VFP = 10'd10,
VSync = 10'd2,
VMax = VActive + VFP + VSync + VBP)
(input logic VGAclk,
output logic hsync, vsync, sync_b, blank_b,
output logic [9:0] x, y);

initial begin
	x = 0;
	y = 0;
end

// Contadores verticales y horizontales
always @(posedge VGAclk) begin
	x++;
	if (x == HMax) begin
			x = 0;
			y++;
	if (y == VMax) 
			y = 0;
	end
end

// Sincronización vertical y horizontal
assign hsync = ~(x >= HActive + HFP & x < HActive + HFP + HSync);
assign vsync = ~(y >= VActive + VFP & y < VActive + VFP + VSync);
assign sync_b = hsync & vsync;
assign blank_b = (x < HActive) & (y < VActive); //Poner pixeles negros en áreas fuera de rango o sin uso

endmodule