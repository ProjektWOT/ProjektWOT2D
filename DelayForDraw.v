`timescale 1ns / 1ps

module DelayForDraw(
    input wire clk,
    input wire rst,
    input wire [11:0] xposMouse,
    input wire [11:0] yposMouse,
    
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );
    
always @(posedge clk) begin
    if(rst) begin
        xpos <= xposMouse;
        ypos <= yposMouse;
        end
    else begin
        xpos <= xposMouse;
        ypos <= yposMouse;
        end
    end
endmodule
