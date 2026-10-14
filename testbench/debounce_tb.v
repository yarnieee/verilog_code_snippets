`timescale 1ns / 1ps

module debounce_tb;
    reg clk;
    reg btn;
    wire debounced;

    debouncer #(.DEBOUNCE_CTR(3)) dut (
        .clk(clk),
        .btn(btn),
        .debounced(debounced)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_debounced;
        input expected;
        begin
            #1;
            if (debounced !== expected) begin
                $display("FAIL debounce: expected %b, got %b at %0t", expected, debounced, $time);
                $finish;
            end
        end
    endtask

    initial begin
        btn = 1'b0;

        repeat (2) @(posedge clk);
        expect_debounced(1'b0);

        // A press arms the debounce interval but does not toggle the output.
        btn = 1'b1;
        @(posedge clk);
        expect_debounced(1'b0);

        // Keep the button pressed until the counter reaches its limit.
        repeat (4) @(posedge clk);
        expect_debounced(1'b0);

        // A stable release toggles the output once.
        btn = 1'b0;
        @(posedge clk);
        expect_debounced(1'b1);

        // Holding the button released must not toggle again.
        repeat (2) @(posedge clk);
        expect_debounced(1'b1);

        // A second complete press/release toggles back once.
        btn = 1'b1;
        @(posedge clk);
        repeat (4) @(posedge clk);
        btn = 1'b0;
        @(posedge clk);
        expect_debounced(1'b0);

        $display("PASS debounce_tb");
        $finish;
    end
endmodule
