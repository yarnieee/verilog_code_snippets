`timescale 1ns / 1ps

////////////////
// 
////////////////

module rotate_text(
    input clk,
    output reg [31:0] seg = 0
    );
    
    localparam E_VALUE = 8'b10000110;
    localparam BLANK = 8'b1111_1111;
    localparam ZERO = 8'b1100_0000;
    localparam TWO = 8'b1010_0100;
    localparam SIX = 8'b1000_0110;

    reg [31:0] temp;

    wire clk_4Hz;
    slower_ticker #(24_999_999) ticker_4Hz (clk, clk_4Hz);
    
    initial begin
        // temp comes after
        seg[31:24] = E_VALUE;
        seg[23:16] = E_VALUE;
        seg[15:8] = TWO;
        seg[7:0] = ZERO;
        temp[31:24] = TWO;
        temp[23:16] = SIX;
        temp[15:8] = BLANK;
        temp[7:0] = BLANK;
    end
    
    always @(posedge clk_4Hz) begin
        seg <= {seg[23:0], temp[31:24]};
        temp = {temp[23:0], seg[31:24]};
    end
endmodule
