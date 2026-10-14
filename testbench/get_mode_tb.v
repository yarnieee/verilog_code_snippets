`timescale 1ns / 1ps

module get_mode_tb;
    reg clk;
    reg [4:0] btn;
    reg [15:0] sw;
    reg rst;
    wire [2:0] mode;

    get_mode dut (
        .clk(clk),
        .btn(btn),
        .sw(sw),
        .rst(rst),
        .mode(mode)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_mode;
        input [2:0] expected;
        begin
            #1;
            if (mode !== expected) begin
                $display("FAIL get_mode: expected %0d, got %0d at %0t", expected, mode, $time);
                $finish;
            end
        end
    endtask

    initial begin
        btn = 5'b0;
        sw = 16'b0;
        rst = 1'b1;
        force dut.delay_1s_done = 1'b0;
        repeat (2) @(posedge clk);
        expect_mode(3'd0);

        rst = 1'b0;
        sw[0] = 1'b1;
        repeat (2) @(posedge clk);
        expect_mode(3'd0);

        // Release the startup delay and enter the enabled state.
        force dut.delay_1s_done = 1'b1;
        @(posedge clk);
        expect_mode(3'd1);

        // With the movement button off, the next state is paused mode 2.
        @(posedge clk);
        expect_mode(3'd2);

        // A debounced movement indication returns to mode 1.
        force dut.enable_movement = 1'b1;
        @(posedge clk);
        expect_mode(3'd1);
        release dut.enable_movement;

        @(posedge clk);
        expect_mode(3'd2);

        rst = 1'b1;
        @(posedge clk);
        expect_mode(3'd0);

        release dut.delay_1s_done;
        $display("PASS get_mode_tb");
        $finish;
    end
endmodule
