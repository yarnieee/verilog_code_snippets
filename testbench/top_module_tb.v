`timescale 1ns / 1ps

module top_module_tb;
    reg clk;
    reg [4:0] btn;
    reg [15:0] sw;
    wire [15:0] led;
    wire [3:0] an;
    wire [7:0] seg;
    wire [7:0] JB;

    initial clk = 1'b0;

    always begin
        clk = ~clk; #5
    end

    top_module top_module_inst (
        .clk(clk),
        .btn(btn),
        .sw(sw),
        .led(led),
        .an(an),
        .seg(seg),
        .JB(JB)
    );

    initial begin
        btn = 5'b0;
        sw = 16'b0;
        repeat (3) @(posedge clk);
        #1;
        if (led !== 16'hffff) begin
            $display("FAIL top_module: expected startup LED pattern ffff, got %h", led);
            $finish;
        end
        if (an !== 4'b1110 || seg !== 8'hff) begin
            $display("FAIL top_module: unexpected seven-segment startup output an=%b seg=%h", an, seg);
            $finish;
        end

        $display("PASS top_module_tb");
        $finish;
    end

endmodule
