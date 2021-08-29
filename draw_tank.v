`timescale 1ns / 1ps

module draw_tank(
    input wire clk,
    input wire rst,
    input wire select,
    input wire [10:0] hcount_in,
    input wire [9:0] vcount_in,
    input wire hsync_in,
    input wire vsync_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire [9:0] posX,
    input wire [9:0] posY,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_0,
    input wire [11:0] rgb_pixel_1,
    input wire [11:0] rgb_pixel_2,
    input wire [11:0] rgb_pixel_3,
    input wire [1:0] direction_bullet,
    
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg select_out,
    output reg [9:0] posX_out_tank,
    output reg [9:0] posY_out_tank,
    output reg [1:0] direction_bullet_out,
    output [11:0] pixel_addr
    );
    
wire [5:0] Addr_x, Addr_y;

reg [1:0] direction_bullet_temp;
reg [11:0] rgb_temp, rgb_out_nxt;
reg [10:0] hcount_temp;
reg [9:0] vcount_temp, posX_temp, posY_temp;
reg hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, select_temp;

always@ (posedge clk)
if (rst) begin
    {hsync_out, vsync_out, hblnk_out, vblnk_out, hcount_out, vcount_out, rgb_out} <= 0;
    {hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, hcount_temp, vcount_temp, rgb_temp} <= 0; 
    direction_bullet_temp<=0;
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
    posX_temp <= posX;
    posY_temp <= posY;
    direction_bullet_temp <= direction_bullet;
    
    hsync_out <= hsync_temp;
    vsync_out <= vsync_temp;
    hblnk_out <= hblnk_temp;
    vblnk_out <= vblnk_temp;
    hcount_out <= hcount_temp;
    vcount_out <= vcount_temp;
    rgb_out <= rgb_out_nxt;
    select_out <= select_temp;
    posX_out_tank <= posX_temp;
    posY_out_tank <= posY_temp;
    direction_bullet_out <= direction_bullet_temp;
end

localparam LENGTH = 48;
localparam HEIGTH = 64;

always@* begin
    if(direction_bullet==0) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_0 == 12'hf_f_f) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=posY && vcount_temp<(posY+HEIGTH) && hcount_temp>=posX && hcount_temp<(posX+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_0;
        else rgb_out_nxt = rgb_temp;
    end
    else if(direction_bullet==1) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_1 == 12'hf_f_f) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=posY && vcount_temp<(posY+HEIGTH) && hcount_temp>=posX && hcount_temp<(posX+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_1;
        else rgb_out_nxt = rgb_temp;
    end   
    else if(direction_bullet==2) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_2 == 12'hf_f_f) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=posY && vcount_temp<(posY+LENGTH) && hcount_temp>=posX && hcount_temp<(posX+HEIGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_2;
        else rgb_out_nxt = rgb_temp;
    end  
    else if(direction_bullet==3) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_3 == 12'hf_f_f) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=posY && vcount_temp<(posY+LENGTH) && hcount_temp>=posX && hcount_temp<(posX+HEIGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_3;
        else rgb_out_nxt = rgb_temp;
    end  
    else rgb_out_nxt = rgb_temp;
end


assign Addr_y = vcount_in - posY;
assign Addr_x = hcount_in - posX;
assign pixel_addr = {Addr_y[5:0], Addr_x[5:0]};
endmodule
