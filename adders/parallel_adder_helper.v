`timescale 1ns / 1ps

module parallel_adder_helper (
    input a, b, carry, no_carry,
    output s
);
    assign s = (a & b) ? carry : no_carry;
    
endmodule