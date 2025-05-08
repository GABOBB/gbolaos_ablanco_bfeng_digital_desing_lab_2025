module countdown_timer (
    input logic clk,
    input logic rst,
    input logic start,
    output logic [6:0] seg, // salida para display 7 segmentos (decodificado)
    output logic done
);

    parameter CLOCK_FREQ = 50_000_000; // 50 MHz
    parameter ONE_SECOND = CLOCK_FREQ;

    logic [25:0] clk_count;
    logic [3:0] counter;
    logic running;

    // Decodificador de 7 segmentos
    function automatic [6:0] decode_7seg(input [3:0] val);
        case (val)
            4'd0: decode_7seg = 7'b1000000;
            4'd1: decode_7seg = 7'b1111001;
            4'd2: decode_7seg = 7'b0100100;
            4'd3: decode_7seg = 7'b0110000;
            4'd4: decode_7seg = 7'b0011001;
            4'd5: decode_7seg = 7'b0010010;
            4'd6: decode_7seg = 7'b0000010;
            4'd7: decode_7seg = 7'b1111000;
            4'd8: decode_7seg = 7'b0000000;
            4'd9: decode_7seg = 7'b0010000;
            default: decode_7seg = 7'b1111111;
        endcase
    endfunction

    // Lógica principal del temporizador
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            counter <= 10;
            running <= 0;
            done <= 0;
        end else begin
            if (start && !running) begin
                running <= 1;
                clk_count <= 0;
                counter <= 10;
                done <= 0;
            end else if (running) begin
                if (clk_count < ONE_SECOND) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (counter > 0)
                        counter <= counter - 1;
                    else begin
                        running <= 0;
                        done <= 1;
                    end
                end
            end
        end
    end

    assign seg = decode_7seg(counter);

endmodule
