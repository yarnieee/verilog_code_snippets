`timescale 1ns / 1ps

/////////////
// instantiate via:
//
// wire [2:0] state;
// wire [12:0] pixel_index;
// oled_renderer oled_renderer_inst (
//     .mode(mode),
//     .pixel_index(pixel_index),
//     .pixel_data(pixel_data)
//     );
/////////////

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module oled_renderer (
    input wire [2:0]  mode,
    input wire [12:0] pixel_index,
    input wire [6:0]  circle_x,
    input wire [5:0]  circle_y,
    output reg [15:0] pixel_data
);

    localparam RED = 16'hF800;
    localparam BLUE = 16'h001F;
    localparam GREEN = 16'h07E0;
    localparam WHITE = 16'hFFFF;
    localparam BLACK = 16'h0000;
    localparam YELLOW = 16'hFFE0;
    localparam MAGENTA = 16'hF81F;
    localparam CYAN = 16'h07FF;

    wire [6:0] pixel_x = pixel_index % 96;
    wire [5:0] pixel_y = pixel_index / 96;

    wire rect_1;
    rect #(
        .X0(20), .Y0(10),
        .WIDTH(20), .HEIGHT(40)
    ) rect_inst (
        .x(pixel_x),
        .y(pixel_y),
        .inside(rect_1)
    );

    wire circle_1;
    circle #(
        .CX(80), .CY(32),
        .RADIUS(10)
    ) circle_inst (
        .x(pixel_x),
        .y(pixel_y),
        .inside(circle_1)
    );

    // Dynamic circle used by loop_oled.  The widened intermediates prevent
    // signed multiplication from truncating the distance calculation.
    wire signed [8:0] moving_dx = $signed({1'b0, pixel_x}) - $signed({1'b0, circle_x});
    wire signed [8:0] moving_dy = $signed({1'b0, pixel_y}) - $signed({1'b0, circle_y});
    wire signed [17:0] moving_dx_wide = {{9{moving_dx[8]}}, moving_dx};
    wire signed [17:0] moving_dy_wide = {{9{moving_dy[8]}}, moving_dy};
    wire signed [17:0] moving_dx_squared = moving_dx_wide * moving_dx_wide;
    wire signed [17:0] moving_dy_squared = moving_dy_wide * moving_dy_wide;
    wire signed [18:0] moving_distance_squared = moving_dx_squared + moving_dy_squared;
    wire moving_circle = moving_distance_squared <= 19'sd100;

    always @(*) begin
        pixel_data = BLACK;

        // Layer priority is determined by the order of these conditions.
	    // lowest layer first

        case(mode)
            3'd1: begin
                if (rect_1) pixel_data = CYAN; //cyan
            end

            3'd2: begin
                if (circle_1) pixel_data = MAGENTA; //magenta
            end

            3'd4: begin
                if (moving_circle) pixel_data = MAGENTA; //magenta
            end

            default: begin
            end
        endcase
    end

endmodule
