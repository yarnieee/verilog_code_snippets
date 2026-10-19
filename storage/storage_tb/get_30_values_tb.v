
`timescale 1ns / 1ps

module get_30_values_tb;
    reg [(180*16)-1:0] history_in;
    wire [(30*16)-1:0] samples_30;
    wire [(30*16)-1:0] samples_180;
    wire [15:0] mean_30;
    wire [15:0] mean_180;
    integer i;

    get_30_values #(
        .WINDOW(30),
        .TOTAL_DEPTH(180)
        ) get_30_values_inst (
        .history_in(history_in),
        .samples_out(samples_30),
        .mean_out(mean_30)
    );

    get_30_values #(
        .WINDOW(180),
        .TOTAL_DEPTH(180)
        ) get_180_values_inst (
        .history_in(history_in),
        .samples_out(samples_180),
        .mean_out(mean_180)
    );

    initial begin
        history_in = {(180*16){1'b0}};
        for (i = 0; i < 180; i = i + 1) begin
            history_in[i*16 +: 16] = i + 1;
        end
        #1;

        if (samples_30[15:0] !== 16'd30
            || samples_30[29*16 +: 16] !== 16'd1
            || mean_30 !== 16'd15) begin
            $display("FAIL get_30_values_tb: 30-point view was incorrect");
            $finish;
        end
        if (samples_180[15:0] !== 16'd177
            || samples_180[29*16 +: 16] !== 16'd3
            || mean_180 !== 16'd90) begin
            $display("FAIL get_30_values_tb: 180-point view was incorrect");
            $finish;
        end

        $display("PASS get_30_values_tb");
        $finish;
    end

endmodule
