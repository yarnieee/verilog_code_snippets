
`timescale 1ns / 1ps

module lfsr_tb;
    reg clk;
    reg rst;
    reg en;
    reg load;
    reg [31:0] seed;
    wire [31:0] q;

    lfsr dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .load(load),
        .seed(seed),
        .q(q)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        en = 1'b0;
        load = 1'b0;
        seed = 32'h12345678;

        @(posedge clk);
        #1;
        if (q !== 32'h00000001) begin
            $display("FAIL lfsr_tb: reset seed was %h", q);
            $finish;
        end

        rst = 1'b0;
        load = 1'b1;
        @(posedge clk);
        #1;
        load = 1'b0;
        if (q !== seed) begin
            $display("FAIL lfsr_tb: loaded seed was %h", q);
            $finish;
        end

        en = 1'b1;
        @(posedge clk);
        #1;
        if ((q === seed) || (q === 32'b0)) begin
            $display("FAIL lfsr_tb: LFSR did not advance correctly: %h", q);
            $finish;
        end

        $display("PASS lfsr_tb");
        $finish;
    end

endmodule
