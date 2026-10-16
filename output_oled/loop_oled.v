`timescale 1ns / 1ps

// A reusable OLED animation position loop.
//
// The generated center travels from (X0, Y0) to (X1, Y1), reverses at the
// endpoint, and repeats.  step_tick is a one-clock-cycle enable pulse.
module loop_oled #(
    parameter integer X0 = 16,
    parameter integer Y0 = 32,
    parameter integer X1 = 80,
    parameter integer Y1 = 32
    )(
    input  wire       clk,
    input  wire       step_tick,
    input  wire       enable,
    input  wire       rst,
    output reg  [6:0] circle_x,
    output reg  [5:0] circle_y
    );

    reg forward = 1'b1;

    always @(posedge clk) begin
        if (rst || !enable) begin
            circle_x <= X0;
            circle_y <= Y0;
            forward  <= 1'b1;
        end else if (step_tick) begin
            if (forward) begin
                if ((circle_x == X1) && (circle_y == Y1)) begin
                    circle_x <= X1 - (X1 > X0);
                    circle_y <= Y1 - (Y1 > Y0);
                    forward  <= 1'b0;
                end else begin
                    if (circle_x < X1) circle_x <= circle_x + 1'b1;
                    else if (circle_x > X1) circle_x <= circle_x - 1'b1;

                    if (circle_y < Y1) circle_y <= circle_y + 1'b1;
                    else if (circle_y > Y1) circle_y <= circle_y - 1'b1;
                end
            end else if ((circle_x == X0) && (circle_y == Y0)) begin
                circle_x <= X0 + (X1 > X0);
                circle_y <= Y0 + (Y1 > Y0);
                forward  <= 1'b1;
            end else begin
                if (circle_x < X0) circle_x <= circle_x + 1'b1;
                else if (circle_x > X0) circle_x <= circle_x - 1'b1;

                if (circle_y < Y0) circle_y <= circle_y + 1'b1;
                else if (circle_y > Y0) circle_y <= circle_y - 1'b1;
            end
        end
    end

endmodule
