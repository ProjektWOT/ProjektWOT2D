`timescale 1ns / 1ps

module Delay(
    input wire clk,

    input wire [11:0] xpos,
    input wire [11:0] ypos,
    
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out  
    );  
    
    always@(posedge clk) begin
            xpos_out <= xpos;
            ypos_out <= ypos;
        end
endmodule
