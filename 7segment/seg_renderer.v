`timescale 1ns / 1ps

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module seg_renderer(
    input clk,
    input [2:0] mode,
    input reset,
    output reg [31:0] out_seg = ~32'b0,
    output segments_done
    );

    localparam BLANK = 8'b1111_1111;
    localparam ZERO = 8'b1100_0000;
    localparam ONE = 8'b1111_1001;
    localparam TWO = 8'b1010_0100;
    localparam THREE = 8'b1011_0000;
    localparam FOUR = 8'b1001_1001;
    localparam FIVE = 8'b1011_0000;
    localparam SIX = 8'b1000_0010;
    localparam SEVEN = 8'b1111_1000;
    localparam EIGHT = 8'b1000_0000;
    localparam NINE = 8'b1001_0000;

    // to use these, (DOT & TOP_BAR & BOTTOM_BAR)
    localparam DOT = 8'b0111_1111;
    localparam TOP_BAR = 8'b1111_1110;
    localparam MIDDLE_BAR = 8'b1011_1111;
    localparam BOTTOM_BAR = 8'b1111_0111;
    localparam LEFT_TOP = 8'b1101_1111;
    localparam LEFT_BOTTOM = 8'b1110_1111;
    localparam RIGHT_TOP = 8'b1111_1101;
    localparam RIGHT_BOTTOM = 8'b1111_1011;
    localparam BLANK_ALL = ~32'b0;

    //not even a loop.
    wire seg_rst;
    assign seg_rst = (mode == 3'd5);
    wire [31:0] loop_seg_value;
    loop_seg loop_seg_inst (
        .clk(clk),
        .reset(seg_rst),
        .out_seg(loop_seg_value),
        .segments_done(segments_done)
    );

    always @(*) begin
        out_seg = BLANK_ALL;
        case(mode)
            3'd0, 3'd1, 3'd2, 3'd3, 3'd4: begin
                out_seg = {BLANK, TOP_BAR, BLANK, BLANK};
            end

            3'd5, 3'd6: begin
                out_seg = loop_seg_value;
            end

            default: begin
                out_seg = BLANK_ALL;
            end
        endcase
    end

endmodule
