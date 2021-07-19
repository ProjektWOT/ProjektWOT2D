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

wire [11:0] xposTank, yposTank, xpos_d, ypos_d, rgb_ctl, Address, rgb_image;
wire [10:0] hcount_d, hcount_ctl;
wire [9:0] vcount_d, vcount_ctl;
wire hsync_d, vsync_d, hblnk_d, vblnk_d, hsync_ctl, vsync_ctl, hblnk_ctl, vblnk_ctl, Select_ctl;
    
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
    .xpos_out(xpos_d),
    .ypos_out(ypos_d)  
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
        
    .Select_out(Select_ctl),
    .hcount_out(hcount_ctl),
    .vcount_out(vcount_ctl),
    .hsync_out(hsync_ctl),
    .vsync_out(vsync_ctl),
    .hblnk_out(hblnk_ctl),
    .vblnk_out(vblnk_ctl),
    .rgb_out(rgb_ctl),
    .xpos(xposTank),
    .ypos(yposTank)  
);

draw_tank DrawTank(
    .clk(clk),
    .rst(rst),
    .select(Select_ctl),
    .hcount_in(hcount_ctl),
    .vcount_in(vcount_ctl),
    .hsync_in(hsync_ctl),
    .vsync_in(vsync_ctl),
    .hblnk_in(hblnk_ctl),
    .vblnk_in(vblnk_ctl),
    .rgb_in(rgb_ctl),
    .rgb_pixel(rgb_image),
    .posX(xposTank),
    .posY(yposTank),
    
    .hcount_out(hcount_out),
    .hsync_out(hsync_out),
    .hblnk_out(hblnk_out),
    .vcount_out(vcount_out),
    .vsync_out(vsync_out),
    .vblnk_out(vblnk_out),
    .select_out(Select_out),
    .rgb_out(rgb_out),
    .pixel_addr(Address)
);

image_tank ImageTank(
    .clk(clk),
    .address(Address),
    
    .rgb(rgb_image)
);

DelayForDraw DelayForDraw(
    .clk(clk),
    .rst(rst),
    .xposMouse(xpos_d),
    .yposMouse(ypos_d),
    
    .xpos(xpos_out),
    .ypos(ypos_out)
);
endmodule

