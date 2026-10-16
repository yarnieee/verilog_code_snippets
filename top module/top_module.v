`timescale 1ns / 1ps

module top_module(
    input clk,
    input [4:0] btn,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JA
    );
    
//    lessons:
//    1. debounce is a waste of time
//    2. loop end condition was wrong &&
//    3. refresh rate for segments was too high (3/6)
//    2. check that you changed all instances of JA (4/6) (6/6)
//    3. check that your in_rect code all comparators were correct (5/6)

    wire [2:0] mode;
    assign rst = 1'b0; // to global disable the reset

    wire segments_done;
    get_mode get_mode_inst (clk, btn, sw, rst, segments_done, mode);
//    test_mode test_mode_inst (clk, btn, sw, rst, mode);

    control_led control_led_inst (clk, mode, rst, led);
    control_seg control_seg_inst (clk, mode, rst, an, seg, segments_done);
    control_oled control_oled_inst (clk, mode, rst, JA);

endmodule
