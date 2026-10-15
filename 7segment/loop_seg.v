`timescale 1ns / 1ps

// A reusable four-digit seven-segment pendulum loop.
//
// The active-low GLYPH is shown at byte positions 0, 1, 2, 3, 2, 1, ...
// of out_seg.  enable controls whether the glyph is visible, while run
// controls whether step_tick advances its position.
module loop_seg (
    input clk,
    input forward,
    input pause,
    output reg [31:0] out_seg = {4{BLANK}}
    );

    // to use these, (DOT & TOP_BAR & BOTTOM_BAR)
    localparam BLANK = 8'b1111_1111;
    localparam DOT = 8'b0111_1111;
    localparam TOP_BAR = 8'b1111_1110;
    localparam MIDDLE_BAR = 8'b1011_1111;
    localparam BOTTOM_BAR = 8'b1111_0111;
    localparam LEFT_TOP = 8'b1101_1111;
    localparam LEFT_BOTTOM = 8'b1110_1111;
    localparam RIGHT_TOP = 8'b1111_1101;
    localparam RIGHT_BOTTOM = 8'b1111_1011;

    wire out_clk;
    slower_clk #(.MAX_COUNT(9_999)) slower_clk_inst (
        .clk(clk),
        .out_clk(out_clk)
        );

    reg [4:0] state = 0; //0 to how many??
    reg [31:0] next_seg;

    always @(*) begin
        out_seg = {4{BLANK}};

        case (state)
            0: state = 1; next_seg = (DOT << 8);
            1:
            2:
            3:
            4:
            5:
            6:
            7:
            8:
            9:
            10:
            default: out_seg = {4{BLANK}};
        endcase
    end

    always @(posedge out_clk) begin
        out_seg <= next_seg;
    end

endmodule
