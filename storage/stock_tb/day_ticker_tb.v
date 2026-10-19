
`timescale 1ns / 1ps

module day_ticker_tb;
    reg clk;
    reg rst;
    wire tick;

    day_ticker #(
        .MAX_COUNT(2)
        ) dut (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        @(posedge clk);
        #1;
        rst = 1'b0;

        @(posedge clk);
        #1;
        if (tick !== 1'b0) begin
            $display("FAIL day_ticker_tb: tick arrived too early");
            $finish;
        end
        @(posedge clk);
        #1;
        if (tick !== 1'b0) begin
            $display("FAIL day_ticker_tb: tick arrived too early");
            $finish;
        end
        @(posedge clk);
        #1;
        if (tick !== 1'b1) begin
            $display("FAIL day_ticker_tb: expected tick after MAX_COUNT");
            $finish;
        end

        $display("PASS day_ticker_tb");
        $finish;
    end

endmodule
