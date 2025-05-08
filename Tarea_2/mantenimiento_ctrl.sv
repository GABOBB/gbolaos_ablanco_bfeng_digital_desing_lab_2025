module mantenimiento_ctrl (
    input logic clk,
    input logic rst_n,
    input logic boton_mantenimiento,  // Botón de mantenimiento
    input logic reset_manual,        // Reset manual desde fuera
    output logic [7:0] registro_estado
);

    typedef enum logic [1:0] {
        ESPERA = 2'b00,
        MANTENIMIENTO = 2'b01,
        ERROR_TIMEOUT = 2'b10
    } estado_t;

    estado_t estado_actual, estado_siguiente;
    logic [7:0] contador_mantenimientos;
    logic [7:0] tiempo_espera;

    // Estado actual
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            estado_actual <= ESPERA;
        else if (reset_manual)
            estado_actual <= ESPERA;
        else
            estado_actual <= estado_siguiente;
    end

    // Lógica de estado siguiente y salidas
    always_comb begin
        estado_siguiente = estado_actual;
        case (estado_actual)
            ESPERA: begin
                if (boton_mantenimiento)
                    estado_siguiente = MANTENIMIENTO;
                else if (tiempo_espera == 8'd200)
                    estado_siguiente = ERROR_TIMEOUT;
            end
            MANTENIMIENTO: begin
                estado_siguiente = ESPERA;
            end
            ERROR_TIMEOUT: begin
                // Solo se sale con reset_manual o rst_n
                estado_siguiente = ERROR_TIMEOUT;
            end
        endcase
    end

    // Contadores y registro de estado
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tiempo_espera <= 8'd0;
            contador_mantenimientos <= 8'd0;
            registro_estado <= 8'd0;
        end else if (reset_manual) begin
            tiempo_espera <= 8'd0;
            registro_estado <= 8'd0;
        end else begin
            case (estado_actual)
                ESPERA: begin
                    if (!boton_mantenimiento)
                        tiempo_espera <= tiempo_espera + 1;
                    else
                        tiempo_espera <= 0;
                end
                MANTENIMIENTO: begin
                    contador_mantenimientos <= contador_mantenimientos + 1;
                    registro_estado <= contador_mantenimientos + 1;
                    tiempo_espera <= 0;
                end
                ERROR_TIMEOUT: begin
                    registro_estado <= 8'hFF;
                end
            endcase
        end
    end

endmodule