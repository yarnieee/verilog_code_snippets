`timescale 1ns / 1ps

//the one ring to rule them all
module top_module(
    input clk,
    input [4:0] btn,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JB //CHANGE
    );

    wire [2:0] mode;
    wire rst;
    assign rst = 1'b0; // to global disable the reset

    // SAMPLE CODE TO CONNECT LED/SEG STATES TO STATE MACHINE
    // wire led_12;
    // get_mode get_mode_inst (clk, btn, sw, rst, mode, led_12); //led_12 as input
    // led_mode_switcher led_mode_switcher_inst (clk, mode, rst, led, led_12); //led_12 as output

    //get_mode get_mode_inst (clk, btn, sw, rst, mode);
    test_mode test_mode_inst (clk, btn, sw, rst, mode);

    led_mode_switcher led_mode_switcher_inst (clk, mode, rst, led);
    control_seg control_seg_inst (clk, mode, rst, an, seg);
    control_oled control_oled_inst (clk, mode, rst, JB); //CHANGE JB

endmodule
