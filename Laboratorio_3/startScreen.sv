module startScreen (
    input logic clk,
    input logic [9:0] x_pos,
    input logic [9:0] y_pos,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    logic in_circle;
    logic [9:0] cx = 320; // centro x
    logic [9:0] cy = 240; // centro y
    logic [19:0] dist_sqr;

    always_comb begin
        // Calculamos si estamos dentro del círculo (usamos distancia al cuadrado para evitar sqrt)
        dist_sqr = (x_pos - cx)*(x_pos - cx) + (y_pos - cy)*(y_pos - cy);
        in_circle = dist_sqr < 1000; // radio^2 = 100^2

        if (in_circle) begin
            red = 0;
            green = 0;
            blue = 0; // círculo negro
        end else begin
            red   = (x_pos < 320) ? 8'd0 : 8'd255; // azul izquierda, rojo derecha
            green = 8'd0;
            blue  = (x_pos < 320) ? 8'd255 : 8'd0;
        end
    end

endmodule
