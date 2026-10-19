
`timescale 1ns / 1ps

module A_top_tb;
    reg clk;
    reg rst;
    wire [1:0] market_state;
    wire amd_ready;
    wire mcd_ready;
    wire [31:0] amd_current_date;
    wire [31:0] mcd_current_date;
    wire [(30*16)-1:0] amd_samples_30;
    wire [15:0] amd_mean_30;
    wire [15:0] mcd_mean_30;

    A_top #(
        .DAY_MAX_COUNT(2),
        .BUFFER_DEPTH(180)
        ) dut (
        .clk(clk),
        .rst(rst),
        .market_state(market_state),
        .amd_ready(amd_ready),
        .mcd_ready(mcd_ready),
        .amd_current_date(amd_current_date),
        .mcd_current_date(mcd_current_date),
        .amd_samples_30(amd_samples_30),
        .amd_mean_30(amd_mean_30),
        .mcd_mean_30(mcd_mean_30)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        wait (amd_ready && mcd_ready);
        #1;

        if (amd_current_date === 32'b0 || mcd_current_date === 32'b0) begin
            $display("FAIL A_top_tb: seeded dates were not loaded");
            $finish;
        end
        if (amd_samples_30 === {(30*16){1'b0}}
            || amd_mean_30 === 16'b0
            || mcd_mean_30 === 16'b0) begin
            $display("FAIL A_top_tb: sampled outputs were not populated");
            $finish;
        end
        if ((market_state === 2'bx) || (market_state === 2'bz)) begin
            $display("FAIL A_top_tb: market state was unknown");
            $finish;
        end

        $display("PASS A_top_tb");
        $finish;
    end

endmodule
