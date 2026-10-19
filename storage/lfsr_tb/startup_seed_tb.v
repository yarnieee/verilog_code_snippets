
`timescale 1ns / 1ps

module startup_seed_tb;
    reg clk;
    reg rst;
    wire [31:0] seed;
    wire seed_valid;

    startup_seed dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .seed_valid(seed_valid)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;

        wait (seed_valid);
        #1;
        if (seed === 32'b0) begin
            $display("FAIL startup_seed_tb: generated seed was zero");
            $finish;
        end

        $display("PASS startup_seed_tb: seed=%h", seed);
        $finish;
    end

endmodule
