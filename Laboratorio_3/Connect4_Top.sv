module Connect4_Top (
    input clk,
    input rst,

    input col_left_raw,
    input col_right_raw,
    input confirm_raw,
    input p1_start_raw,
    input p2_start_raw,

    output vgaclk,
    output hsync,
    output vsync,
    output sync_b,
    output blank_b,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b,
    output [6:0] segments,
    output p1_led,
    output p2_led,
    output game_over_led,
    output [3:0] estado
);

    // Señales debounced
    wire col_left_clean;
    wire col_right_clean;
    wire confirm_clean;

    debounce db_left (
    .clk(clk), .rst(rst),
    .noisy_in(col_left_raw),
    .debounced_out(col_left_clean)
);

debounce db_right (
    .clk(clk), .rst(rst),
    .noisy_in(col_right_raw),
    .debounced_out(col_right_clean)
);

debounce db_confirm (
    .clk(clk), .rst(rst),
    .noisy_in(confirm_raw),
    .debounced_out(confirm_clean)
);


    // Clock PLL para VGA
    wire clk_25MHz;
    vga_pll pll_inst (
        .refclk(clk),
        .rst(0),
        .outclk_0(clk_25MHz),
        .locked()
    );
    assign vgaclk = clk_25MHz;

    wire [9:0] x, y;
    wire [83:0] matrix;
    wire [2:0] selected_col;
    wire [3:0] timer_count;
    wire [6:0] valid_columns;
    wire [23:0] winning_line;
    wire [7:0] game_r, game_g, game_b;
    wire [7:0] start_r, start_g, start_b;

    logic is_initial_state_active;
    logic is_game_over_state_active;

    logic [3:0] estado_internal;
    assign estado = estado_internal;

    logic [2:0] col_sel;
    logic drop;
    logic player, win, draw;
    logic [1:0] board[5:0][6:0];

    typedef enum logic [3:0] {
        P_INICIO     = 4'b0000,
        JUGADA_P1    = 4'b0001,
        JUGADA_P2    = 4'b0010,
        GAME_OVER    = 4'b1000
    } estado_t;

    estado_t estado_reg, estado_sig;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) estado_reg <= P_INICIO;
        else     estado_reg <= estado_sig;
    end

    always_comb begin
        estado_sig = estado_reg;
        case (estado_reg)
            P_INICIO:   if (confirm_clean) estado_sig = JUGADA_P1;
            JUGADA_P1:  estado_sig = win ? GAME_OVER : JUGADA_P2;
            JUGADA_P2:  estado_sig = win ? GAME_OVER : JUGADA_P1;
            GAME_OVER:  if (confirm_clean) estado_sig = P_INICIO;
            default:    estado_sig = P_INICIO;
        endcase
    end

    assign estado_internal = estado_reg;

    VGA vgaCont(
        .VGAclk(clk_25MHz),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .x(x),
        .y(y)
    );

    conecta_4 game_inst (
        .clk(clk),
        .rst(rst),
        .col_sel(selected_col),
        .drop(confirm_clean),
        .player(player),
        .win(win),
        .draw(draw),
        .board(board)
    );

    genvar r_i, c;
    generate
        for (r_i = 0; r_i < 6; r_i++) begin : fila
            for (c = 0; c < 7; c++) begin : columna
                assign matrix[((r_i*7 + c)*2) +: 2] = board[r_i][c];
            end
        end
    endgenerate

    assign valid_columns[6] = (matrix[(5*7 + 6)*2 +: 2] == 2'b00);
    assign valid_columns[5] = (matrix[(5*7 + 5)*2 +: 2] == 2'b00);
    assign valid_columns[4] = (matrix[(5*7 + 4)*2 +: 2] == 2'b00);
    assign valid_columns[3] = (matrix[(5*7 + 3)*2 +: 2] == 2'b00);
    assign valid_columns[2] = (matrix[(5*7 + 2)*2 +: 2] == 2'b00);
    assign valid_columns[1] = (matrix[(5*7 + 1)*2 +: 2] == 2'b00);
    assign valid_columns[0] = (matrix[(5*7 + 0)*2 +: 2] == 2'b00);

    // Control del selector de columna
    logic [2:0] selected_col_reg;
    assign selected_col = selected_col_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            selected_col_reg <= 3'd0;
        else if (estado_reg == JUGADA_P1 || estado_reg == JUGADA_P2) begin
            if (col_left_clean && selected_col_reg > 0 && valid_columns[selected_col_reg - 1])
                selected_col_reg <= selected_col_reg - 1;
            else if (col_right_clean && selected_col_reg < 6 && valid_columns[selected_col_reg + 1])
                selected_col_reg <= selected_col_reg + 1;
        end
    end

    videoGen gameBoardDrawer ( 
        .clk(clk),       
        .rst_n(~rst),
        .x_pos(x),
        .y_pos(y),
        .grid_state(matrix),
        .current_state(estado),
        .selected_col(selected_col),
        .winning_line(winning_line),
        .red(game_r),
        .green(game_g),
        .blue(game_b)
    );

    startScreen start (
        .clk(clk),
        .x_pos(x),
        .y_pos(y),
        .red(start_r),
        .green(start_g),
        .blue(start_b)
    );

    assign is_initial_state_active = (estado == 4'b0000);
    assign is_game_over_state_active = (estado == 4'b1000);

    assign r = is_initial_state_active ? start_r : game_r;
    assign g = is_initial_state_active ? start_g : game_g;
    assign b = is_initial_state_active ? start_b : game_b;

    assign board_full = (valid_columns == 7'b0) && !win;

    always_comb begin
        case (estado)
            4'b0000: segments = 7'b1000000;
            4'b0001: segments = 7'b1111001;
            4'b0010: segments = 7'b0100100;
            4'b1000: segments = 7'b0000001;
            default: segments = 7'b1111111;
        endcase
    end

endmodule
