
`timescale 1ns / 1ps

module normalise_lfsr_tb;
    reg [31:0] lfsr_value;
    wire [7:0] normalized;

    normalise_lfsr dut (
        .lfsr_value(lfsr_value),
        .normalized(normalized)
    );

    initial begin
        lfsr_value = 32'b0;
        #1;
        if (normalized !== 8'd0) begin
            $display("FAIL normalise_lfsr_tb: zero input was %0d", normalized);
            $finish;
        end

        lfsr_value = 32'hFFFFFFFF;
        #1;
        if (normalized !== 8'd100) begin
            $display("FAIL normalise_lfsr_tb: maximum input was %0d", normalized);
            $finish;
        end

        lfsr_value = 32'h80808080;
        #1;
        if (normalized !== 8'd50) begin
            $display("FAIL normalise_lfsr_tb: midpoint input was %0d", normalized);
            $finish;
        end

        $display("PASS normalise_lfsr_tb");
        $finish;
    end

endmodule
