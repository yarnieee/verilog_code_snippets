
`timescale 1ns / 1ps

module market_state_tb;
    reg clk;
    reg rst;
    reg start;
    reg day_tick;
    reg [1:0] random_state;
    reg [2:0] random_interval;
    wire [1:0] state;

    market_state dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .day_tick(day_tick),
        .random_state(random_state),
        .random_interval(random_interval),
        .state(state)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task send_day_tick;
        begin
            day_tick = 1'b1;
            @(posedge clk);
            #1;
            day_tick = 1'b0;
        end
    endtask

    initial begin
        rst = 1'b1;
        start = 1'b0;
        day_tick = 1'b0;
        random_state = 2'b11;
        random_interval = 3'b0;

        @(posedge clk);
        #1;
        rst = 1'b0;
        start = 1'b1;
        @(posedge clk);
        #1;
        start = 1'b0;

        repeat (4) begin
            send_day_tick;
        end
        if (state !== 2'b01) begin
            $display("FAIL market_state_tb: state changed before five days");
            $finish;
        end

        send_day_tick;
        if (state !== random_state) begin
            $display("FAIL market_state_tb: state did not change after five days");
            $finish;
        end

        $display("PASS market_state_tb");
        $finish;
    end

endmodule
