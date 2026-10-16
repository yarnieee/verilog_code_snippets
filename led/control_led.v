`timescale 1ns / 1ps

module control_led(
    input clk,
    input [2:0] mode,
    input rst,
    output reg [15:0] led
    );

    wire [15:0] switch_to_led_value;
    switch_to_led switch_to_led_inst (
        .sw(sw),
        .led(switch_to_led_value)
    );

    // ======================= STATE MACHINE =========================
    always @(*) begin
        case(mode)
            3'd0: begin
                led = 16'b0;
            end

            default: begin
                led = switch_to_led_value;
            end
        endcase
    end
        
endmodule
