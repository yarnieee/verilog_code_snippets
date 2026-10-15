`timescale 1ns / 1ps

module delay_tb;
    reg clk;
    reg enable;
    wire done;

    delay #(.DELAY(3)) dut (
        .clk(clk),
        .enable(enable),
        .done(done)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial clk = 1'b0;
    always #5 clk = ~clk;
    
    initial begin
        enable = 1;
        #100;
        enable = 0;
        #100;
    end
endmodule
