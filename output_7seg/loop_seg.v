`timescale 1ns / 1ps

//////////
// wire [31:0] loop_seg_value;
// loop_seg loop_seg_inst (
//     .clk(clk),
//     .forward(1'b1),
//     .pause(1'b0),
//     .reset(reset),
//     .out_seg(loop_seg_value)
// );
//////////

module loop_seg (
    input clk,
    input forward,
    input pause,
    input reset,
    output reg [31:0] out_seg = ~32'b0
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
    localparam BLANK_ALL = ~32'b0;

    wire out_clk;
    slower_clk #(.MAX_COUNT(24_999_999)) slower_clk_inst (
        .clk(clk),
        .out_clk(out_clk)
        );

    reg [4:0] state = 0;
    reg [4:0] next_state = 0;
    reg [31:0] next_seg; //active high.

    always @(*) begin
        next_seg = BLANK_ALL;

        case (state)
            0: begin
                next_state = 1;
                next_seg = {BLANK, BLANK, DOT, BLANK};
                end
            1: begin
                next_state = 2;
                next_seg = {BLANK, BLANK, RIGHT_BOTTOM, BLANK};
                end
            2: begin
                next_state = 3;
                next_seg = {BLANK, BLANK, MIDDLE_BAR, BLANK};
                end
            3: begin
                next_state = 4;
                next_seg = {BLANK, MIDDLE_BAR, BLANK, BLANK};
                end
            4: begin
                next_state = 5;
                next_seg = {MIDDLE_BAR, BLANK, BLANK, BLANK};
                end
            5: begin
                next_state = 6;
                next_seg = {LEFT_BOTTOM, BLANK, BLANK, BLANK};
                end
            6: begin
                next_state = 7;
                next_seg = {BOTTOM_BAR, BLANK, BLANK, BLANK};
                end
            7: begin
                next_state = 8;
                next_seg = {BLANK, BOTTOM_BAR, BLANK, BLANK};
                end
            8: begin
                next_state = 0;
                next_seg = {BLANK, BLANK, BOTTOM_BAR, BLANK};
                end
            default: begin
                next_state = 0;
                next_seg = BLANK_ALL;
                end
        endcase
    end

    always @(posedge out_clk) begin
        if (reset) begin
            out_seg <= BLANK_ALL;
            state <= 0;
        end else begin
            out_seg <= next_seg;
            state <= next_state;
        end
    end

endmodule
