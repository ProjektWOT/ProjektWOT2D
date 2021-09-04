`timescale 1ns / 1ps

module tank_oponent(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_mouse,
    input wire [11:0] ypos_mouse,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [11:0] rgb_in,
    input wire select_mode,
    input wire [9:0] xpos_tank_op,
    input wire [9:0] ypos_tank_op,
    input wire [1:0] direction_tank_uart_out,
    
    output wire hsync_out,
    output wire vsync_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire [10:0] hcount_out,
    output wire [9:0]  vcount_out,
    output wire [11:0] rgb_out,
    output wire select_out,
    output wire [11:0] xpos_mouse_out,
    output wire [11:0] ypos_mouse_out 
);

//WIRES
//****************************************************************************************************************//
wire [11:0] xpos_mouse_d, ypos_mouse_d;
wire [11:0] rgb_ctl, rgb_image0, rgb_image1, rgb_image2, rgb_image3;
wire [11:0] address; 
wire [10:0] hcount_d;
wire [9:0] vcount_d;
wire hsync_d, vsync_d, hblnk_d, vblnk_d;
    
delay_op delay_op(
    .clk(clk),
    .rst(rst),
    .hcount(hcount),
    .vcount(vcount),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hsync(hsync),
    .vsync(vsync),
    .xpos_mouse_in(xpos_mouse),
    .ypos_mouse_in(ypos_mouse),
       
    .hcount_out(hcount_d),
    .vcount_out(vcount_d),
    .hsync_out(hsync_d),
    .vsync_out(vsync_d),
    .hblnk_out(hblnk_d),
    .vblnk_out(vblnk_d),
    .xpos_mouse_out(xpos_mouse_d),
    .ypos_mouse_out(ypos_mouse_d)  
);
    
draw_tank_op draw_tank_op(
    .clk(clk),
    .rst(rst),
    .select(select_mode),
    .hcount_in(hcount_d),
    .vcount_in(vcount_d),
    .hsync_in(hsync_d),
    .vsync_in(vsync_d),
    .hblnk_in(hblnk_d),
    .vblnk_in(vblnk_d),
    .rgb_in(rgb_in),
    .xpos_tank_op(xpos_tank_op),
    .ypos_tank_op(ypos_tank_op),
    .rgb_pixel_0(rgb_image0),
    .rgb_pixel_1(rgb_image1),
    .rgb_pixel_2(rgb_image2),
    .rgb_pixel_3(rgb_image3),
    .direction_tank(direction_tank_uart_out),
    
    .hcount_out(hcount_out),
    .hsync_out(hsync_out),
    .hblnk_out(hblnk_out),
    .vcount_out(vcount_out),
    .vsync_out(vsync_out),
    .vblnk_out(vblnk_out),
    .select_out(select_out),
    .rgb_out(rgb_out),
    .pixel_addr(address)
);

choose_image_tank_op choose_image_tank_op(
    .clk(clk),
    .address(address),
    
    .rgb0(rgb_image0),
    .rgb1(rgb_image1),
    .rgb2(rgb_image2),
    .rgb3(rgb_image3)
);

delay_for_draw_op delay_for_draw_op(
    .clk(clk),
    .xpos_mouse_in(xpos_mouse_d),
    .ypos_mouse_in(ypos_mouse_d),
    
    .xpos_mouse_out(xpos_mouse_out),
    .ypos_mouse_out(ypos_mouse_out)
);

endmodule
