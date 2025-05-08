module vga_pll (
    input logic refclk,   // Reloj de 50 MHz
    input logic rst,      // No usado en esta versión
    output logic outclk_0, // Salida de ~25 MHz
    output logic locked    // Siempre activo en simulación
);

    logic [0:0] div;
    assign locked = 1'b1; // Siempre "locked"

    always_ff @(posedge refclk or posedge rst) begin
        if (rst)
            div <= 0;
        else
            div <= ~div;
    end

    assign outclk_0 = div;

endmodule
