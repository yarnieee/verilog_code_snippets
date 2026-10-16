`timescale 1ns / 1ps

module control_oled_tb;
    reg clk;
    reg [2:0] mode;
    reg rst;
    wire [7:0] JB;

    control_oled dut (
        .clk(clk),
        .mode(mode),
        .rst(rst),
        .JB(JB)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_center;
        input [6:0] expected_x;
        input [5:0] expected_y;
        begin
            #1;
            if ((dut.oled_renderer_inst.circle1_cx !== expected_x) ||
                (dut.oled_renderer_inst.circle1_cy !== expected_y)) begin
                $display("FAIL control_oled: expected center (%0d,%0d), got (%0d,%0d) at %0t",
                    expected_x, expected_y,
                    dut.oled_renderer_inst.circle1_cx,
                    dut.oled_renderer_inst.circle1_cy,
                    $time);
                $finish;
            end
        end
    endtask

    initial begin
        rst = 1'b1;
        mode = 3'd0;
        force dut.step_tick = 1'b0;
        repeat (2) @(posedge clk);
        expect_center(7'd16, 6'd32);

        rst = 1'b0;
        mode = 3'd4;
        expect_center(7'd16, 6'd32);

        // Force a fast animation tick and check both directions.
        force dut.step_tick = 1'b1;
        @(posedge clk);
        expect_center(7'd17, 6'd32);

        repeat (62) @(posedge clk);
        expect_center(7'd79, 6'd32);
        @(posedge clk);
        expect_center(7'd80, 6'd32);
        @(posedge clk);
        expect_center(7'd79, 6'd32);

        // Leaving mode 4 resets the path to its first endpoint.
        force dut.step_tick = 1'b0;
        mode = 3'd0;
        @(posedge clk);
        mode = 3'd4;
        expect_center(7'd16, 6'd32);

        release dut.step_tick;
        $display("PASS control_oled_tb");
        $finish;
    end
endmodule
