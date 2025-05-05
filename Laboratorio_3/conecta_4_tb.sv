`timescale 1ns/1ps

module conecta_4_tb;

    logic clk = 0;
    logic rst;
    logic [2:0] column_select;
    logic play;
    logic player;
    logic win;
    logic [5:0][6:0] board; // [rows][columns] = [6][7]

    conecta_4 uut (
        .clk(clk),
        .rst(rst),
        .column_select(column_select),
        .play(play),
        .player(player),
        .win(win),
        .board(board)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to simulate a play
    task play_turn(input logic [2:0] col, input logic p);
        @(posedge clk);
        column_select = col;
        player = p;
        play = 1;
        @(posedge clk);
        play = 0;
        @(posedge clk);
    endtask

    initial begin
        // Dump signals to the wave window automatically
        $dumpfile("conecta_4_tb.vcd");       // Archivo para guardar señales
        $dumpvars(0, conecta_4_tb);          // Volcar todas las señales del testbench
        $display("Inicio de simulación...");

        rst = 1; play = 0; player = 0; column_select = 0;
        #10;
        rst = 0;

        // Turnos alternados entre jugador 0 y 1
        play_turn(0, 0); // Jugador 1
        play_turn(1, 1); // Jugador 2
        play_turn(0, 0);
        play_turn(1, 1);
        play_turn(0, 0);
        play_turn(1, 1);
        play_turn(0, 0); // Jugador 1 gana

        if (win)
            $display("¡Victoria detectada correctamente!");
        else
            $display("ERROR: No se detectó victoria.");

        #20;
        $finish;
    end
endmodule
