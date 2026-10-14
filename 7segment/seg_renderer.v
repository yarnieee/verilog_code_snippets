`timescale 1ns / 1ps

// THIS IS THE BIG BOI TO CHANGE BASED ON STATE

module seg_renderer(
    input clk,
    input [2:0] mode,
    output reg [31:0] all_seg = ~32'b0
    );

    always @(*) begin
        // Loop generators are selected by the controller as they are added.
        // Keep the renderer dark for modes that do not yet have a pattern.
        all_seg = ~32'b0;
        case(mode)
            default: begin
                all_seg = ~32'b0;
            end
        endcase
    end

endmodule
