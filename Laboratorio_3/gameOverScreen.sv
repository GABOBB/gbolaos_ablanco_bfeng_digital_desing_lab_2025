module gameOverScreen (
    input logic clk,
    input logic [9:0] x_pos,
    input logic [9:0] y_pos,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    // Fondo rojo
    always_comb begin
        red   = 8'hFF;
        green = 8'h00;
        blue  = 8'h00;

        // Ojos: dos círculos negros
        if ((x_pos - 200)**2 + (y_pos - 150)**2 < 225 || // ojo izquierdo
            (x_pos - 440)**2 + (y_pos - 150)**2 < 225)   // ojo derecho
        begin
            red   = 8'h00;
            green = 8'h00;
            blue  = 8'h00;
        end

        // Boca: línea recta negra
        if ((x_pos >= 200 && x_pos <= 440) && (y_pos >= 300 && y_pos <= 310)) begin
            red   = 8'h00;
            green = 8'h00;
            blue  = 8'h00;
        end
    end

endmodule
