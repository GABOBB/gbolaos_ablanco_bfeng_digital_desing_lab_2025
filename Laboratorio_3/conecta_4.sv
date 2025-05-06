module conecta_4 (
    input  logic clk,
    input  logic rst,
    input  logic [2:0] col_sel,
    input  logic drop,
    output logic player,
    output logic win,
    output logic draw,
    output logic [1:0] board [5:0][6:0]
);

    typedef enum logic [1:0] {
        EMPTY   = 2'b00,
        PLAYER1 = 2'b01,
        PLAYER2 = 2'b10
    } cell_t;

    cell_t state_board[5:0][6:0];
    logic [2:0] height_counter[6:0];
    logic [5:0] filled_cells;
    logic [2:0] last_row;
    logic [2:0] last_col;
    logic last_player;
    logic drop_pending;

    function automatic logic check_win(cell_t val, int row, int col);
        int count;

        // Vertical
        count = 1;
        for (int i = 1; i < 4; i++) begin
            if ((row + i) < 6 && state_board[row + i][col] == val)
                count++;
            else
                break;
        end
        for (int i = 1; i < 4; i++) begin
            if ((row >= i) && state_board[row - i][col] == val)
                count++;
            else
                break;
        end
        if (count >= 4)
            return 1;

        // Horizontal
        count = 1;
        for (int i = 1; i < 4; i++) begin
            if ((col >= i) && state_board[row][col - i] == val)
                count++;
            else
                break;
        end
        for (int i = 1; i < 4; i++) begin
            if ((col + i) < 7 && state_board[row][col + i] == val)
                count++;
            else
                break;
        end
        if (count >= 4)
            return 1;

        // Diagonal descendente (\)
        count = 1;
        for (int i = 1; i < 4; i++) begin
            if ((row + i) < 6 && (col + i) < 7 && state_board[row + i][col + i] == val)
                count++;
            else
                break;
        end
        for (int i = 1; i < 4; i++) begin
            if ((row >= i) && (col >= i) && state_board[row - i][col - i] == val)
                count++;
            else
                break;
        end
        if (count >= 4)
            return 1;

        // Diagonal ascendente (/)
        count = 1;
        for (int i = 1; i < 4; i++) begin
            if ((row >= i) && (col + i) < 7 && state_board[row - i][col + i] == val)
                count++;
            else
                break;
        end
        for (int i = 1; i < 4; i++) begin
            if ((row + i) < 6 && (col >= i) && state_board[row + i][col - i] == val)
                count++;
            else
                break;
        end
        if (count >= 4)
            return 1;

        return 0;
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            player <= 0;
            win <= 0;
            draw <= 0;
            filled_cells <= 0;
            drop_pending <= 0;
            last_player <= 0;

            for (int r = 0; r < 6; r++)
                for (int c = 0; c < 7; c++)
                    state_board[r][c] <= EMPTY;

            for (int c = 0; c < 7; c++)
                height_counter[c] <= 0;

        end else begin
            player <= player;
            win <= win;
            draw <= draw;
            drop_pending <= drop_pending;

            if (drop && !win && !draw && !drop_pending) begin
                if (height_counter[col_sel] < 6) begin
                    last_row <= height_counter[col_sel];
                    last_col <= col_sel;
                    last_player <= player;

                    state_board[height_counter[col_sel]][col_sel] <= player ? PLAYER2 : PLAYER1;
                    height_counter[col_sel] <= height_counter[col_sel] + 1;
                    filled_cells <= filled_cells + 1;
                    drop_pending <= 1;

                    $display("Jugador %0d colocó en fila=%0d, columna=%0d",
                             player, height_counter[col_sel], col_sel);
                end
            end else if (drop_pending) begin
                cell_t p;
                p = last_player ? PLAYER2 : PLAYER1;

                $display("Evaluando victoria para jugador=%0d en [%0d][%0d]", p, last_row, last_col);
                $display("  Valor en celda: %0b", state_board[last_row][last_col]);
                $display("  filled_cells: %0d", filled_cells);

                if (check_win(p, last_row, last_col)) begin
                    win <= 1;
                    $display("¡Victoria detectada para jugador=%0d!", p);
                end else if (filled_cells == 42) begin
                    draw <= 1;
                    $display("¡Empate detectado!");
                end else begin
                    player <= ~player;
                    $display("No hay victoria. Turno del siguiente jugador.");
                end
                drop_pending <= 0;
            end
        end
    end

    always_comb begin
        for (int r = 0; r < 6; r++)
            for (int c = 0; c < 7; c++)
                board[r][c] = state_board[r][c];
    end

endmodule
