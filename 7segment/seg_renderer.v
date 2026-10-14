`timescale 1ns / 1ps

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module seg_renderer(
    input clk,
    input [2:0] mode,
    output reg [31:0] all_seg = ~32'b0
    );

    wire step_tick;
    slower_ticker #(24_999_999) seg_step_ticker (
        .clk(clk),
        .ticker(step_tick)
    );

    wire [31:0] loop_seg_value;
    loop_seg loop_seg_inst (
        .clk(clk),
        .step_tick(step_tick),
        .enable((mode == 3'd1) || (mode == 3'd2)),
        .run(mode == 3'd1),
        .rst(1'b0),
        .all_seg(loop_seg_value)
    );

    always @(*) begin
        all_seg = ~32'b0;
        case(mode)
            3'd1,
            3'd2: begin
                all_seg = loop_seg_value;
            end

            default: begin
                all_seg = ~32'b0;
            end
        endcase
    end

endmodule
