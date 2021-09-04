`timescale 1ns / 1ps

module GUI(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0] vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire hsync_in,
    input wire vsync_in,
    
    output wire [10:0] hcount_out,
    output wire [9:0] vcount_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire hsync_out,
    output wire vsync_out,
    output wire [11:0] rgb_out_map,
    output wire [11:0] rgb_out_menu
);

wire [11:0] rgb_pixel_menu, rgb_out_draw_menu;
wire [14:0] pixel_addr;

Delay_gui Delay_gui(
    .clk(clk),
    .rst(rst),
    .hcount_in(hcount_in),
    .vcount_in(vcount_in),
    .hblnk_in(hblnk_in),
    .vblnk_in(vblnk_in),
    .hsync_in(hsync_in),
    .vsync_in(vsync_in),
    
    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .hblnk_out(hblnk_out),
    .vblnk_out(vblnk_out),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out)
);

Draw_Map Mapa(
    .hcount_in(hcount_in),
    .vcount_in(vcount_in),
    .hblnk_in(hblnk_in),
    .vblnk_in(vblnk_in),
    .clk(clk),
    .rst(rst),

    .rgb_out(rgb_out_map)
    );
DrawMenu Menu(
    .hcount_in(hcount_in),
    .vcount_in(vcount_in),
    .hblnk_in(hblnk_in),
    .vblnk_in(vblnk_in),
    .clk(clk),
    .rst(rst),
    
    .rgb_out(rgb_out_draw_menu)
    );
 
DrawImageMenu DrawImageMenu(
    .clk(clk),
    .rst(rst),
    .hcount_in(hcount_in),
    .vcount_in(vcount_in),
    .hblnk_in(hblnk_in),
    .vblnk_in(vblnk_in),
    .rgb_in(rgb_out_draw_menu),
    .rgb_pixel(rgb_pixel_menu),
    
    .rgb_out(rgb_out_menu),
    .pixel_addr(pixel_addr)
);
ImageMenu ImageMenu(
    .clk(clk),
    .address(pixel_addr),
    
    .rgb_menu(rgb_pixel_menu)
    );
endmodule
