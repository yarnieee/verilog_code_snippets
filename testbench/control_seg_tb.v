`timescale 1ns / 1ps

module testbench_top();
    reg clk;
    reg [4:0] btn;
    reg [15:0] sw;
    wire [15:0] led;
    wire [3:0] an;
    wire [7:0] seg;
    wire [7:0] JB;

    initial begin
        clk = 1'b0;
    end

    always begin
        clk = ~clk; #5
    end

    top_module top_module_inst (clk, btn, sw, led, an, seg, JB);

endmodule