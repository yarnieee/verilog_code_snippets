
`timescale 1ns / 1ps

module stock_tb;
    reg clk;
    reg rst;
    reg day_tick;
    reg [1:0] market_state;
    reg [7:0] normalized_random;
    wire ready;
    wire [15:0] current_close;
    wire [31:0] current_volume;
    wire [31:0] current_date;
    wire [(180*16)-1:0] close_history;
    wire [(180*32)-1:0] volume_history;
    wire [(180*32)-1:0] date_history;

    stock #(
        .BUFFER_DEPTH(180),
        .VOLATILITY(10),
        .SEED_FILE("storage/data/AMD_seed.mem")
        ) dut (
        .clk(clk),
        .rst(rst),
        .day_tick(day_tick),
        .market_state(market_state),
        .normalized_random(normalized_random),
        .ready(ready),
        .current_close(current_close),
        .current_volume(current_volume),
        .current_date(current_date),
        .close_history(close_history),
        .volume_history(volume_history),
        .date_history(date_history)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        day_tick = 1'b0;
        market_state = 2'b01;
        normalized_random = 8'd50;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        wait (ready);
        #1;

        if (current_close !== 16'd21343) begin
            $display("FAIL stock_tb: seeded close was %0d", current_close);
            $finish;
        end
        if (current_date !== 32'd20251219) begin
            $display("FAIL stock_tb: seeded date was %0d", current_date);
            $finish;
        end

        day_tick = 1'b1;
        @(posedge clk);
        #1;
        day_tick = 1'b0;

        if (current_close !== 16'd19208) begin
            $display("FAIL stock_tb: generated close was %0d", current_close);
            $finish;
        end
        if (current_date !== 32'd20251222) begin
            $display("FAIL stock_tb: generated date was %0d", current_date);
            $finish;
        end
        if (close_history[15:0] !== 16'd19208
            || close_history[31:16] !== 16'd21343) begin
            $display("FAIL stock_tb: history ordering was incorrect");
            $finish;
        end

        $display("PASS stock_tb");
        $finish;
    end

endmodule
