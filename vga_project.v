`timescale 1 ns / 1 ps

module vga_example(
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
wire clk_100MHz, clk_40MHz, Locked, RstExt;
ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_40MHz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);
Reset Reset(
    .locked(Locked),
    .clk(clk_40MHz),
    .reset(RstExt)
);
clk_wiz_0 Clock(
    .clk(clk),
    .reset(rst),
    .clk100MHz(),
    .clk65MHz(clk_40MHz),
    .clk130MHz(clk_100MHz),
    .locked(Locked)
);
//***********************************************//

wire [11:0] rgb_out_map, rgb_out_menu, rgb_out_Base, rgb_OUT;
wire [10:0] hcount_out_tim, hcount_out_Base;
wire [9:0]  vcount_out_tim, vcount_out_Base;
wire vsync_out_tim, hsync_out_tim, vsync_out_Base, hsync_out_Base, vsync_OUT, hsync_OUT;
wire vblnk_out_tim, hblnk_out_tim, vblnk_out_Base, hblnk_out_Base;

wire [11:0] posX_40Mhz, posY_40Mhz, Out_posX_100MHz, Out_posY_100MHz, xpos_out_Base, ypos_out_Base;
wire ButtonLeft, SelectMode;

vga_timing Timing (
    .clk(clk_40MHz),
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
    .clk(clk_40MHz),
    .rst(RstExt),

    .rgb_out(rgb_out_map)
    );
DrawMenu Menu(
    .hcount_in(hcount_out_tim),
    .vcount_in(vcount_out_tim),
    .hblnk_in(hblnk_out_tim),
    .vblnk_in(vblnk_out_tim),
    .clk(clk_40MHz),
    .rst(RstExt),
    
    .rgb_out(rgb_out_menu)
    );

BaseControl BaseControl(
    .clk(clk_40MHz),
    .rst(RstExt),
    .xpos(posX_40Mhz),
    .ypos(posY_40Mhz),
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
    .clk(clk_100MHz),
    .rst(RstExt),
    
    .xpos(Out_posX_100MHz),
    .ypos(Out_posY_100MHz),
    
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .value(12'b001100011111),
    .value_y(12'b001001010111),
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
Mouse_100To40 Mouse_100To40(
    .clk(clk_40MHz),
    .rst(RstExt),
    .B_posX(Out_posX_100MHz),
    .B_posY(Out_posY_100MHz),
    
    .posX(posX_40Mhz),
    .posY(posY_40Mhz)
    );
MouseImage Cursor(
    .clk(clk_40MHz),
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
    
    .hsync_out(hsync_OUT),
    .vsync_out(vsync_OUT),
    .hblnk_out(),
    .vblnk_out(),
    .hcount_out(),
    .vcount_out(),
    .rgb_out(rgb_OUT)
    );
//***********************************************//

//Assigns
assign hs = hsync_OUT;
assign vs = vsync_OUT; 
assign r = rgb_OUT[11:8];
assign g = rgb_OUT[7:4];
assign b = rgb_OUT[3:0];
endmodule
