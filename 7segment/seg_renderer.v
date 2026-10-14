`timescale 1ns / 1ps

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module control_seg(
    input clk,
    input [2:0] mode,
    output reg [31:0] all_seg = ~32'b0
    );

    //make slower clk for seg refresh rate
    wire slow_clk;
    slower_clk #(49_999_999) slower_clk_inst (clk, slow_clk);
    
    //make forward looper: input slow clk, input direction output seg

    //make backward looper: use above^

    //make pauser

    // ======================= STATE MACHINE =========================
    always @(*) begin
        case(mode)
            3'd1: begin
                all_seg = forward_loop_seg;
            end

            3'd2: begin
                all_seg = pause_seg;
            end

            3'd3: begin
                all_seg = backward_loop_seg;
            end

            default: begin
                all_seg = ~32'b0;
            end
        endcase
    end

endmodule