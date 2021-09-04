`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module tank_gen(
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
    input wire [9:0] data_in_x_jstk,
    input wire [9:0] data_in_y_jstk,
    input wire [9:0] xpos_tank_op_in,
    input wire [9:0] ypos_tank_op_in,
    input wire left_click,
    
    input wire tank_our_hit_uart_out,
    input wire obstacle_hit_uart_out,
    input wire [2:0] direction_for_enemy_uart_out,
    input wire [9:0] xpos_bullet_our_uart_out,
    input wire [9:0] ypos_bullet_our_uart_out,
    input wire [7:0] hp_our_uart_out,
    
    output wire hsync_out,
    output wire vsync_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire [10:0] hcount_out,
    output wire [9:0]  vcount_out,
    output wire [11:0] rgb_out,
    output wire select_out,
    output wire [11:0] xpos_mouse_out,
    output wire [11:0] ypos_mouse_out,
    
    output wire [9:0] xpos_tank_uart_in,
    output wire [9:0] ypos_tank_uart_in,   
    output wire [9:0] xpos_bullet_our_uart_in,
    output wire [9:0] ypos_bullet_our_uart_in,
    output wire tank_our_hit_uart_in,
    output wire obstacle_hit_uart_in,
    output wire [2:0] direction_for_enemy_uart_in,
    output wire [1:0] direction_tank_uart_in,
    output wire [7:0] hp_enemy_uart_in,
    output wire [12:0] bullet_ready,
    output wire back_to_menu 
);

//Wires
//****************************************************************************************************************//
wire [11:0] rgb_image0, rgb_image1, rgb_image2, rgb_image3, rgb_ctl, rgb_draw, rgb_gun, rgb_bul, rgb_hp, rgb_lose, rgb_win;
wire [11:0] xpos_mouse_d, ypos_mouse_d, xpos_mouse_draw, ypos_mouse_draw, xpos_mouse_gun, ypos_mouse_gun, 
xpos_mouse_bul, ypos_mouse_bul, xpos_mouse_hp, ypos_mouse_hp;
wire [10:0]  hcount_ctl, hcount_draw, hcount_gun, hcount_bul, hcount_hp;
wire [9:0]  vcount_ctl, vcount_draw, vcount_gun, vcount_bul, vcount_hp;
wire hsync_ctl, vsync_ctl, hblnk_ctl, vblnk_ctl, hblnk_draw, vblnk_draw, hsync_draw, vsync_draw,
hblnk_gun, vblnk_gun, hsync_gun, vsync_gun, hblnk_bul, vblnk_bul, hsync_bul, vsync_bul, hblnk_hp, vblnk_hp, hsync_hp, vsync_hp; 
wire select_ctl, select_draw, select_hp;
wire [1:0] direction_tank, direction_tank_draw;
wire [9:0] xpos_tank_op, ypos_tank_op, xpos_tank_drawtank, ypos_tank_drawtank;
wire [1:0] game_end; 
wire [11:0] address;
wire [13:0] address_endgame;

delay delay(
    .clk(clk),
    .xpos_mouse_in(xpos_mouse),
    .ypos_mouse_in(ypos_mouse),
    .xpos_tank_in(xpos_tank_op_in),
    .ypos_tank_in(ypos_tank_op_in),
    
    .xpos_tank_out(xpos_tank_op),
    .ypos_tank_out(ypos_tank_op),
    .xpos_mouse_out(xpos_mouse_d),
    .ypos_mouse_out(ypos_mouse_d)  
);

control control(
    .clk(clk),
    .rst(rst),
    .select_mode(select_mode),
    .hcount(hcount),
    .vcount(vcount),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hsync(hsync),
    .vsync(vsync),
    .rgb_in(rgb_in),
    .data_in_x_jstk(data_in_x_jstk),
    .data_in_y_jstk(data_in_y_jstk),
    .xpos_tank_op(xpos_tank_op),
    .ypos_tank_op(ypos_tank_op),
    
    .select_out(select_ctl),
    .hcount_out(hcount_ctl),
    .vcount_out(vcount_ctl),
    .hsync_out(hsync_ctl),
    .vsync_out(vsync_ctl),
    .hblnk_out(hblnk_ctl),
    .vblnk_out(vblnk_ctl),
    .rgb_out(rgb_ctl),
    .xpos_tank_uart_in(xpos_tank_uart_in),
    .ypos_tank_uart_in(ypos_tank_uart_in),
    .direction_tank(direction_tank)
);

draw_tank draw_tank(
    .clk(clk),
    .rst(rst),
    .select(select_ctl),
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
    .xpos_tank_uart_in(xpos_tank_uart_in),
    .ypos_tank_uart_in(ypos_tank_uart_in),
    .direction_tank(direction_tank),
    
    .hcount_out(hcount_draw),
    .hsync_out(hsync_draw),
    .hblnk_out(hblnk_draw),
    .vcount_out(vcount_draw),
    .vsync_out(vsync_draw),
    .vblnk_out(vblnk_draw),
    .select_out(select_draw),
    .rgb_out(rgb_draw),
    .pixel_addr(address),
    .xpos_tank_out(xpos_tank_drawtank),
    .ypos_tank_out(ypos_tank_drawtank),
    .direction_tank_out(direction_tank_draw)
);

choose_the_image_of_tank choose_the_image_of_tank(
    .clk(clk),
    .address(address),

    .rgb0(rgb_image0),
    .rgb1(rgb_image1),
    .rgb2(rgb_image2),
    .rgb3(rgb_image3)
);

delay_for_draw delay_for_draw(
    .clk(clk),
    .xpos_mouse_in(xpos_mouse_d),
    .ypos_mouse_in(ypos_mouse_d),
    
    .xpos_mouse_out(xpos_mouse_draw),
    .ypos_mouse_out(ypos_mouse_draw)
);

gun_ctrl gun_ctrl(
    .clk(clk),
    .rst(rst),
    .left_click(left_click),
    .select(select_draw),
    .hblnk(hblnk_draw),
    .vblnk(vblnk_draw),
    .hsync(hsync_draw),
    .vsync(vsync_draw),
    .hcount(hcount_draw),
    .vcount(vcount_draw),
    .rgb(rgb_draw),
    .xpos_mouse_in(xpos_mouse_draw),
    .ypos_mouse_in(ypos_mouse_draw),
    .xpos_tank_in(xpos_tank_drawtank),
    .ypos_tank_in(ypos_tank_drawtank),
    .xpos_tank_op(xpos_tank_op),
    .ypos_tank_op(ypos_tank_op),
    .direction_bullet(direction_tank_draw),
    .hp_our_state(hp_our_uart_out),
    
    .select_out(select_out),
    .hblnk_out(hblnk_gun),
    .vblnk_out(vblnk_gun),
    .hsync_out(hsync_gun),
    .vsync_out(vsync_gun),
    .hcount_out(hcount_gun),
    .vcount_out(vcount_gun),
    .rgb_out(rgb_gun),
    .xpos_mouse_out(xpos_mouse_gun),
    .ypos_mouse_out(ypos_mouse_gun),
    .tank_central_hit(tank_our_hit_uart_in),
    .obstacle_hit(obstacle_hit_uart_in),
    .direction_for_enemy(direction_for_enemy_uart_in),
    .xpos_bullet_green(xpos_bullet_our_uart_in),
    .ypos_bullet_green(ypos_bullet_our_uart_in),
    .hp_enemy_state(hp_enemy_uart_in),
    .bullet_ready(bullet_ready)
);

opponent_bullet opponent_bullet(
    .clk(clk),
    .rst(rst),
    .xpos_bullet_enemy(xpos_bullet_our_uart_out),
    .ypos_bullet_enemy(ypos_bullet_our_uart_out),
    .hblnk(hblnk_gun),
    .vblnk(vblnk_gun),
    .hsync(hsync_gun),
    .vsync(vsync_gun),
    .hcount(hcount_gun),
    .vcount(vcount_gun),
    .rgb(rgb_gun),
    .xpos_mouse_in(xpos_mouse_gun),
    .ypos_mouse_in(ypos_mouse_gun),
    .tank_enemy_hit_us(tank_our_hit_uart_out),
    .obstacle_hit(obstacle_hit_uart_out),
    .direction_from_enemy(direction_for_enemy_uart_out),
    
    .hblnk_out(hblnk_bul),
    .vblnk_out(vblnk_bul),
    .hsync_out(hsync_bul),
    .vsync_out(vsync_bul),
    .hcount_out(hcount_bul),
    .vcount_out(vcount_bul),
    .rgb_out(rgb_bul),
    .xpos_mouse_out(xpos_mouse_bul),
    .ypos_mouse_out(ypos_mouse_bul)
);

hp_state hp_state(
    .clk(clk),
    .rst(rst),
    .hblnk(hblnk_bul),
    .vblnk(vblnk_bul),
    .hsync(hsync_bul),
    .vsync(vsync_bul),
    .hcount(hcount_bul),
    .vcount(vcount_bul),
    .rgb(rgb_bul),
    .xpos_mouse_in(xpos_mouse_bul),
    .ypos_mouse_in(ypos_mouse_bul),
    .select(select_draw),
    .hp_enemy_state(hp_enemy_uart_in),
    .hp_our_state(hp_our_uart_out),
    
    .hblnk_out(hblnk_hp),
    .vblnk_out(vblnk_hp),
    .hsync_out(hsync_hp),
    .vsync_out(vsync_hp),
    .hcount_out(hcount_hp),
    .vcount_out(vcount_hp),
    .rgb_out(rgb_hp),
    .xpos_mouse_out(xpos_mouse_hp),
    .ypos_mouse_out(ypos_mouse_hp),
    .select_out(select_hp),
    .game_end(game_end)
);
//------------WIN OR LOSE-----------------//
end_game end_game(
    .clk(clk),
    .rst(rst),
    .select(select_hp),
    .hcount_in(hcount_hp),
    .vcount_in(vcount_hp),
    .hsync_in(hsync_hp),
    .vsync_in(vsync_hp),
    .hblnk_in(hblnk_hp),
    .vblnk_in(vblnk_hp),
    .rgb_in(rgb_hp),
    .rgb_pixel_win(rgb_win),
    .rgb_pixel_lose(rgb_lose),
    .xpos_mouse_in(xpos_mouse_hp),
    .ypos_mouse_in(ypos_mouse_hp),
    .game_end(game_end),

    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .hblnk_out(hblnk_out),
    .vblnk_out(vblnk_out),
    .rgb_out(rgb_out),
    .back_to_menu(back_to_menu),
    .xpos_mouse_out(xpos_mouse_out),
    .ypos_mouse_out(ypos_mouse_out),
    .pixel_addr(address_endgame)
);

choose_image_of_end_game choose_image_of_end_game(
    .clk(clk),
    .address(address_endgame),

    .rgb_win(rgb_win),
    .rgb_lose(rgb_lose)
);
//****************************************************************************************************************// 
 
//Output
//****************************************************************************************************************// 
assign direction_tank_uart_in = direction_tank;
endmodule
