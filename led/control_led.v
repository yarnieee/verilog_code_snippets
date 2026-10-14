`timescale 1ns / 1ps

module control_led(
    input clk,
    input [2:0] mode,
    input rst,
    output reg [15:0] led
    );

    //make slower clk
    wire slow_clk;
    slower_clk #(49_999_999) slower_clk_inst (clk, slow_clk);

    reg [3:0] state = 4'b0;
    reg [3:0] next_state = 4'b1;

    // ======================= STATE MACHINE =========================
    always @(*) begin
        case(mode)
            3'd0: begin
                led = 16'b1111_1111_1111_1111;
            end
            
            3'd1: begin
                led = 16'b0000_1111_1111_1111;
            end

            default: begin
                led = 16'b0;
            end
        endcase
    end

    // ======================= OUTPUT MACHINE =========================
    always @(*) begin
        case(state)
            4'd0: all_seg = ~32'b0 & (1'b0 << 20);
            default: all_seg = ~32'b0;
            //logic for what segment in each state, goes here
        endcase
    end

    always @(posedge slow_clk) begin
        state <= next_state;
    end
        
endmodule
