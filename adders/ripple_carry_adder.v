`timescale 1ns / 1ps

module ripple_carry_adder #(
    parameter N = 16
)(
    input [N-1:0] a,
    input [N-1:0] b,
    input cin,
    output [N-1:0] s,
    output cout
);

    wire [N-2:0] carry;
    
    full_adder inst1[N-1:0] (a, b, {carry, cin}, s, {cout, carry});
    
endmodule