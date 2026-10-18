`timescale 1ns / 1ps

module full_adder(
    input a, b, cin,
    output s, cout
    );
                    
    assign s = a ^ b ^ cin;
    assign COUT = a & b | cin & (a ^ b);
    
endmodule