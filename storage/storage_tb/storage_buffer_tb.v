
`timescale 1ns / 1ps

module storage_buffer_tb;
    reg clk;
    reg rst;
    reg en;
    reg [7:0] data_in;
    wire [31:0] storage_out;

    last_x_storage #(
        .X(4),
        .WIDTH(8)
        ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .data_in(data_in),
        .storage_out(storage_out)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task push_value;
        input [7:0] value;
        begin
            data_in = value;
            en = 1'b1;
            @(posedge clk);
            #1;
            en = 1'b0;
        end
    endtask

    initial begin
        rst = 1'b1;
        en = 1'b0;
        data_in = 8'b0;
        @(posedge clk);
        #1;
        rst = 1'b0;

        push_value(8'd1);
        push_value(8'd2);
        push_value(8'd3);
        push_value(8'd4);

        if (storage_out !== {8'd1, 8'd2, 8'd3, 8'd4}) begin
            $display("FAIL storage_buffer_tb: output was %h", storage_out);
            $finish;
        end

        $display("PASS storage_buffer_tb");
        $finish;
    end

endmodule
