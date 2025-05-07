`timescale 1ns/1ps

module tb_toplevel_connect4();

// Señales de entrada
reg clk;
reg rst;
reg col_left_raw, col_right_raw, confirm_raw;
reg p1_start_raw, p2_start_raw;

// Señales de salida
wire vgaclk, hsync, vsync, sync_b, blank_b;
wire [7:0] r, g, b;
wire [6:0] segments;
wire p1_led, p2_led, game_over_led;
wire [3:0] estado;

// Instancia del diseño bajo prueba
toplevel_connect4 DUT (
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

// Generación de reloj principal (50 MHz)
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// Tareas para interacciones de usuario
task press_button(input btn);
begin
    @(posedge clk);
    force btn = 1;
    @(posedge clk);
    release btn;
end
endtask

task reset_system();
begin
    rst = 1;
    col_left_raw = 0;
    col_right_raw = 0;
    confirm_raw = 0;
    p1_start_raw = 0;
    p2_start_raw = 0;
    #100;
    rst = 0;
    #100;
end
endtask

// Test 1: Inicio del sistema y pantalla inicial
task test_initial_state();
begin
    $display("Test 1: Verificar estado inicial");
    
    // Verificar estado y salidas VGA
    if (estado !== 4'b0000) $error("Estado inicial incorrecto");
    if (r === 0 && g === 0 && b === 0) $error("Pantalla inicial no activa");
    
    $display("Test 1 completado exitosamente");
end
endtask

// Test 2: Inicio de juego por P1
task test_p1_start();
begin
    $display("Test 2: Inicio juego por Jugador 1");
    
    press_button(DUT.p1_start_debounced);
    #200;
    
    if (estado !== 4'b0010) $error("No en estado TURNO_P1");
    if (!p1_led) $error("LED P1 no activo");
    
    $display("Test 2 completado exitosamente");
end
endtask

// Test 3: Movimiento válido de jugador
task test_valid_move();
begin
    $display("Test 3: Realizar movimiento válido");
    
    // Seleccionar columna 3
    press_button(DUT.confirm_debounced);
    #200;
    
    // Verificar matriz actualizada
    if (DUT.matrix[76+:2] !== 2'b01) 
        $error("Ficha P1 no colocada correctamente");
    
    $display("Test 3 completado exitosamente");
end
endtask

// Test 4: Detección de victoria horizontal
task test_win_condition();
begin
    $display("Test 4: Detectar línea ganadora horizontal");
    
    // Forzar condición de victoria
    force DUT.matrix = 84'h0000000000000000000FFF;
    #100;
    
    if (!DUT.winner_found) $error("Detección de ganador falló");
    if (DUT.winning_line !== 24'h0003000C) 
        $error("Línea ganadora incorrecta");
    
    release DUT.matrix;
    $display("Test 4 completado exitosamente");
end
endtask

// Test 5: Finalización de juego
task test_game_over();
begin
    $display("Test 5: Transición a Game Over");
    
    if (estado !== 4'b1000) $error("No en estado GAME_OVER");
    if (!game_over_led) $error("LED Game Over no activo");
    if (r === 0 && g === 0 && b === 0) 
        $error("Pantalla final no activa");
    
    $display("Test 5 completado exitosamente");
end
endtask

// Secuencia principal de pruebas
initial begin
    // Inicialización
    reset_system();
    
    // Ejecutar tests
    test_initial_state();
    test_p1_start();
    test_valid_move();
    test_win_condition();
    test_game_over();
    
    // Finalizar simulación
    #100;
    $display("Todos los tests completados exitosamente!");
    $finish;
end

endmodule