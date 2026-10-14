`timescale 1ns / 1ps

module switch_to_led(
    input [15:0] sw,
    output [15:0] led
    );
    
    assign led = sw;
    
endmodule
