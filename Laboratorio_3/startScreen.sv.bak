module startScreen (
    input logic clk,
    input logic [9:0] x_pos, y_pos,
    output logic [7:0] red, green, blue
);

    always_comb begin
        // Fondo azul por defecto
        red   = 8'd0;
        green = 8'd0;
        blue  = 8'd255;

        // Rectángulo blanco central de 200x100 px
        if (x_pos >= 220 && x_pos <= 420 &&
            y_pos >= 190 && y_pos <= 290) begin
            red   = 8'd255;
            green = 8'd255;
            blue  = 8'd255;
        end
    end

endmodule
