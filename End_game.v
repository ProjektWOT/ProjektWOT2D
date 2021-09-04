`timescale 1ns / 1ps

module End_game(
    input wire clk,
    input wire rst,
    input wire select,
    input wire [10:0] hcount_in,
    input wire [9:0] vcount_in,
    input wire hsync_in,
    input wire vsync_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_win,
    input wire [11:0] rgb_pixel_lose,
    input wire [11:0] xpos_m,
    input wire [11:0] ypos_m,
    input wire [1:0] game_end,

    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg back_to_MENU,
    output reg [11:0] xpos_m_out,
    output reg [11:0] ypos_m_out,
    output [13:0] pixel_addr
);

wire [7:0] Addr_x;
wire [5:0] Addr_y;

reg [28:0] counter_end, counter_end_nxt;
reg [11:0] rgb_temp, rgb_out_nxt;
reg [10:0] hcount_temp;
reg [9:0] vcount_temp;
reg [11:0] xpos_m_temp, ypos_m_temp;
reg hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, select_temp;
reg [1:0] game_end_temp;
reg back_to_MENU_nxt;

localparam END_TIME = 325000000;

always@ (posedge clk)
if (rst) begin
{hsync_out, vsync_out, hblnk_out, vblnk_out, hcount_out, vcount_out, rgb_out} <= 0;
{hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, hcount_temp, vcount_temp, rgb_temp} <= 0; 
game_end_temp<=0;
counter_end <= 0;
back_to_MENU <= 0;
end 
else begin
hsync_temp <= hsync_in;
vsync_temp <= vsync_in;
hblnk_temp <= hblnk_in;
vblnk_temp <= vblnk_in;
hcount_temp <= hcount_in;
vcount_temp <= vcount_in;
rgb_temp <= rgb_in;
select_temp <= select;
xpos_m_temp <= xpos_m;
ypos_m_temp <= ypos_m;
game_end_temp <= game_end;

hsync_out <= hsync_temp;
vsync_out <= vsync_temp;
hblnk_out <= hblnk_temp;
vblnk_out <= vblnk_temp;
hcount_out <= hcount_temp;
vcount_out <= vcount_temp;
rgb_out <= rgb_out_nxt;
xpos_m_out <= xpos_m_temp;
ypos_m_out <= ypos_m_temp;
counter_end <= counter_end_nxt;
back_to_MENU <= back_to_MENU_nxt;
end

localparam LENGTH = 256;
localparam HEIGTH = 64;
localparam TEXT_Y = 352;
localparam TEXT_X = 256;

always@* begin
counter_end_nxt = counter_end;

if(counter_end==END_TIME && select == 1) begin back_to_MENU_nxt = 1; counter_end_nxt=0; end
else back_to_MENU_nxt = 0;

if(game_end==1) begin
    counter_end_nxt = counter_end + 1;
    if(select == 0) rgb_out_nxt = rgb_temp;
    else if (rgb_pixel_win == 12'hf_f_f) rgb_out_nxt = rgb_temp;
    else if (vcount_temp>=TEXT_Y && vcount_temp<(TEXT_Y+HEIGTH) && hcount_temp>=TEXT_X && hcount_temp<(TEXT_X+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_win;
    else rgb_out_nxt = rgb_temp;
end
else if(game_end==2) begin
    if (counter_end==1) counter_end_nxt = 1000000; 
    else counter_end_nxt = counter_end + 1;
    if(select == 0) rgb_out_nxt = rgb_temp;
    else if (rgb_pixel_lose == 12'hf_f_f) rgb_out_nxt = rgb_temp;
    else if (vcount_temp>=TEXT_Y && vcount_temp<(TEXT_Y+HEIGTH) && hcount_temp>=TEXT_X && hcount_temp<(TEXT_X+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_lose;
    else rgb_out_nxt = rgb_temp;
end    
else rgb_out_nxt = rgb_temp;
end


assign Addr_y = vcount_in - TEXT_Y;
assign Addr_x = hcount_in - TEXT_X;
assign pixel_addr = {Addr_y[5:0], Addr_x[7:0]};
endmodule
