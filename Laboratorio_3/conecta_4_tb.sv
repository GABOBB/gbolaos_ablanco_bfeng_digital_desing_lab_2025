`timescale 1ns/1ps

module conecta_4_tb;

    logic clk = 0;
    logic rst;
    logic [2:0] column_select;
    logic play;
    logic player;
    logic win;
    logic draw;
    logic [1:0] board [5:0][6:0];

    conecta_4 uut (
        .clk(clk),
        .rst(rst),
        .col_sel(column_select),
        .drop(play),
        .player(player),
        .win(win),
        .draw(draw),
        .board(board)
    );

    always #5 clk = ~clk;

    task play_turn(input logic [2:0] col);
        @(posedge clk);
        column_select = col;
        play = 1;
        @(posedge clk);
        play = 0;
        @(posedge clk);
    endtask

    task reset_game();
        rst = 1;
        play = 0;
        column_select = 0;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
    endtask

    task check_victory(input string label);
        repeat (2) @(posedge clk);
        if (win)
            $display("✔ %s: Victoria detectada correctamente.", label);
        else
            $display("✘ %s: ERROR, no se detectó victoria.", label);
    endtask

    initial begin
        $display("=== INICIO DE SIMULACIÓN ===");

        // Caso 1: Victoria vertical
        reset_game();
        play_turn(0); // J1
        play_turn(1); // J2
        play_turn(0); // J1
        play_turn(1); // J2
        play_turn(0); // J1
        play_turn(1); // J2
        play_turn(0); // J1
        check_victory("Vertical");

        // Caso 2: Victoria horizontal
        reset_game();
        play_turn(0); // J1
        play_turn(0); // J2 (basura)
        play_turn(1); // J1
        play_turn(1); // J2 (basura)
        play_turn(2); // J1
        play_turn(2); // J2 (basura)
        play_turn(3); // J1
        check_victory("Horizontal");

        // Caso 3: Diagonal descendente (\)
        reset_game();
        play_turn(0); // J1
        play_turn(1); // J2
        play_turn(1); // J1
        play_turn(2); // J2
        play_turn(2); // J1
        play_turn(3); // J2
        play_turn(2); // J1
        play_turn(3); // J2
        play_turn(3); // J1
        play_turn(4); // J2
        play_turn(3); // J1
        check_victory("Diagonal descendente");

        // Caso 4: Diagonal ascendente (/)
        reset_game();
        play_turn(3); // J1
        play_turn(2); // J2
        play_turn(2); // J1
        play_turn(1); // J2
        play_turn(1); // J1
        play_turn(0); // J2
        play_turn(1); // J1
        play_turn(0); // J2
        play_turn(0); // J1
        play_turn(4); // J2
        play_turn(0); // J1
        check_victory("Diagonal ascendente");

        #20;
        $display("=== FIN DE SIMULACIÓN ===");
        $finish;
    end

endmodule
