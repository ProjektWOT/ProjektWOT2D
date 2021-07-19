`timescale 1 ns / 1 ps

module vga_project(
    input wire MISO,
    output wire SCLK,
    output wire MOSI,
    output wire CS,

    input wire clk,
    input wire rst,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror,
    
    inout wire ps2_clk,
    inout wire ps2_data
);

//Mirror PCLK; Reset_Module; Clk_Module
//***********************************************//
wire clk_100MHz, Locked, RstExt, clk_130MHz, clk_65MHz;
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
    .locked(Locked),
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
//***********************************************//

wire [11:0] rgb_out_map, rgb_out_menu, rgb_out_Base, rgb_OUT, rgb_tank;
wire [10:0] hcount_out_tim, hcount_out_Base, hcount_tank;
wire [9:0]  vcount_out_tim, vcount_out_Base, vcount_tank;
wire vsync_out_tim, hsync_out_tim, vsync_out_Base, hsync_out_Base, vsync_OUT, hsync_OUT, hsync_tank, vsync_tank;
wire vblnk_out_tim, hblnk_out_tim, vblnk_out_Base, hblnk_out_Base, hblnk_tank, vblnk_tank;

wire [11:0] posX_65Mhz, posY_65Mhz, Out_posX_130MHz, Out_posY_130MHz, xpos_out_Base, ypos_out_Base, xpos_tank, ypos_tank;
wire ButtonLeft, SelectMode, SelectTank;

wire [9:0] Data_Jstk_X, Data_Jstk_Y;
wire [7:0] data_MISO;

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

Draw_Map Mapa(
    .hcount_in(hcount_out_tim),
    .vcount_in(vcount_out_tim),
    .hblnk_in(hblnk_out_tim),
    .vblnk_in(vblnk_out_tim),
    .clk(clk_65MHz),
    .rst(RstExt),

    .rgb_out(rgb_out_map)
    );
DrawMenu Menu(
    .hcount_in(hcount_out_tim),
    .vcount_in(vcount_out_tim),
    .hblnk_in(hblnk_out_tim),
    .vblnk_in(vblnk_out_tim),
    .clk(clk_65MHz),
    .rst(RstExt),
    
    .rgb_out(rgb_out_menu)
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

//***********************************************//
//Mouse

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
    
Tank_Gen Tank_Gen(
    .clk(clk_65MHz),
    .rst(RstExt),
    .xpos(xpos_out_Base),
    .ypos(ypos_out_Base),
    .hcount(hcount_out_tim),
    .vcount(vcount_out_tim),
    .hblnk(hblnk_out_tim),
    .vblnk(vblnk_out_tim),
    .hsync(hsync_out_tim),
    .vsync(vsync_out_tim),
    .rgb_in(rgb_out_Base),
    .SelectMode(SelectMode),
    .Data_in_X(Data_Jstk_X),
    .Data_in_Y(Data_Jstk_Y),
       
    .hsync_out(hsync_tank),
    .vsync_out(vsync_tank),
    .hblnk_out(hblnk_tank),
    .vblnk_out(vblnk_tank),
    .hcount_out(hcount_tank),
    .vcount_out(vcount_tank),
    .rgb_out(rgb_tank),
    .Select_out(SelectTank),
    .xpos_out(xpos_tank),
    .ypos_out(ypos_tank)
    );
//***********************************************//

//Assigns
assign hs = hsync_OUT;
assign vs = vsync_OUT; 
assign r = rgb_OUT[11:8];
assign g = rgb_OUT[7:4];
assign b = rgb_OUT[3:0];
endmodule
