`timescale 1ns / 1ps

// A reusable 16-LED pendulum loop.
//
// step_tick is a one-clock-cycle enable pulse.  Supplying a ticker instead of
// dividing the clock internally keeps the animation rate under the control of
// the module that instantiates this template.
//
// Sequence while enabled: 0, 1, ..., 15, 14, ..., 0, ...
module loop_led (
    input  wire        clk,
    input  wire        step_tick,
    input  wire        enable,
    input  wire        rst,
    output reg  [15:0] led
    );

    reg [3:0] position = 4'd0;
    reg       forward  = 1'b1;

    always @(posedge clk) begin
        if (rst || !enable) begin
            position <= 4'd0;
            forward  <= 1'b1;
        end else if (step_tick) begin
            if (forward) begin
                if (position == 4'd15) begin
                    position <= 4'd14;
                    forward  <= 1'b0;
                end else begin
                    position <= position + 1'b1;
                end
            end else if (position == 4'd0) begin
                position <= 4'd1;
                forward  <= 1'b1;
            end else begin
                position <= position - 1'b1;
            end
        end
    end

    always @(*) begin
        led = 16'b0;
        if (enable && !rst) begin
            led[position] = 1'b1;
        end
    end

endmodule
