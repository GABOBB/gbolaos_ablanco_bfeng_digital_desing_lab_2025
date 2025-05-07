module debounce #(
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter DEBOUNCE_MS = 20
)(
    input  logic clk,
    input  logic rst,
    input  logic noisy_in,       // Entrada sin filtrar (de botón o switch)
    output logic debounced_out   // Salida filtrada
);

    localparam integer COUNT_MAX = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

    logic [31:0] counter;
    logic sync_0, sync_1, stable_state;

    // Sincronización a reloj
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_0 <= 0;
            sync_1 <= 0;
        end else begin
            sync_0 <= noisy_in;
            sync_1 <= sync_0;
        end
    end

    // Contador de estabilidad
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter      <= 0;
            stable_state <= 0;
        end else if (sync_1 != stable_state) begin
            counter <= counter + 1;
            if (counter >= COUNT_MAX) begin
                stable_state <= sync_1;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end

    assign debounced_out = stable_state;

endmodule
