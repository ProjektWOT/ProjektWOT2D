`timescale 1ns / 1ps

module Tank_Gen(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [11:0] rgb_in,
    input wire SelectMode,
    input wire [9:0] Data_in_X,
    input wire [9:0] Data_in_Y,
    
    output wire hsync_out,
    output wire vsync_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire [10:0] hcount_out,
    output wire [9:0]  vcount_out,
    output wire [11:0] rgb_out,
    output wire Select_out,
    output wire [11:0] xpos_out,
    output wire  [11:0] ypos_out 
);
    
wire [10:0] hcount_d;
wire [9:0] vcount_d;
wire hsync_d, vsync_d, hblnk_d, vblnk_d;
    
Delay Delay(
    .clk(clk),
    .rst(rst),
    .xpos(xpos),
    .ypos(ypos),
    .hcount(hcount),
    .vcount(vcount),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hsync(hsync),
    .vsync(vsync),
        
    .hcount_out(hcount_d),
    .vcount_out(vcount_d),
    .hsync_out(hsync_d),
    .vsync_out(vsync_d),
    .hblnk_out(hblnk_d),
    .vblnk_out(vblnk_d),
    .xpos_out(xpos_out),
    .ypos_out(ypos_out)  
);
    
Control Control(
    .clk(clk),
    .rst(rst),
    .SelectMode(SelectMode),
    .hcount(hcount_d),
    .vcount(vcount_d),
    .hblnk(hblnk_d),
    .vblnk(vblnk_d),
    .hsync(hsync_d),
    .vsync(vsync_d),
    .rgb_in(rgb_in),
    .Data_in_X(Data_in_X),
    .Data_in_Y(Data_in_Y),
        
    .Select_out(Select_out),
    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .hblnk_out(hblnk_out),
    .vblnk_out(vblnk_out),
    .rgb_out(rgb_out)     
);
endmodule
