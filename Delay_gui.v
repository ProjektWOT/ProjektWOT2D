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
    
    reg [10:0] hcount_temp;
    reg [9:0] vcount_temp;
    reg hblnk_temp, vblnk_temp, hsync_temp, vsync_temp;
always @(posedge clk) begin
    if(rst) {hcount_out, vcount_out, hblnk_out, vblnk_out, hsync_out, vsync_out, hcount_temp, vcount_temp, hblnk_temp, vblnk_temp, hsync_temp, vsync_temp} <= 0;
    else begin
        hcount_temp <= hcount_in;
        vcount_temp <= vcount_in;
        hblnk_temp <= hblnk_in;
        vblnk_temp <= vblnk_in;
        hsync_temp <= hsync_in;
        vsync_temp <= vsync_in;
    
        hcount_out <= hcount_temp;
        vcount_out <= vcount_temp;
        hblnk_out <= hblnk_temp;
        vblnk_out <= vblnk_temp;
        hsync_out <= hsync_temp;
        vsync_out <= vsync_temp;
        end
    end
endmodule
