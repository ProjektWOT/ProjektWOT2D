`timescale 1 ns / 1 ps

module vga_project(
    input wire MISO,
    output wire SCLK,
    output wire MOSI,
    output wire CS,

    input wire clk,
    input wire rst,
    input wire UART_RXD,
    
    output wire UART_TXD,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror,
    output wire [7:0] SEG,
    output wire [3:0] AN,
    
    inout wire ps2_clk,
    inout wire ps2_data
);

//Mirror PCLK; Reset_Module; Clk_Module
//****************************************************************************************************************//
wire clk_100MHz, Locked, RstExt, clk_130MHz, clk_65MHz;
wire back_to_MENU, SelectMode;
ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_65MHz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);
Reset Reset(
    .locked(Locked && (~back_to_MENU)),
    .clk(clk_65MHz),
    .reset(RstExt)
);
clk_wiz_0 Clock(
    .clk(clk),
    .reset(rst),
    .clk100MHz(clk_100MHz),
    .clk65MHz(clk_65MHz),
    .clk130MHz(clk_130MHz),
    .locked(Locked)
);
//****************************************************************************************************************//

//UART; Joystick
//****************************************************************************************************************//
wire [9:0] Data_Jstk_X, Data_Jstk_Y, xpos_tank_uart_out, ypos_tank_uart_out;
wire [9:0] xpos_bullet_green_fromUART, ypos_bullet_green_fromUART, xpos_bullet_green_toUART, ypos_bullet_green_toUART;
wire [2:0] direction_for_enemy_fromUART, direction_for_enemy_toUART;
wire tank_our_hit_fromUART, tank_our_hit_toUART, obstacle_hit_fromUART, obstacle_hit_toUART;
wire [15:0] XPosTankUart, YPosTankUart;
wire [1:0] direction_tank_fromUART, direction_tank_to_UART; 
wire [7:0] HP_enemy_state_toUART, HP_our_state_fromUART;
wire [3:0] Seconds;
uart Uart(
    .clk(clk_65MHz),
    .reset(RstExt),
    .XPosInTank(xpos_tank_uart_out),
    .YPosInTank(ypos_tank_uart_out),
    .xpos_bullet_green_toUART(xpos_bullet_green_toUART),
    .ypos_bullet_green_toUART(ypos_bullet_green_toUART),
    .direction_for_enemy_toUART(direction_for_enemy_toUART),
    .tank_our_hit_toUART(tank_our_hit_toUART),
    .obstacle_hit_toUART(obstacle_hit_toUART),
    .direction_tank_to_UART(direction_tank_to_UART),
    .HP_enemy_state_toUART(HP_enemy_state_toUART),
    .rx(UART_RXD),
    
    .tx(UART_TXD),
    .X_tank_pos(XPosTankUart),
    .Y_tank_pos(YPosTankUart),
    .xpos_bullet_green_fromUART(xpos_bullet_green_fromUART),
    .ypos_bullet_green_fromUART(ypos_bullet_green_fromUART),
    .direction_for_enemy_fromUART(direction_for_enemy_fromUART),
    .tank_our_hit_fromUART(tank_our_hit_fromUART),
    .obstacle_hit_fromUART(obstacle_hit_fromUART),
    .direction_tank_fromUART(direction_tank_fromUART),
    .HP_our_state_fromUART(HP_our_state_fromUART)
    );
disp_hex_mux DisplayHexMux(
    .clk(clk_65MHz),
    .reset(RstExt),             //Dla nadajnika
    .hex0(Seconds[3:0]),   //Data_Jstk_X[3:0]
    .hex1({3'b000, back_to_MENU}),   //Data_Jstk_X[7:4]
    .hex2({3'b000, SelectMode}),  //{2'b0000,Data_Jstk_X[9:8]}
    .hex3(HP_enemy_state_toUART[7:4]), //4'b0000
    .dp_in(~4'b0000),
    
    .an(AN),
    .sseg(SEG)
    );
PMOD_JOYSTICK Joystick(
    .clk(clk_130MHz),
    .reset(RstExt),
    .MISO(MISO),
    
    .MOSI(MOSI),
    .SCLK(SCLK),
    .CS(CS),
    .Data_out_X(Data_Jstk_X),
    .Data_out_Y(Data_Jstk_Y)
    );
//****************************************************************************************************************//

wire [11:0] rgb_out_map, rgb_out_menu, rgb_out_Base, rgb_OUT, rgb_tank, rgb_out_gui, rgb_tank_op;
wire [10:0] hcount_out_tim, hcount_out_Base, hcount_tank, hcount_out_gui, hcount_tank_op;
wire [9:0]  vcount_out_tim, vcount_out_Base, vcount_tank, vcount_out_gui, vcount_tank_op;
wire vsync_out_tim, hsync_out_tim, vsync_out_Base, hsync_out_Base, vsync_OUT, hsync_OUT, hsync_tank, vsync_tank, hsync_out_gui, vsync_out_gui, hsync_tank_op, vsync_tank_op;
wire vblnk_out_tim, hblnk_out_tim, vblnk_out_Base, hblnk_out_Base, hblnk_tank, vblnk_tank, hblnk_out_gui, vblnk_out_gui, hblnk_tank_op, vblnk_tank_op;
wire [11:0] posX_65Mhz, posY_65Mhz, Out_posX_130MHz, Out_posY_130MHz, xpos_out_Base, ypos_out_Base, xpos_tank, ypos_tank, xpos_tank_op, ypos_tank_op;
wire ButtonLeft, SelectTank, SelectMode_op;
//Timing
//****************************************************************************************************************//
vga_timing Timing (
    .clk(clk_65MHz),
    .rst(RstExt),
    
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
GUI GUI(
    .clk(clk_65MHz),
    .rst(RstExt),
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
BaseControl BaseControl(
    .clk(clk_65MHz),
    .rst(RstExt),
    .xpos(posX_65Mhz),
    .ypos(posY_65Mhz),
    .ButtonLeft(ButtonLeft),
    .rgbMapa(rgb_out_map),
    .rgbMenu(rgb_out_menu),
    
    .xpos_out(xpos_out_Base),
    .ypos_out(ypos_out_Base),
    .rgb(rgb_out_Base),
    .Select(SelectMode)
    );
//****************************************************************************************************************//

//Mouse
//****************************************************************************************************************//
MouseCtl MyMouse(
    .clk(clk_130MHz),
    .rst(RstExt),
    
    .xpos(Out_posX_130MHz),
    .ypos(Out_posY_130MHz),
    
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .value(12'b001111111111),
    .value_y(12'b001011111111),
    .setx(1'b0),
    .sety(1'b0),
    .setmax_x(1'b1),
    .setmax_y(1'b1),
    .left(ButtonLeft),
    .right(),
    .zpos(),
    .middle(),
    .new_event()
    );
Mouse_130To65 Mouse_130To65(
    .clk(clk_65MHz),
    .rst(RstExt),
    .B_posX(Out_posX_130MHz),
    .B_posY(Out_posY_130MHz),
    
    .posX(posX_65Mhz),
    .posY(posY_65Mhz)
    );
MouseImage Cursor(
    .clk(clk_65MHz),
    .rst(RstExt),
    .xpos(xpos_tank),
    .ypos(ypos_tank),
    .hcount(hcount_tank),
    .vcount(vcount_tank),
    .hblnk(hblnk_tank),
    .vblnk(vblnk_tank),
    .hsync(hsync_tank),
    .vsync(vsync_tank),
    .rgb_in(rgb_tank),
    .SelectMode(SelectTank),
    
    .hsync_out(hsync_OUT),
    .vsync_out(vsync_OUT),
    .hblnk_out(),
    .vblnk_out(),
    .hcount_out(),
    .vcount_out(),
    .rgb_out(rgb_OUT)
    );
//****************************************************************************************************************//

//TanksImages
//****************************************************************************************************************//  
Tank_Gen Tank_Gen(
    .clk(clk_65MHz),
    .rst(RstExt),
    .xpos(xpos_tank_op),
    .ypos(ypos_tank_op),
    .hcount(hcount_tank_op),
    .vcount(vcount_tank_op),
    .hblnk(hblnk_tank_op),
    .vblnk(vblnk_tank_op),
    .hsync(hsync_tank_op),
    .vsync(vsync_tank_op),
    .rgb_in(rgb_tank_op),
    .SelectMode(SelectMode_op),
    .Data_in_X(Data_Jstk_X),
    .Data_in_Y(Data_Jstk_Y),
    .Data_X_op(XPosTankUart[9:0]),
    .Data_Y_op(YPosTankUart[9:0]),
    .left_click(ButtonLeft),
    .tank_our_hit_fromUART(tank_our_hit_fromUART),
    .obstacle_hit_fromUART(obstacle_hit_fromUART),
    .direction_for_enemy_fromUART(direction_for_enemy_fromUART),
    .xpos_bullet_green_fromUART(xpos_bullet_green_fromUART),
    .ypos_bullet_green_fromUART(ypos_bullet_green_fromUART),
    .HP_our_state_fromUART(HP_our_state_fromUART),
       
    .hsync_out(hsync_tank),
    .vsync_out(vsync_tank),
    .hblnk_out(hblnk_tank),
    .vblnk_out(vblnk_tank),
    .hcount_out(hcount_tank),
    .vcount_out(vcount_tank),
    .rgb_out(rgb_tank),
    .Select_out(SelectTank),
    .xpos_out(xpos_tank),
    .ypos_out(ypos_tank),
    .xpos_UART(xpos_tank_uart_out),
    .ypos_UART(ypos_tank_uart_out),
    .xpos_bullet_green_toUART(xpos_bullet_green_toUART),
    .ypos_bullet_green_toUART(ypos_bullet_green_toUART),
    .tank_our_hit_toUART(tank_our_hit_toUART),
    .obstacle_hit_toUART(obstacle_hit_toUART),
    .direction_for_enemy_toUART(direction_for_enemy_toUART),
    .direction_tank_to_UART(direction_tank_to_UART),
    .HP_enemy_state_toUART(HP_enemy_state_toUART),
    .Seconds(Seconds),
    .back_to_MENU(back_to_MENU)
    );
Tank_Oponent Tank_Oponent(
    .clk(clk_65MHz),
    .rst(RstExt),
    .xpos(xpos_out_Base),
    .ypos(ypos_out_Base),
    .hcount(hcount_out_gui),
    .vcount(vcount_out_gui),
    .hblnk(hblnk_out_gui),
    .vblnk(vblnk_out_gui),
    .hsync(hsync_out_gui),
    .vsync(vsync_out_gui),
    .rgb_in(rgb_out_Base),
    .SelectMode(SelectMode),
    .Data_in_X(XPosTankUart[9:0]), //Uart_XPosTank
    .Data_in_Y(YPosTankUart[9:0]), //Uart_YPosTank
    .direction_tank_fromUART(direction_tank_fromUART),
       
    .hsync_out(hsync_tank_op),
    .vsync_out(vsync_tank_op),
    .hblnk_out(hblnk_tank_op),
    .vblnk_out(vblnk_tank_op),
    .hcount_out(hcount_tank_op),
    .vcount_out(vcount_tank_op),
    .rgb_out(rgb_tank_op),
    .Select_out(SelectMode_op),
    .xpos_out(xpos_tank_op),
    .ypos_out(ypos_tank_op)
    );
//****************************************************************************************************************//

//Assigns
//****************************************************************************************************************//
assign hs = hsync_OUT;
assign vs = vsync_OUT; 
assign r = rgb_OUT[11:8];
assign g = rgb_OUT[7:4];
assign b = rgb_OUT[3:0];
endmodule
