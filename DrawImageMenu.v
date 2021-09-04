`timescale 1ns / 1ps

module DrawImageMenu(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0]  vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel,
    
    output reg [11:0] rgb_out,
    output wire [14:0] pixel_addr
    );

reg [10:0] hcount_temp;
reg [9:0] vcount_temp;
reg hblnk_temp, vblnk_temp;
reg [11:0] rgb_out_nxt;

wire [9:0] Addr_x;
wire [6:0] Addr_y;

localparam IMAGEX = 256;
localparam IMAGEY = 320;
always@(posedge clk)
if (rst) begin
    {hblnk_temp, vblnk_temp, hcount_temp, vcount_temp} <= 0; 
    rgb_out <= 0;
    end 
else begin
    hblnk_temp <= hblnk_in;
    vblnk_temp <= vblnk_in;
    hcount_temp <= hcount_in;
    vcount_temp <= vcount_in;
    rgb_out <= rgb_out_nxt;
    end

localparam LENGTH = 512;
localparam HEIGTH = 64;    

always @* begin
    if (rgb_pixel == 12'hf_f_f) rgb_out_nxt = rgb_in;
    else if (vcount_temp>=IMAGEY && vcount_temp<IMAGEY+HEIGTH && hcount_temp>=IMAGEX && hcount_temp<IMAGEX + LENGTH && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel;
    else rgb_out_nxt = rgb_in;
    end
    
    
assign Addr_y = vcount_in - IMAGEY;
assign Addr_x = hcount_in - IMAGEX;
assign pixel_addr = {Addr_y[5:0], Addr_x[8:0]};
endmodule