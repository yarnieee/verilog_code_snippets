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
    wire signed [17:0] dx_wide = {{9{dx[8]}}, dx};
    wire signed [17:0] dy_wide = {{9{dy[8]}}, dy};
    wire signed [17:0] dx_squared = dx_wide * dx_wide;
    wire signed [17:0] dy_squared = dy_wide * dy_wide;
    wire signed [18:0] distance_squared = dx_squared + dy_squared;

    assign inside = distance_squared <= RADIUS * RADIUS;

endmodule
