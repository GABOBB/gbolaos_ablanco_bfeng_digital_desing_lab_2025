module p3 #(parameter N =6) (
    input logic decrementar,
    input logic reset,
    input logic mas,
    input logic menos,
    output logic [6:0] HEX0,  // Display menos significativo
    output logic [6:0] HEX1,  // Display más significativo
    output logic [N-1:0] inicial = 0
);


    always_ff @(negedge decrementar, negedge reset, negedge mas, negedge menos) begin
        if (!reset) begin // Reset asincrónico
            inicial <= 0;
        end
        else if (!decrementar) begin
            inicial <= inicial - 1;  // Decremento
            $display("decremento");
        end
        else if (!mas) begin
            inicial <= inicial + 1; // +1 al valor inicial
            $display("suma");
        end
        else if (!menos) begin
            inicial <= inicial - 1; // -1 al valor inicial
            $display("resta");
        end
    end

    // Separar en dos dígitos de 4 bits
    logic [3:0] unidad, decena;
    assign unidad = inicial % 10;    // Último dígito
    assign decena = inicial / 10;    // Primer dígito

    // Conversión a 7 segmentos
    always_comb begin
        HEX0 = display7seg(unidad); // Display menos significativo
        HEX1 = display7seg(decena); // Display más significativo
    end

    // Función para convertir un número de 4 bits a 7 segmentos
    function logic [6:0] display7seg(input logic [3:0] num);
        case (num)
            4'b0000: display7seg = 7'b1000000;
            4'b0001: display7seg = 7'b1111001;
            4'b0010: display7seg = 7'b0100100;
            4'b0011: display7seg = 7'b0110000;
            4'b0100: display7seg = 7'b0011001;
            4'b0101: display7seg = 7'b0010010;
            4'b0110: display7seg = 7'b0000010;
            4'b0111: display7seg = 7'b1111000;
            4'b1000: display7seg = 7'b0000000;
            4'b1001: display7seg = 7'b0011000;
            default: display7seg = 7'b1111111; // Apagar el display si es inválido
        endcase
    endfunction

endmodule