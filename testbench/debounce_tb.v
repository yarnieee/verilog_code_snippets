`timescale 1ns / 1ps

module debounce_tb;
    reg clk;
    reg btn;
    wire debounced;

    debouncer #(.DEBOUNCE_CTR(30)) dut (
        .clk(clk),
        .btn(btn),
        .debounced(debounced)
    );

    initial clk = 1'b1;
    initial btn = 1'b1;
    always #5 clk = ~clk;
    always begin
        btn = ~btn;
        #7;
        btn = ~btn;
        #7;
        btn = ~btn;
        #7;
        btn = ~btn;
        #7;
        btn = ~btn;
        #7;
        #30;
    end

endmodule
