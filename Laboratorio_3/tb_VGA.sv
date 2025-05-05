module tb_VGA;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo del reloj (10 ns)
    
    // Señales de prueba
    logic VGAclk;
    logic hsync, vsync, sync_b, blank_b;
    logic [9:0] x, y;

    // Instanciar el módulo VGA
    VGA vga_inst (
        .VGAclk(VGAclk),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .x(x),
        .y(y)
    );

    // Generar el reloj
    initial begin
        VGAclk = 0;
        forever #(CLK_PERIOD / 2) VGAclk = ~VGAclk; // Generar reloj
    end

    // Proceso de prueba
    initial begin
        // Inicializar señales
        $display("Iniciando la simulación...");
        
        // Esperar un tiempo para observar el comportamiento inicial
        #100;

        // Monitorear las señales
        $monitor("Time: %0t | x: %0d | y: %0d | hsync: %b | vsync: %b | sync_b: %b | blank_b: %b", 
                 $time, x, y, hsync, vsync, sync_b, blank_b);

        // Esperar un tiempo para observar el comportamiento del VGA
        #10000; // Simular por un tiempo prolongado

        // Finalizar la simulación
        $finish;
    end

endmodule