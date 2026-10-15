`timescale 1ns / 1ps

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module seg_renderer(
    input clk,
    input [2:0] mode,
    output reg [31:0] all_seg = ~32'b0
    );

    localparam BLANK = 8'b1111_1111;
    localparam ZERO = 8'b1100_0000;
    localparam ONE = 8'b1111_1001;
    localparam TWO = 8'b1010_0100;
    localparam THREE = 8'b1011_0000;
    localparam FOUR = 8'b1001_1001;
    localparam FIVE = 8'b1011_0000;
    localparam SIX = 8'b1000_0110;
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

    wire step_tick;
    slower_ticker #(24_999_999) seg_step_ticker (
        .clk(clk),
        .ticker(step_tick)
    );

    // garbage
    wire [31:0] loop_seg_value;
    loop_seg loop_seg_inst (
        
    );

    // ROTATING EE2026--
    wire [31:0] rotate_text_value;
    rotate_text rotate_text_inst (
        .clk(clk),
        .seg(rotate_text_value)
    );

    always @(*) begin
        all_seg = ~32'b0;
        case(mode)
            3'd0: begin
                all_seg = rotate_text_value;
            end

            default: begin
                all_seg = ~32'b0;
            end
        endcase
    end

endmodule
