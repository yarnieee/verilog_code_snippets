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
    output reg [15:0] pixel_data
);

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

    always @(*) begin
        pixel_data = 16'h0000;

        // Layer priority is determined by the order of these conditions.
	    // lowest layer first

        case(mode)
            3'd1: begin
                if (rect_1) pixel_data = 16'h07FF; //cyan
            end

            3'd2: begin
                if (circle_1) pixel_data = 16'hF81F; //magenta
            end

            default: begin
            end
        endcase
    end

endmodule
