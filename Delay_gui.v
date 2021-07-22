`timescale 1ns / 1ps

module Delay_gui(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0] vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire hsync_in,
    input wire vsync_in,
    
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out
    );
    
always @(posedge clk) begin
    if(rst) {hcount_out, vcount_out, hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
    else begin       
        hcount_out <= hcount_in;
        vcount_out <= vcount_in;
        hblnk_out <= hblnk_in;
        vblnk_out <= vblnk_in;
        hsync_out <= hsync_in;
        vsync_out <= vsync_in;
        end
    end
endmodule
