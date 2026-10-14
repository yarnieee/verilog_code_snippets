`timescale 1ns / 1ps

// A reusable four-digit seven-segment pendulum loop.
//
// The active-low GLYPH is shown at byte positions 0, 1, 2, 3, 2, 1, ...
// of all_seg.  enable controls whether the glyph is visible, while run
// controls whether step_tick advances its position.
module loop_seg #(
    parameter [7:0] GLYPH = 8'b1000_0000,
    parameter [7:0] BLANK = 8'b1111_1111
    )(
    input  wire        clk,
    input  wire        step_tick,
    input  wire        enable,
    input  wire        run,
    input  wire        rst,
    output reg  [31:0] all_seg
    );

    reg [1:0] position = 2'd0;
    reg       forward  = 1'b1;

    always @(posedge clk) begin
        if (rst || !enable) begin
            position <= 2'd0;
            forward  <= 1'b1;
        end else if (step_tick && run) begin
            if (forward) begin
                if (position == 2'd3) begin
                    position <= 2'd2;
                    forward  <= 1'b0;
                end else begin
                    position <= position + 1'b1;
                end
            end else if (position == 2'd0) begin
                position <= 2'd1;
                forward  <= 1'b1;
            end else begin
                position <= position - 1'b1;
            end
        end
    end

    always @(*) begin
        all_seg = {4{BLANK}};
        if (enable) begin
            case (position)
                2'd0: all_seg[7:0]   = GLYPH;
                2'd1: all_seg[15:8]  = GLYPH;
                2'd2: all_seg[23:16] = GLYPH;
                2'd3: all_seg[31:24] = GLYPH;
                default: all_seg = {4{BLANK}};
            endcase
        end
    end

endmodule
