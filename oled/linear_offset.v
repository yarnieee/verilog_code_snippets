`timescale 1ns / 1ps

//////////
// wire signed [7:0] x_offset;
// wire signed [7:0] y_offset;
// linear_offset #(
//     .X0(-64), .Y0(0),
//     .X1(0),   .Y1(0)
// ) linear_offset_inst (
//     .clk(clk),
//     .step_tick(step_tick),
//     .enable(enable),
//     .rst(rst),
//     .x_offset(x_offset),
//     .y_offset(y_offset)
// );
//////////

// A reusable offset loop.  The outputs move one pixel per step_tick from
// (X0, Y0) to (X1, Y1), then reverse and repeat.
module linear_offset #(
    parameter integer X0 = 0,
    parameter integer Y0 = 0,
    parameter integer X1 = 0,
    parameter integer Y1 = 0,
    parameter step_tick = 4_999_999
    )(
    input wire clk,
    input wire step_tick,
    input wire enable,
    input wire rst,
    output reg signed [7:0] x_offset,
    output reg signed [7:0] y_offset
    );

    reg forward = 1'b1;

    wire step_tick;
    slower_ticker #(4_999_999) oled_step_ticker (
        .clk(clk),
        .ticker(step_tick)
    );

    always @(posedge clk) begin
        if (rst || !enable) begin
            x_offset <= X0;
            y_offset <= Y0;
            forward  <= 1'b1;
        end else if (step_tick) begin
            if (forward) begin
                if ((x_offset == X1) && (y_offset == Y1)) begin
                    x_offset <= X1 - (X1 > X0);
                    y_offset <= Y1 - (Y1 > Y0);
                    forward <= 1'b0;
                end else begin
                    if (x_offset < X1) x_offset <= x_offset + 1'sd1;
                    else if (x_offset > X1) x_offset <= x_offset - 1'sd1;

                    if (y_offset < Y1) y_offset <= y_offset + 1'sd1;
                    else if (y_offset > Y1) y_offset <= y_offset - 1'sd1;
                end
            end else if ((x_offset == X0) && (y_offset == Y0)) begin
                x_offset <= X0 + (X1 > X0);
                y_offset <= Y0 + (Y1 > Y0);
                forward <= 1'b1;
            end else begin
                if (x_offset < X0) x_offset <= x_offset + 1'sd1;
                else if (x_offset > X0) x_offset <= x_offset - 1'sd1;

                if (y_offset < Y0) y_offset <= y_offset + 1'sd1;
                else if (y_offset > Y0) y_offset <= y_offset - 1'sd1;
            end
        end
    end

endmodule
