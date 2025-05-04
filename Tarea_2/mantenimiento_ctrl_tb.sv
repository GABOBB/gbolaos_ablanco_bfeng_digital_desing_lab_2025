module mantenimiento_ctrl_tb;
    logic clk, rst_n, boton_mantenimiento, reset_manual;
    logic [7:0] registro_estado;

    mantenimiento_ctrl dut (
        .clk(clk),
        .rst_n(rst_n),
        .boton_mantenimiento(boton_mantenimiento),
        .reset_manual(reset_manual),
        .registro_estado(registro_estado)
    );

    // Reloj de 10ns
    always #5 clk = ~clk;

    initial begin
        $display("Iniciando test...");
        clk = 0;
        rst_n = 0;
        boton_mantenimiento = 0;
        reset_manual = 0;
        #20;

        rst_n = 1;
        #10;

        // Espera sin mantenimiento por 200 ciclos (200 * 10ns = 2000ns)
        repeat (200) @(posedge clk);

        // Verifica estado de error
        if (registro_estado == 8'hFF)
            $display("Error registrado correctamente al no presionar el botón.");
        else
            $display("Falla: no se registró el error.");

        // Aplica reset manual
        reset_manual = 1;
        @(posedge clk);
        reset_manual = 0;
        @(posedge clk);

        // Simula mantenimiento a tiempo
        repeat (50) @(posedge clk);
        boton_mantenimiento = 1;
        @(posedge clk);
        boton_mantenimiento = 0;
        @(posedge clk);

        // Verifica que el registro de estado muestra un mantenimiento
        if (registro_estado == 8'd1)
            $display("Mantenimiento registrado correctamente.");
        else
            $display("Falla: mantenimiento no registrado correctamente.");

        $finish;
    end
endmodule