`timescale 1ns / 1ps

/////////////
// instantiate via:

// wire rect_1;
    
// rect #(
//     .X0(20), .Y0(10),
//     .WIDTH(20), .HEIGHT(40)
// ) rect_inst (
//     .x(pixel_x),
//     .y(pixel_y),
//     .inside(rect_1)
// );
/////////////

module rect #(
    parameter integer X0 = 0,
    parameter integer Y0 = 0,
    parameter integer WIDTH = 10,
    parameter integer HEIGHT = 10
) (
    input  wire [6:0] x,
    input  wire [5:0] y,
    output wire       inside
);

    assign inside =
        (x >= X0) && (x < X0 + WIDTH) &&
        (y >= Y0) && (y < Y0 + HEIGHT);

endmodule