`timescale 1ns / 1ps

/////////////
// instantiate via:
//
// wire [2:0] mode;
// wire [12:0] pixel_index;
// oled_renderer oled_renderer_inst (
//     .clk(clk),
//     .mode(mode),
//     .pixel_index(pixel_index),
//     .step_tick(step_tick),
//     .rst(rst),
//     .pixel_data(pixel_data)
//     );
/////////////

// Shape parameters are kept here so adding a shape does not require another
// drawing submodule.  The packed layout is:
// {width, height, x, y, x_offset, y_offset}
//
// For a rectangle, x/y is the top-left corner.  For a circle, x/y is the
// centre and width/height are the horizontal/vertical radii.  Offsets are
// signed two's-complement pixel offsets.
module oled_renderer (
    input wire clk,
    input wire [2:0] mode,
    input wire [12:0] pixel_index,
    input wire rst,
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

    // Extend every coordinate to 9-bit signed values before applying the
    // signed offsets.  This also makes negative offsets behave naturally at
    // the display boundary.
    wire signed [8:0] pixel_x_signed = {2'b00, pixel_x};
    wire signed [8:0] pixel_y_signed = {3'b000, pixel_y};

    wire signed [7:0] x_offset;
    wire signed [7:0] y_offset;

    linear_offset #(
        .X0(-64), .Y0(0),
        .X1(0),   .Y1(0),
        .step_tick(4_999_999)
    ) linear_offset_inst (
        .clk(clk),
        .enable(mode == 3'd4),
        .rst(rst),
        .x_offset(x_offset),
        .y_offset(y_offset)
    );

    // CIRCLE
    // params
    wire [6:0] circle1_width = 7'd10;
    wire [5:0] circle1_height = 6'd10;
    wire [6:0] circle1_x = 7'd80;
    wire [5:0] circle1_y = 6'd32;
    wire signed [7:0] circle1_x_offset = ((mode == 3'd4) ? x_offset : 8'sd0);
    wire signed [7:0] circle1_y_offset = ((mode == 3'd4) ? y_offset : 8'sd0);

    wire signed [8:0] circle1_cx = {2'b00, circle1_x}
                                  + {{1{circle1_x_offset[7]}}, circle1_x_offset};
    wire signed [8:0] circle1_cy = {3'b000, circle1_y}
                                  + {{1{circle1_y_offset[7]}}, circle1_y_offset};
    wire signed [8:0] circle1_dx = pixel_x_signed - circle1_cx;
    wire signed [8:0] circle1_dy = pixel_y_signed - circle1_cy;
    //calculate dist from centre
    wire signed [17:0] circle1_dx_squared = circle1_dx * circle1_dx;
    wire signed [17:0] circle1_dy_squared = circle1_dy * circle1_dy;
    wire signed [18:0] circle1_distance_squared = circle1_dx_squared + circle1_dy_squared;
    wire signed [17:0] circle1_radius_squared = circle1_width * circle1_width;
    //final check
    wire in_circle1 = circle1_distance_squared <= circle1_radius_squared;


    // RECT
    // params
    wire [6:0] rect1_width = 7'd20;
    wire [5:0] rect1_height = 6'd40;
    wire [6:0] rect1_x = 7'd20;
    wire [5:0] rect1_y = 6'd10;
    wire signed [7:0] rect1_x_offset = ((mode == 3'd4) ? x_offset : 8'sd0);
    wire signed [7:0] rect1_y_offset = ((mode == 3'd4) ? y_offset : 8'sd0);

    wire signed [8:0] rect1_left = {2'b00, rect1_x}
                                   + {{1{rect1_x_offset[7]}}, rect1_x_offset};
    wire signed [8:0] rect1_top = {3'b000, rect1_y}
                                  + {{1{rect1_y_offset[7]}}, rect1_y_offset};
    wire signed [8:0] rect1_right = rect1_left + rect1_width;
    wire signed [8:0] rect1_bottom = rect1_top + rect1_height;
    //final check
    wire in_rect1 =
        (pixel_x_signed >= rect1_left) && (pixel_x_signed < rect1_right) &&
        (pixel_y_signed >= rect1_top) && (pixel_y_signed < rect1_bottom);

    always @(*) begin
        pixel_data = BLACK;

        case (mode)
            3'd1: begin
                if (in_rect1) pixel_data = CYAN;
            end

            3'd2, 3'd4: begin
                if (in_rect1) pixel_data = CYAN;
                if (in_circle1) pixel_data = MAGENTA;
            end

            default: begin
                pixel_data = BLACK;
            end
        endcase
    end

endmodule
