module videoGen (
    input logic clk,
    input logic rst_n,
    input logic [9:0] x_pos,
    input logic [9:0] y_pos,
    input logic [83:0] grid_state,
    input logic [3:0] current_state,
    input logic [2:0] selected_col,
    input logic current_player,
    input logic [23:0] winning_line,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    // Parámetros ajustados
    parameter CELL_WIDTH = 40;
    parameter CELL_HEIGHT = 40;
    parameter GRID_COLS = 7;
    parameter GRID_ROWS = 6;
    parameter GRID_START_X = 50;
    parameter GRID_START_Y = 60;
    parameter RADIUS = 15;

    logic [2:0] col;
    logic [2:0] row;
    logic [6:0] cell_index;
    logic [1:0] cell_state;

    logic [9:0] cell_x0, cell_x1, cell_y0, cell_y1;
    logic in_cell_rect;

    logic [9:0] cell_center_x, cell_center_y;
    logic [10:0] dx, dy;
    logic in_cell_circle;

    logic [9:0] float_center_x, float_center_y;
    logic [10:0] dx_float, dy_float;
    logic in_float_circle;

    assign col = (x_pos - GRID_START_X) / CELL_WIDTH;
    assign row = (y_pos - GRID_START_Y) / CELL_HEIGHT;

    assign cell_index = row * GRID_COLS + col;
    assign cell_state = grid_state[(cell_index * 2) +: 2];

    assign cell_x0 = GRID_START_X + col * CELL_WIDTH;
    assign cell_x1 = cell_x0 + CELL_WIDTH;
    assign cell_y0 = GRID_START_Y + row * CELL_HEIGHT;
    assign cell_y1 = cell_y0 + CELL_HEIGHT;
    assign in_cell_rect = (x_pos >= cell_x0 && x_pos < cell_x1 &&
                           y_pos >= cell_y0 && y_pos < cell_y1);

    assign cell_center_x = cell_x0 + CELL_WIDTH / 2;
    assign cell_center_y = cell_y0 + CELL_HEIGHT / 2;

    assign dx = (x_pos > cell_center_x) ? (x_pos - cell_center_x) : (cell_center_x - x_pos);
    assign dy = (y_pos > cell_center_y) ? (y_pos - cell_center_y) : (cell_center_y - y_pos);
    assign in_cell_circle = (dx * dx + dy * dy) <= (RADIUS * RADIUS);

    assign float_center_x = GRID_START_X + selected_col * CELL_WIDTH + CELL_WIDTH / 2;
    assign float_center_y = GRID_START_Y - CELL_HEIGHT / 2;
    assign dx_float = (x_pos > float_center_x) ? (x_pos - float_center_x) : (float_center_x - x_pos);
    assign dy_float = (y_pos > float_center_y) ? (y_pos - float_center_y) : (float_center_y - y_pos);
    assign in_float_circle = (dx_float * dx_float + dy_float * dy_float) <= (RADIUS * RADIUS);

    always_comb begin
        red = 8'd255;
        green = 8'd255;
        blue = 8'd255;

        if (in_cell_rect) begin
            red = 8'd0;
            green = 8'd0;
            blue = 8'd255;

            if (cell_state == 2'b00 && in_cell_circle) begin
                red = 8'd255;
                green = 8'd255;
                blue = 8'd255;
            end else if (cell_state == 2'b01 && in_cell_circle) begin
                red = 8'd255;
                green = 8'd0;
                blue = 8'd0;
            end else if (cell_state == 2'b10 && in_cell_circle) begin
                red = 8'd0;
                green = 8'd0;
                blue = 8'd255;
            end
        end

        if ((current_state == 4'b0001 || current_state == 4'b0010) && in_float_circle) begin
            if (current_player == 1'b0) begin
                red = 8'd255;
                green = 8'd0;
                blue = 8'd0;
            end else begin
                red = 8'd0;
                green = 8'd0;
                blue = 8'd255;
            end
        end
    end

endmodule
