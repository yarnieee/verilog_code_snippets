`timescale 1ns / 1ps

////////////////
// 
////////////////

module rotate_text(
    input clk,
    output reg [31:0] seg = 0
    );
    reg [31:0] temp;

    wire clk_4Hz;
    slower_ticker #(24_999_999) ticker_4Hz (clk, clk_4Hz);
    
    initial begin
        // temp comes after
        seg[31:24] = 8'b10000110; //E
        seg[23:16] = 8'b10000110; //E
        seg[15:8] = 8'b10100100; //2
        seg[7:0] = 8'b11000000; //0
        temp[31:24] = 8'b10100100; //2
        temp[23:16] = 8'b10000010; //6
        temp[15:8] = 8'b11111111;
        temp[7:0] = 8'b11111111;
    end
    
    always @(posedge clk_4Hz) begin
        seg <= {seg[23:0], temp[31:24]};
        temp = {temp[23:0], seg[31:24]};
    end
endmodule
