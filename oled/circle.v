`timescale 1ns / 1ps

//////////
// instantiate via:
//
// wire circle_1;
//
// circle #(
//     .CX(80), .CY(32),
//     .RADIUS(10)
// ) circle_inst (
//     .x(pixel_x),
//     .y(pixel_y),
//     .inside(circle_1)
// );
//////////

module circle #(
    parameter integer CX = 0,
    parameter integer CY = 0,
    parameter integer RADIUS = 10
) (
    input  wire [6:0] x,
    input  wire [5:0] y,
    output wire inside
);

    wire signed [8:0] dx = $signed({1'b0, x}) - CX;
    wire signed [8:0] dy = $signed({1'b0, y}) - CY;

    assign inside = (dx * dx + dy * dy) <= RADIUS * RADIUS;

endmodule