module p3 #(parameter N =6) (
    input logic clk,          // Reloj principal de la FPGA
    input logic decrementar,
    input logic reset,
    input logic mas,
    input logic menos,
    input logic lock,
    output logic [6:0] HEX0,  // Display menos significativo
    output logic [6:0] HEX1,  // Display más significativo
    output logic [N-1:0] inicial,
    output logic [N-1:0] out
);

    integer decimal; // Valor en decimal

    always_ff @(negedge decrementar, negedge reset, negedge mas, negedge menos, negedge lock) begin
        if (!reset) begin // Reset asincrónico
            inicial <= 0;
            out <= 0;
        end
        else if (!decrementar) begin
            out <= out - 1;  // Decremento
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
        else if (!lock) begin
            out <= inicial;
        end
    end

    // Conversión de binario a decimal
    always_ff @(out) begin
        decimal = out; // Conversión implícita de binario a decimal
        // Prueba de que se hizo bien la conversión
        $display("Valor de out en binario: %b, valor en decimal: %d", out, decimal);
    end

    // Separar en dos dígitos de 4 bits
    logic [3:0] unidad, decena;
    assign unidad = out % 10;    // Último dígito
    assign decena = out / 10;    // Primer dígito

    // Conversión a 7 segmentos
    always_comb begin
        HEX0 = display7seg(unidad); // Display menos significativo
        HEX1 = display7seg(decena); // Display más significativo
    end

    // Función para convertir un número de 4 bits a 7 segmentos
    function logic [6:0] display7seg(input logic [3:0] num);
        case (num)
            4'h0: display7seg = 7'b1000000;
            4'h1: display7seg = 7'b1111001;
            4'h2: display7seg = 7'b0100100;
            4'h3: display7seg = 7'b0110000;
            4'h4: display7seg = 7'b0011001;
            4'h5: display7seg = 7'b0010010;
            4'h6: display7seg = 7'b0000010;
            4'h7: display7seg = 7'b1111000;
            4'h8: display7seg = 7'b0000000;
            4'h9: display7seg = 7'b0010000;
            default: display7seg = 7'b1111111; // Apagar el display si es inválido
        endcase
    endfunction

endmodule