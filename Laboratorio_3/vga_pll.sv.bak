// vga_pll.sv - PLL simulado para generar 25.175 MHz desde 50 MHz
module vga_pll(
    input  logic refclk,    // Reloj de entrada 50 MHz
    input  logic rst,       // Reset activo alto
    output logic outclk_0,  // Reloj de salida ~25.175 MHz
    output logic locked     // Siempre "1" en este mock
);

    // Este módulo simula el PLL para pruebas
    // En hardware real, se debe usar la IP PLL de Intel

    logic [1:0] clk_divider;
    logic clk_internal;

    initial begin
        outclk_0 = 0;
        clk_divider = 0;
    end

    assign locked = 1'b1;

    // Simulación simple: dividir 50 MHz a ~25 MHz
    always_ff @(posedge refclk or posedge rst) begin
        if (rst) begin
            clk_divider <= 0;
            outclk_0 <= 0;
        end else begin
            clk_divider <= clk_divider + 1;
            if (clk_divider == 1)
                outclk_0 <= ~outclk_0;
        end
    end

endmodule
