`timescale 1ns / 1ps

module parallel_adder #(
    parameter N = 16
)(
    input [N-1:0] a,
    input [N-1:0] b,
    input cin,
    output [N-1:0] s,
    output cout
);

    wire [N-1:0] temp_carry;
    wire [N-1:0] temp_no_carry;
    
    full_adder inst1[N-1:0] (a, b, {carry, cin}, temp_carry, {cout, carry});

    parallel_adder_helper parallel_adder_helper_inst (a, b, temp_carry, temp_no_carry, s);
    
    assign s = (a & b) ? temp_carry : temp_no_carry;
    
endmodule