`timescale 1ns / 1ps

module Delay(
    input wire clk,
    input wire [9:0] Data_X_in,
    input wire [9:0] Data_Y_in,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
 
    output reg [9:0] Data_X_out,
    output reg [9:0] Data_Y_out,
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out  
    );  
    
    always@(posedge clk) begin
            Data_X_out <= Data_X_in;
            Data_Y_out <= Data_Y_in;
            xpos_out <= xpos;
            ypos_out <= ypos;
        end
endmodule

