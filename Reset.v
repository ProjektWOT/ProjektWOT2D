`timescale 1ns / 1ps

module Reset(
    input wire clk,
    input wire locked,
    output reg reset
    );
    
always@(posedge clk or negedge locked) begin
    if(locked == 0) reset <= 1;
    else reset <= 0;
    end
endmodule
