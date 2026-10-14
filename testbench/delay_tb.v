`timescale 1ns / 1ps

module delay_tb;
    reg clk;
    reg enable;
    wire done;

    delay #(.DELAY(3)) dut (
        .clk(clk),
        .enable(enable),
        .done(done)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_done;
        input expected;
        begin
            #1;
            if (done !== expected) begin
                $display("FAIL delay: expected %b, got %b at %0t", expected, done, $time);
                $finish;
            end
        end
    endtask

    initial begin
        enable = 1'b0;

        repeat (2) @(posedge clk);
        expect_done(1'b0);

        // DELAY=3 reaches done after four enabled clock edges because
        // the counter visits 0, 1, 2, and 3.
        enable = 1'b1;
        repeat (3) begin
            @(posedge clk);
            expect_done(1'b0);
        end
        @(posedge clk);
        expect_done(1'b1);

        // done remains asserted while enable remains asserted.
        repeat (2) begin
            @(posedge clk);
            expect_done(1'b1);
        end

        // Disabling resets the timer and its completion flag.
        enable = 1'b0;
        @(posedge clk);
        expect_done(1'b0);

        // The timer can be started again from zero.
        enable = 1'b1;
        repeat (3) begin
            @(posedge clk);
            expect_done(1'b0);
        end
        @(posedge clk);
        expect_done(1'b1);

        $display("PASS delay_tb");
        $finish;
    end
endmodule
