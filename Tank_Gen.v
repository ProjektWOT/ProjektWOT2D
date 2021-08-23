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
    input wire [9:0] Data_X_op,
    input wire [9:0] Data_Y_op,
    input wire left_click,
    
    output wire hsync_out,
    output wire vsync_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire [10:0] hcount_out,
    output wire [9:0]  vcount_out,
    output wire [11:0] rgb_out,
    output wire Select_out,
    output wire [11:0] xpos_out,
    output wire [11:0] ypos_out,
    output wire [9:0] xpos_UART,
    output wire [9:0] ypos_UART
);

wire [11:0] rgb_image0, rgb_image1, rgb_image2, rgb_image3, rgb_draw, rgb_gun;
wire [11:0] xposTank, yposTank, xpos_d, ypos_d, rgb_ctl, Address, xpos_draw, ypos_draw, xpos_gun, ypos_gun;
wire [10:0]  hcount_ctl, hcount_draw, hcount_gun; //, hcount_d;
wire [9:0]  vcount_ctl, vcount_draw, vcount_gun; //, vcount_d;
wire hsync_ctl, vsync_ctl, hblnk_ctl, vblnk_ctl, Select_ctl, Select_draw, hblnk_draw, vblnk_draw, hsync_draw, vsync_draw,
hblnk_gun, vblnk_gun, hsync_gun, vsync_gun; 
wire [1:0] direction_bullet, direction_bullet_draw;
wire [9:0] Data_X_op_out, Data_Y_op_out, posX_drawtank, posY_drawtank;
wire tank_our_hit; 

Delay Delay(
    .clk(clk),
    .xpos(xpos),
    .ypos(ypos),
    .Data_X_in(Data_X_op),
    .Data_Y_in(Data_Y_op),
    
    .Data_X_out(Data_X_op_out),
    .Data_Y_out(Data_Y_op_out),
    .xpos_out(xpos_d),
    .ypos_out(ypos_d)  
);
    
Control Control(
    .clk(clk),
    .rst(rst),
    .SelectMode(SelectMode),
    .hcount(hcount),
    .vcount(vcount),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hsync(hsync),
    .vsync(vsync),
    .rgb_in(rgb_in),
    .Data_in_X(Data_in_X),
    .Data_in_Y(Data_in_Y),
    .Data_X_op(Data_X_op_out),
    .Data_Y_op(Data_Y_op_out),
    
    .Select_out(Select_ctl),
    .hcount_out(hcount_ctl),
    .vcount_out(vcount_ctl),
    .hsync_out(hsync_ctl),
    .vsync_out(vsync_ctl),
    .hblnk_out(hblnk_ctl),
    .vblnk_out(vblnk_ctl),
    .rgb_out(rgb_ctl),
    .xpos_UART(xpos_UART),
    .ypos_UART(ypos_UART),
    .direction_bullet(direction_bullet)
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
    .rgb_pixel_0(rgb_image0),
    .rgb_pixel_1(rgb_image1),
    .rgb_pixel_2(rgb_image2),
    .rgb_pixel_3(rgb_image3),
    .posX(xpos_UART),
    .posY(ypos_UART),
    .direction_bullet(direction_bullet),
    
    .hcount_out(hcount_draw),
    .hsync_out(hsync_draw),
    .hblnk_out(hblnk_draw),
    .vcount_out(vcount_draw),
    .vsync_out(vsync_draw),
    .vblnk_out(vblnk_draw),
    .select_out(Select_draw),
    .rgb_out(rgb_draw),
    .pixel_addr(Address),
    .posX_out_tank(posX_drawtank),
    .posY_out_tank(posY_drawtank),
    .direction_bullet_out(direction_bullet_draw)
);
ChoseTheImageOfTank ChoseTheImageOfTank(
    .clk(clk),
    .address(Address),

    .rgb0(rgb_image0),
    .rgb1(rgb_image1),
    .rgb2(rgb_image2),
    .rgb3(rgb_image3)
);

DelayForDraw DelayForDraw(
    .clk(clk),
    .xposMouse(xpos_d),
    .yposMouse(ypos_d),
    
    .xpos(xpos_draw),
    .ypos(ypos_draw)
);

Gun_ctrl Gun_ctrl(
    .clk(clk),
    .rst(rst),
    .left_click(left_click),
    .select(Select_draw),
    .hblnk(hblnk_draw),
    .vblnk(vblnk_draw),
    .hsync(hsync_draw),
    .vsync(vsync_draw),
    .hcount(hcount_draw),
    .vcount(vcount_draw),
    .rgb(rgb_draw),
    .xpos_m(xpos_draw),
    .ypos_m(ypos_draw),
    .xpos_t(posX_drawtank),
    .ypos_t(posY_drawtank),
    .xpos_t_op(Data_X_op_out),
    .ypos_t_op(Data_Y_op_out),
    .direction_bullet(direction_bullet_draw),
    
    .select_out(Select_out),
    .hblnk_out(hblnk_gun),
    .vblnk_out(vblnk_gun),
    .hsync_out(hsync_gun),
    .vsync_out(vsync_gun),
    .hcount_out(hcount_gun),
    .vcount_out(vcount_gun),
    .rgb_out(rgb_gun),
    .xpos_m_out(xpos_gun),
    .ypos_m_out(ypos_gun),
    .tank_central_hit(tank_our_hit),
    .xpos_bullet_green(),
    .ypos_bullet_green()
);

Opponent_Bullet Opponent_Bullet(
    .clk(clk),
    .rst(rst),
    .xpos_bullet_red(),
    .ypos_bullet_red(),
    .hblnk(hblnk_gun),
    .vblnk(vblnk_gun),
    .hsync(hsync_gun),
    .vsync(vsync_gun),
    .hcount(hcount_gun),
    .vcount(vcount_gun),
    .rgb(rgb_gun),
    .xpos_m(xpos_gun),
    .ypos_m(ypos_gun),
    .tank_enemy_hit_us(),
    .tank_our_hit(tank_our_hit),
    
    .hblnk_out(hblnk_out),
    .vblnk_out(vblnk_out),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .rgb_out(rgb_out),
    .xpos_m_out(xpos_out),
    .ypos_m_out(ypos_out),
    .tank_enemy_hit_us_out(),
    .tank_our_hit_out()
);
endmodule
