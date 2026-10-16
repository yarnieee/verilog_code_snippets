`timescale 1ns / 1ps

module control_led(
    input clk,
    input [2:0] mode,
    input rst,
    output reg [15:0] led
    );

    // ======================= STATE MACHINE =========================
    always @(*) begin
        led = 16'b0;
        case(mode)
            3'd5, 3'd6: begin
                led[0] = 1'b1;
            end

            default: begin
                led = 16'b0;
            end
        endcase
    end
        
endmodule
