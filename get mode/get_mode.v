`timescale 1ns / 1ps

/////////////
// instantiate via:
// get_mode get_mode_inst (
//     .clk(clk),
//     .btn(btn),
//     .sw(sw),
//     .rst(rst),
//     .mode(mode)
// )
/////////////

module get_mode(
    input clk,
    input [4:0] btn,
    input [15:0] sw,
    input rst,
    input segments_done,
    output reg [2:0] mode = 3'b0
    ); // can count 8 modes 0-7

    reg [2:0] next_state;

    always @(*) begin
        next_state = mode;

        case(mode) //UDLRC -> CRLDU
            3'd0: begin //await U
                if (btn[0]) next_state = 3'd1;
            end

            3'd1: begin //await R
                if (btn[3]) next_state = 3'd2;
            end
            
            3'd2: begin //await U
                if (btn[0]) next_state = 3'd3;
            end
            
            3'd3: begin //await L
                if (btn[2]) next_state = 3'd4;
            end
            
            3'd4: begin //await C
                if (btn[0]) next_state = 3'd5;
            end
            
            3'd5: begin //await end of segment moving
                if (segments_done) next_state = 3'd6;
            end
            
            3'd6: begin //forever loop
                next_state = 3'd6;
            end

            default: begin //how did u end up here ???
                next_state = 3'd0;
            end
        endcase
    end

    always @(posedge clk) begin //if async reset then add posedge rst
        if (rst) begin
            mode <= 3'b0;
        end else begin
            mode <= next_state;
        end
    end
        
endmodule
