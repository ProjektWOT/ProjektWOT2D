`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module reset(
    input wire clk,
    input wire locked,
    
    output reg reset
);
    
always@(posedge clk or negedge locked) begin
    if(locked == 0) reset <= 1;
    else reset <= 0;
end

endmodule
