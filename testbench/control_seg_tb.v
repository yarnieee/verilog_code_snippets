`timescale 1ns / 1ps

module control_seg_tb;
    reg clk;
    reg [2:0] mode;
    reg rst;
    wire [3:0] an;
    wire [7:0] seg;

    control_seg dut (
        .clk(clk),
        .mode(mode),
        .rst(rst),
        .an(an),
        .seg(seg)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task expect_renderer;
        input [31:0] expected;
        begin
            #1;
            if (dut.seg_renderer_inst.all_seg !== expected) begin
                $display("FAIL control_seg: expected renderer %h, got %h at %0t",
                    expected, dut.seg_renderer_inst.all_seg, $time);
                $finish;
            end
        end
    endtask

    initial begin
        rst = 1'b0;
        mode = 3'd0;
        force dut.get_active_anode_inst.active_anode = 2'd0;
        force dut.seg_renderer_inst.step_tick = 1'b0;
        @(posedge clk);
        expect_renderer(32'hffff_ffff);

        mode = 3'd1;
        @(posedge clk);
        expect_renderer(32'hffff_ff80);

        // The glyph advances one digit when the template is ticked.
        force dut.seg_renderer_inst.step_tick = 1'b1;
        @(posedge clk);
        expect_renderer(32'hffff_80ff);

        // Mode 2 pauses at the current position.
        mode = 3'd2;
        @(posedge clk);
        expect_renderer(32'hffff_80ff);

        // Leaving the animation modes blanks the display and resets it.
        mode = 3'd0;
        @(posedge clk);
        expect_renderer(32'hffff_ffff);

        release dut.seg_renderer_inst.step_tick;
        release dut.get_active_anode_inst.active_anode;
        $display("PASS control_seg_tb");
        $finish;
    end
endmodule
