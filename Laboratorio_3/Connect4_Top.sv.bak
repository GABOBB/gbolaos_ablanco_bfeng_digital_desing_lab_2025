module Connect4_Top (
    input clk,
    input rst, // Reset activo alto

    // --- Entradas RAW Controles Compartidos ---
    input col_left_raw,
    input col_right_raw,
    input confirm_raw,
    // --- Entradas RAW Inicio Separadas ---
    input p1_start_raw,
    input p2_start_raw,

    // --- Salidas VGA ---
    output vgaclk,
    output hsync,
    output vsync,
    output sync_b,
    output blank_b,
    output [7:0] r, // << Salidas finales multiplexadas
    output [7:0] g,
    output [7:0] b,
    output [6:0] segments,
    output p1_led,
    output p2_led,
    output game_over_led,
    output [3:0] estado
);

    // --- PARÁMETROS GLOBALES ---
    localparam CLK_FREQUENCY = 50_000_000; 
    localparam DEBOUNCE_MS = 10;

    // --- Señales Internas ---
    wire [9:0] x, y; // Coordenadas desde vgaController
    wire [83:0] matrix;
    wire [2:0] selected_col;
    wire load_matrix;
    wire move_valid;
    wire [3:0] timer_count;
    wire timer_done;
    wire winner_found;
    wire board_full;
    wire [23:0] winning_line;
    wire random_move;
    wire random_move_valid;
    wire [2:0] random_col;
    wire [6:0] valid_columns;
    wire reset_timer;
    wire [1:0] current_player;


    // --- Señales RGB intermedias para los dos generadores de video ---
    wire [7:0] game_r, game_g, game_b;     // RGB desde videoGen (tablero del juego)
    wire [7:0] start_r, start_g, start_b; // RGB desde startScreen

    logic is_initial_state_active; // Para controlar el multiplexor de video
	 logic is_game_over_state_active; 


    // --- Instancia Controlador VGA ---
    // Genera vgaclk, hsync, vsync, sync_b, blank_b, x, y
    VGA vgaCont(
        .VGAclk(vgaclk), .hsync(hsync), .vsync(vsync), .sync_b(sync_b),
        .blank_b(blank_b), .x(x), .y(y)
    );

    // --- Lógica Columnas Válidas (Sin cambios) ---
    assign valid_columns[6] = (matrix[(5*7 + 6)*2 +: 2] == 2'b00); // Col 6, Fila Datos 5 (VISUALMENTE ARRIBA)
    assign valid_columns[5] = (matrix[(5*7 + 5)*2 +: 2] == 2'b00); // Col 5, Fila Datos 5
    assign valid_columns[4] = (matrix[(5*7 + 4)*2 +: 2] == 2'b00); // Col 4, Fila Datos 5
    assign valid_columns[3] = (matrix[(5*7 + 3)*2 +: 2] == 2'b00); // Col 3, Fila Datos 5
    assign valid_columns[2] = (matrix[(5*7 + 2)*2 +: 2] == 2'b00); // Col 2, Fila Datos 5
    assign valid_columns[1] = (matrix[(5*7 + 1)*2 +: 2] == 2'b00); // Col 1, Fila Datos 5
    assign valid_columns[0] = (matrix[(5*7 + 0)*2 +: 2] == 2'b00); // Col 0, Fila Datos 5


    // --- Instancia Generador Video VGA para el JUEGO ---
    videoGen gameBoardDrawer ( 
        .clk(clk),       
        .rst_n(~rst),
        .x_pos(x),
        .y_pos(y),
        .grid_state(matrix),
        .current_state(estado), // Para que videoGen sepa si es P_INICIO, GAME_OVER, etc.
        .selected_col(selected_col),
        .winning_line(winning_line),
        .red(game_r),    // Salida R del dibujador del juego
        .green(game_g),  // Salida G del dibujador del juego
        .blue(game_b)    // Salida B del dibujador del juego
    );

    // --- INSTANCIAR TU MÓDULO startScreen ---
    assign is_initial_state_active = (estado == 4'b0000); // P_INICIO desde FSM
	 assign is_game_over_state_active = (estado == 4'b1000); // GAME_OVER

                   

    // --- Multiplexor de Salida RGB Final ---
    // Si es el estado inicial, usa los colores de startScreen, si no, los de videoGen (juego)
    assign r = is_initial_state_active ? start_r : game_r;
    assign g = is_initial_state_active ? start_g : game_g;
    assign b = is_initial_state_active ? start_b : game_b;

    // --- Lógica Combinacional: Tablero Lleno ---
    assign board_full = (valid_columns == 7'b0) && !winner_found;

endmodule