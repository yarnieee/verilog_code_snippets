`timescale 1ns / 1ps

module control_oled (
    input clk,
    input [2:0] mode,
    input rst, //currently, reset is the centre button
    output [7:0] JX
    );

    wire clk_6_25MHz; //
    slower_clk #(32'd7) slow_clk_inst (clk, clk_6_25MHz);

    //wire rst;
    wire frame_begin;
    wire sending_pixels;
    wire sample_pixel;
    wire [15:0] pixel_data;
    wire [12:0] pixel_index; // 0 to 6143 for a 96x64 display

    oled_renderer oled_renderer_inst (
        .clk(clk),
        .mode(mode),
        .pixel_index(pixel_index),
        .rst(rst),
        .pixel_data(pixel_data)
    );
    
    oled_display oled_display_inst (
        .clk(clk_6_25MHz), //inputs
        .reset(rst),
        .pixel_data(pixel_data),
        .frame_begin(frame_begin), //outputs
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .cs(JX[0]),
        .sdin(JX[1]),
        .sclk(JX[3]),
        .d_cn(JX[4]),
        .resn(JX[5]),
        .vccen(JX[6]),
        .pmoden(JX[7])
    );

endmodule
