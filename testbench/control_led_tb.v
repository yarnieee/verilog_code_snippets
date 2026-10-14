`timescale 1ns / 1ps

module control_led_tb;
    reg clk;
    reg [2:0] mode;
    reg rst;
    wire [15:0] led;

    control_led dut (
        .clk(clk),
        .mode(mode),
        .rst(rst),
        .led(led)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_led;
        input [15:0] expected;
        begin
            #1;
            if (led !== expected) begin
                $display("FAIL control_led: expected %h, got %h at %0t", expected, led, $time);
                $finish;
            end
        end
    endtask

    initial begin
        rst = 1'b1;
        mode = 3'd0;
        repeat (2) @(posedge clk);
        expect_led(16'hffff);

        rst = 1'b0;
        mode = 3'd1;
        expect_led(16'h0fff);

        // Use a forced one-cycle animation tick so the test remains fast.
        force dut.step_tick = 1'b0;
        mode = 3'd5;
        @(posedge clk);
        expect_led(16'h0001);

        force dut.step_tick = 1'b1;
        @(posedge clk);
        expect_led(16'h0002);

        repeat (14) @(posedge clk);
        expect_led(16'h8000);

        @(posedge clk);
        expect_led(16'h4000);

        // Leaving the mode resets the loop; re-entering starts at LED 0.
        force dut.step_tick = 1'b0;
        mode = 3'd0;
        @(posedge clk);
        mode = 3'd5;
        expect_led(16'h0001);

        release dut.step_tick;
        $display("PASS control_led_tb");
        $finish;
    end
endmodule
