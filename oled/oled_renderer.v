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

    wire out_clk;
    slower_clk #(.MAX_COUNT(5_555_555)) slower_clk_inst (
        .clk(clk),
        .out_clk(out_clk)
        );
    
    wire [6:0] centre_x = 48;
    wire [5:0] centre_y = 32;
    reg [6:0] rect_x = 3;
    reg [5:0] rect_y = 3;
    wire [6:0] x_max = 31;
    wire [5:0] y_max = 31;
    wire in_rect;
    assign in_rect = (pixel_x >= (centre_x-rect_x)) && (pixel_x <= (centre_x+rect_x)) &&
        (pixel_y >= (centre_y-rect_y)) && (pixel_y <= (centre_y+rect_y));
    
    always @(posedge out_clk) begin
        if (mode==3'd5 && (rect_y < y_max)) begin
            rect_y <= rect_y + 1;
        end else if (mode==3'd6 && (rect_x < x_max)) begin
            rect_x <= rect_x + 1;
        end
    end

    always @(*) begin        
        pixel_data = BLACK;
        
        case (mode)
            3'd5,3'd6: begin
                pixel_data = BLUE;
                if (in_rect) pixel_data = YELLOW;
            end

            default: begin
                pixel_data = BLACK;
            end
        endcase
    end

endmodule
