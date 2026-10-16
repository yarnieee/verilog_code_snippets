`timescale 1ns / 1ps

// wire [15:0] switch_to_led_value;
// switch_to_led switch_to_led_inst (
//     .sw(sw),
//     .led(switch_to_led_value)
// );

module switch_to_led(
    input [15:0] sw,
    output [15:0] led
    );
    
    assign led = sw;
    
endmodule
