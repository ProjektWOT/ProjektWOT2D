`timescale 1 ns / 1 ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module vga_project(
    input wire spi_miso,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs,

    input wire clk,
    input wire rst,
    input wire uart_rxd,
    
    output wire uart_txd,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror,
    output wire [7:0] seg,
    output wire [3:0] an,
    
    inout wire ps2_clk,
    inout wire ps2_data
);

//Mirror PCLK; Reset_Module; Clk_Module
//****************************************************************************************************************//
wire clk_100mhz, locked, rst_extended, clk_130mhz, clk_65mhz;
wire back_to_menu;

ODDR pclk_oddr(
    .Q(pclk_mirror),
    .C(clk_65mhz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);

reset reset(
    .locked(locked && (~back_to_menu)),
    .clk(clk_65mhz),
    .reset(rst_extended)
);
clk_wiz_0 Clock(
    .clk(clk),
    .reset(rst),
    .clk100MHz(clk_100mhz),
    .clk65MHz(clk_65mhz),
    .clk130MHz(clk_130mhz),
    .locked(locked)
);
//****************************************************************************************************************//

//UART; Joystick
//****************************************************************************************************************//
wire [9:0] data_jstk_x, data_jstk_y, xpos_tank_uart_in, ypos_tank_uart_in;
wire [9:0] xpos_bullet_our_uart_out, ypos_bullet_our_uart_out, xpos_bullet_our_uart_in, ypos_bullet_our_uart_in;
wire [2:0] direction_for_enemy_uart_out, direction_for_enemy_uart_in;
wire tank_our_hit_uart_out, tank_our_hit_uart_in, obstacle_hit_uart_out, obstacle_hit_uart_in;
wire [15:0] xpos_tank_uart_out, ypos_tank_uart_out;
wire [1:0] direction_tank_uart_out, direction_tank_uart_in; 
wire [7:0] hp_enemy_uart_in, hp_our_uart_out;
wire [12:0] bullet_ready;

uart uart(
    .clk(clk_65mhz),
    .reset(rst_extended),
    .xpos_tank_uart_in(xpos_tank_uart_in),
    .ypos_tank_uart_in(ypos_tank_uart_in),
    .xpos_bullet_our_uart_in(xpos_bullet_our_uart_in),
    .ypos_bullet_our_uart_in(ypos_bullet_our_uart_in),
    .direction_for_enemy_uart_in(direction_for_enemy_uart_in),
    .tank_our_hit_uart_in(tank_our_hit_uart_in),
    .obstacle_hit_uart_in(obstacle_hit_uart_in),
    .direction_tank_uart_in(direction_tank_uart_in),
    .hp_enemy_uart_in(hp_enemy_uart_in),
    .rx(uart_rxd),
    
    .tx(uart_txd),
    .xpos_tank_uart_out(xpos_tank_uart_out),
    .ypos_tank_uart_out(ypos_tank_uart_out),
    .xpos_bullet_our_uart_out(xpos_bullet_our_uart_out),
    .ypos_bullet_our_uart_out(ypos_bullet_our_uart_out),
    .direction_for_enemy_uart_out(direction_for_enemy_uart_out),
    .tank_our_hit_uart_out(tank_our_hit_uart_out),
    .obstacle_hit_uart_out(obstacle_hit_uart_out),
    .direction_tank_uart_out(direction_tank_uart_out),
    .hp_our_uart_out(hp_our_uart_out)
);

disp_hex_mux disp_hex_mux(
    .clk(clk_65mhz),
    .reset(rst_extended),
    .hex0(bullet_ready[11:8]),
    .hex1(bullet_ready[7:4]),
    .hex2(bullet_ready[3:0]),
    .hex3(4'b0000),
    .dp_in(~{1'b0, bullet_ready[12], 2'b00}),
    
    .an(an),
    .sseg(seg)
);

pmod_joystick Joystick(
    .clk(clk_130mhz),
    .reset(rst_extended),
    .miso(spi_miso),
    
    .mosi(spi_mosi),
    .sclk(spi_sclk),
    .cs(spi_cs),
    .data_out_x(data_jstk_x),
    .data_out_y(data_jstk_y)
);
//****************************************************************************************************************//

//Wires for modules
wire [11:0] rgb_out_map, rgb_out_menu, rgb_out_base, rgb_out, rgb_tank, rgb_out_gui, rgb_tank_op;
wire [10:0] hcount_out_tim, hcount_tank, hcount_out_gui, hcount_tank_op;
wire [9:0]  vcount_out_tim, vcount_tank, vcount_out_gui, vcount_tank_op;
wire vsync_out_tim, hsync_out_tim, vsync_out, hsync_out, hsync_tank, vsync_tank, hsync_out_gui, vsync_out_gui, hsync_tank_op, vsync_tank_op;
wire vblnk_out_tim, hblnk_out_tim, hblnk_tank, vblnk_tank, hblnk_out_gui, vblnk_out_gui, hblnk_tank_op, vblnk_tank_op;
wire [11:0] xpos_mouse_65mhz, ypos_mouse_65mhz, xpos_mouse_130mhz, ypos_mouse_130mhz, xpos_out_base, ypos_out_base, xpos_tank, ypos_tank, xpos_tank_op, ypos_tank_op;
wire left_button;
wire select_mode, select_tank, select_mode_op;
//Timing
//****************************************************************************************************************//
vga_timing vga_timing(
    .clk(clk_65mhz),
    .rst(rst_extended),
    
    .vcount(vcount_out_tim),
    .vsync(vsync_out_tim),
    .vblnk(vblnk_out_tim),
    .hcount(hcount_out_tim),
    .hsync(hsync_out_tim),
    .hblnk(hblnk_out_tim)
);
//****************************************************************************************************************//

//Control
//****************************************************************************************************************//
gui gui(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .hcount_in(hcount_out_tim),
    .vcount_in(vcount_out_tim),
    .hblnk_in(hblnk_out_tim),
    .vblnk_in(vblnk_out_tim),
    .hsync_in(hsync_out_tim),
    .vsync_in(vsync_out_tim),
    
    .hcount_out(hcount_out_gui),
    .vcount_out(vcount_out_gui),
    .hblnk_out(hblnk_out_gui),
    .vblnk_out(vblnk_out_gui),
    .hsync_out(hsync_out_gui),
    .vsync_out(vsync_out_gui),
    .rgb_out_map(rgb_out_map),
    .rgb_out_menu(rgb_out_menu)
);

base_control base_control(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .xpos_mouse(xpos_mouse_65mhz),
    .ypos_mouse(ypos_mouse_65mhz),
    .left_button(left_button),
    .rgb_mapa(rgb_out_map),
    .rgb_menu(rgb_out_menu),
    
    .xpos_mouse_out(xpos_out_base),
    .ypos_mouse_out(ypos_out_base),
    .rgb(rgb_out_base),
    .select(select_mode)
);
//****************************************************************************************************************//

//Mouse
//****************************************************************************************************************//
MouseCtl MouseCtl(
    .clk(clk_130mhz),
    .rst(rst_extended),
    
    .xpos(xpos_mouse_130mhz),
    .ypos(ypos_mouse_130mhz),
    
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .value(12'b001111111111),
    .value_y(12'b001011111111),
    .setx(1'b0),
    .sety(1'b0),
    .setmax_x(1'b1),
    .setmax_y(1'b1),
    .left(left_button),
    .right(),
    .zpos(),
    .middle(),
    .new_event()
);

mouse_130to65 mouse_130to65(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .xpos_mouse_in(xpos_mouse_130mhz),
    .ypos_mouse_in(ypos_mouse_130mhz),
    
    .xpos_mouse(xpos_mouse_65mhz),
    .ypos_mouse(ypos_mouse_65mhz)
);

mouse_image cursor(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .xpos(xpos_tank),
    .ypos(ypos_tank),
    .hcount(hcount_tank),
    .vcount(vcount_tank),
    .hblnk(hblnk_tank),
    .vblnk(vblnk_tank),
    .hsync(hsync_tank),
    .vsync(vsync_tank),
    .rgb_in(rgb_tank),
    .select_mode(select_tank),
    
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .hblnk_out(),
    .vblnk_out(),
    .hcount_out(),
    .vcount_out(),
    .rgb_out(rgb_out)
);
//****************************************************************************************************************//

//TanksImages
//****************************************************************************************************************//  
tank_gen tank_gen(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .xpos_mouse(xpos_tank_op),
    .ypos_mouse(ypos_tank_op),
    .hcount(hcount_tank_op),
    .vcount(vcount_tank_op),
    .hblnk(hblnk_tank_op),
    .vblnk(vblnk_tank_op),
    .hsync(hsync_tank_op),
    .vsync(vsync_tank_op),
    .rgb_in(rgb_tank_op),
    .select_mode(select_mode_op),
    .data_in_x_jstk(data_jstk_x),
    .data_in_y_jstk(data_jstk_y),
    .xpos_tank_op_in(xpos_tank_uart_out[9:0]),
    .ypos_tank_op_in(ypos_tank_uart_out[9:0]),
    .left_click(left_button),
    .tank_our_hit_uart_out(tank_our_hit_uart_out),
    .obstacle_hit_uart_out(obstacle_hit_uart_out),
    .direction_for_enemy_uart_out(direction_for_enemy_uart_out),
    .xpos_bullet_our_uart_out(xpos_bullet_our_uart_out),
    .ypos_bullet_our_uart_out(ypos_bullet_our_uart_out),
    .hp_our_uart_out(hp_our_uart_out),
       
    .hsync_out(hsync_tank),
    .vsync_out(vsync_tank),
    .hblnk_out(hblnk_tank),
    .vblnk_out(vblnk_tank),
    .hcount_out(hcount_tank),
    .vcount_out(vcount_tank),
    .rgb_out(rgb_tank),
    .select_out(select_tank),
    .xpos_mouse_out(xpos_tank),
    .ypos_mouse_out(ypos_tank),
    .xpos_tank_uart_in(xpos_tank_uart_in),
    .ypos_tank_uart_in(ypos_tank_uart_in),
    .xpos_bullet_our_uart_in(xpos_bullet_our_uart_in),
    .ypos_bullet_our_uart_in(ypos_bullet_our_uart_in),
    .tank_our_hit_uart_in(tank_our_hit_uart_in),
    .obstacle_hit_uart_in(obstacle_hit_uart_in),
    .direction_for_enemy_uart_in(direction_for_enemy_uart_in),
    .direction_tank_uart_in(direction_tank_uart_in),
    .hp_enemy_uart_in(hp_enemy_uart_in),
    .bullet_ready(bullet_ready),
    .back_to_menu(back_to_menu)
);

tank_oponent tank_oponent(
    .clk(clk_65mhz),
    .rst(rst_extended),
    .xpos_mouse(xpos_out_base),
    .ypos_mouse(ypos_out_base),
    .hcount(hcount_out_gui),
    .vcount(vcount_out_gui),
    .hblnk(hblnk_out_gui),
    .vblnk(vblnk_out_gui),
    .hsync(hsync_out_gui),
    .vsync(vsync_out_gui),
    .rgb_in(rgb_out_base),
    .select_mode(select_mode),
    .xpos_tank_op(xpos_tank_uart_out[9:0]),
    .ypos_tank_op(ypos_tank_uart_out[9:0]),
    .direction_tank_uart_out(direction_tank_uart_out),
       
    .hsync_out(hsync_tank_op),
    .vsync_out(vsync_tank_op),
    .hblnk_out(hblnk_tank_op),
    .vblnk_out(vblnk_tank_op),
    .hcount_out(hcount_tank_op),
    .vcount_out(vcount_tank_op),
    .rgb_out(rgb_tank_op),
    .select_out(select_mode_op),
    .xpos_mouse_out(xpos_tank_op),
    .ypos_mouse_out(ypos_tank_op)
);
//****************************************************************************************************************//

//Assigns
//****************************************************************************************************************//
assign hs = hsync_out;
assign vs = vsync_out; 
assign r = rgb_out[11:8];
assign g = rgb_out[7:4];
assign b = rgb_out[3:0];

endmodule
