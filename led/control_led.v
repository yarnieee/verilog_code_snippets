`timescale 1ns / 1ps

module control_led(
    input clk,
    input [2:0] mode,
    input rst,
    output reg [15:0] led
    );

    wire step_tick;
    slower_ticker #(49_999_999) led_step_ticker (
        .clk(clk),
        .ticker(step_tick)
    );

    wire [15:0] loop_led_value;
    loop_led loop_led_inst (
        .clk(clk),
        .step_tick(step_tick),
        .enable(mode == 3'd5),
        .rst(rst),
        .led(loop_led_value)
    );

    // ======================= STATE MACHINE =========================
    always @(*) begin
        case(mode)
            3'd0: begin
                led = 16'b1111_1111_1111_1111;
            end
            
            3'd1: begin
                led = 16'b0000_1111_1111_1111;
            end

            3'd5: begin
                led = loop_led_value;
            end

            default: begin
                led = 16'b0;
            end
        endcase
    end
        
endmodule
