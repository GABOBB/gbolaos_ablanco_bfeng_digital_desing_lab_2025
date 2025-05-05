module conecta_4 (
    input  logic clk,
    input  logic rst,
    input  logic [2:0] col_sel,
    input  logic drop,
    output logic player,
    output logic win,
    output logic draw,
    output logic [1:0] board [5:0][6:0]  // Cada celda: EMPTY = 00, PLAYER1 = 01, PLAYER2 = 10
);

    typedef enum logic [1:0] {
        EMPTY   = 2'b00,
        PLAYER1 = 2'b01,
        PLAYER2 = 2'b10
    } cell_t;

    cell_t state_board[5:0][6:0];
    logic [2:0] height_counter[6:0];  // Almacena altura (0 a 5) por columna
    logic [5:0] filled_cells;

    // Variable auxiliar para almacenar fila calculada fuera del always_ff
    logic [2:0] row_temp;

    // Función para verificar victoria (solo horizontal y vertical simplificada por compatibilidad)
    function automatic logic check_win(cell_t val, int row, int col);
        logic result = 0;

        // Horizontal
        if (col <= 3) begin
            result |= (state_board[row][col+1] == val &&
                       state_board[row][col+2] == val &&
                       state_board[row][col+3] == val);
        end

        // Vertical
        if (row <= 2) begin
            result |= (state_board[row+1][col] == val &&
                       state_board[row+2][col] == val &&
                       state_board[row+3][col] == val);
        end

        return result;
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            player <= 0;
            win    <= 0;
            draw   <= 0;
            filled_cells <= 0;

            for (int r = 0; r < 6; r++)
                for (int c = 0; c < 7; c++)
                    state_board[r][c] <= EMPTY;

            for (int c = 0; c < 7; c++)
                height_counter[c] <= 0;

        end else if (drop && !win && !draw) begin
            if (height_counter[col_sel] < 6) begin
                row_temp = height_counter[col_sel]; // se guarda fuera de asignación dinámica
                state_board[row_temp][col_sel] <= player ? PLAYER2 : PLAYER1;
                height_counter[col_sel] <= height_counter[col_sel] + 1;

                if (check_win(player ? PLAYER2 : PLAYER1, row_temp, col_sel)) begin
                    win <= 1;
                end else begin
                    filled_cells <= filled_cells + 1;
                    if (filled_cells == 41)  // 42 fichas, índice inicia en 0
                        draw <= 1;
                    else
                        player <= ~player;
                end
            end
        end
    end

    // Conexión del tablero interno al de salida
    always_comb begin
        for (int r = 0; r < 6; r++)
            for (int c = 0; c < 7; c++)
                board[r][c] = state_board[r][c];
    end

endmodule
