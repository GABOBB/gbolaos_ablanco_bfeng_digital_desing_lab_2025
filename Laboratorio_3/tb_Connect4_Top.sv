`timescale 1ns/1ps

module tb_Connect4_Top;

    logic clk = 0;
    logic rst;

    logic col_left_raw, col_right_raw, confirm_raw;
    logic p1_start_raw, p2_start_raw;

    wire vgaclk, hsync, vsync, sync_b, blank_b;
    wire [7:0] r, g, b;
    wire [6:0] segments;
    wire p1_led, p2_led, game_over_led;
    wire [3:0] estado;

    // Instancia del Top
    Connect4_Top uut (
        .clk(clk),
        .rst(rst),
        .col_left_raw(col_left_raw),
        .col_right_raw(col_right_raw),
        .confirm_raw(confirm_raw),
        .p1_start_raw(p1_start_raw),
        .p2_start_raw(p2_start_raw),
        .vgaclk(vgaclk),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .r(r),
        .g(g),
        .b(b),
        .segments(segments),
        .p1_led(p1_led),
        .p2_led(p2_led),
        .game_over_led(game_over_led),
        .estado(estado)
    );

    // Generación de reloj
    always #10 clk = ~clk;

    initial begin
        $display("Simulación Top inicia...");
        rst = 1;
        col_left_raw = 0;
        col_right_raw = 0;
        confirm_raw = 0;
        p1_start_raw = 0;
        p2_start_raw = 0;

        #50;
        rst = 0;
        #50;

        // Simular inicio del juego
        p1_start_raw = 1; #20; p1_start_raw = 0;

        // Simular una jugada de confirm
        confirm_raw = 1; #20; confirm_raw = 0;

        #100;

        // Forzar final para cortar simulación
        $finish;
    end

endmodule
