`timescale 1ns / 1ps

module Tank_Oponent(
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
    input wire [1:0] direction_tank_fromUART,
    
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

wire [11:0] xpos_d, ypos_d, rgb_ctl, Address, rgb_image0, rgb_image1, rgb_image2, rgb_image3;
wire [10:0] hcount_d; //, hcount_ctl;
wire [9:0] vcount_d; //, vcount_ctl; xposTank, yposTank,
wire hsync_d, vsync_d, hblnk_d, vblnk_d; //, hsync_ctl, vsync_ctl, hblnk_ctl, vblnk_ctl, Select_ctl;
    
Delay_op Delay_op(
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
    
draw_tank_op DrawTank_op(
    .clk(clk),
    .rst(rst),
    .select(SelectMode),
    .hcount_in(hcount_d),
    .vcount_in(vcount_d),
    .hsync_in(hsync_d),
    .vsync_in(vsync_d),
    .hblnk_in(hblnk_d),
    .vblnk_in(vblnk_d),
    .rgb_in(rgb_in),
    .posX(Data_in_X),
    .posY(Data_in_Y),
    .rgb_pixel_0(rgb_image0),
    .rgb_pixel_1(rgb_image1),
    .rgb_pixel_2(rgb_image2),
    .rgb_pixel_3(rgb_image3),
    .direction_tank(direction_tank_fromUART),
    
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

Choose_image_tank_op Choose_image_tank_op(
    .clk(clk),
    .address(Address),
    
    .rgb0(rgb_image0),
    .rgb1(rgb_image1),
    .rgb2(rgb_image2),
    .rgb3(rgb_image3)
);

DelayForDraw_op DelayForDraw_op(
    .clk(clk),
    .xposMouse(xpos_d),
    .yposMouse(ypos_d),
    
    .xpos(xpos_out),
    .ypos(ypos_out)
);
endmodule
