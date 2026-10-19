
`timescale 1ns / 1ps

module get_latest_values_tb;
    reg [(180*16)-1:0] history_in;
    wire [(8*16)-1:0] latest_8;
    wire [(30*16)-1:0] latest_30;
    integer i;

    get_latest_values #(
        .X(8),
        .TOTAL_DEPTH(180)
        ) get_latest_8_inst (
        .history_in(history_in),
        .latest_values(latest_8)
    );

    get_latest_values #(
        .X(30),
        .TOTAL_DEPTH(180)
        ) get_latest_30_inst (
        .history_in(history_in),
        .latest_values(latest_30)
    );

    initial begin
        history_in = {(180*16){1'b0}};
        for (i = 0; i < 180; i = i + 1) begin
            history_in[i*16 +: 16] = i + 1;
        end
        #1;

        if (latest_8[15:0] !== 16'd1
            || latest_8[7*16 +: 16] !== 16'd8
            || latest_30[29*16 +: 16] !== 16'd30) begin
            $display("FAIL get_latest_values_tb: latest values were incorrect");
            $finish;
        end

        $display("PASS get_latest_values_tb");
        $finish;
    end

endmodule
