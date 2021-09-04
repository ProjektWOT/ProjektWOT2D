`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module draw_tank_op(
    input wire clk,
    input wire rst,
    input wire select,
    input wire [10:0] hcount_in,
    input wire [9:0] vcount_in,
    input wire hsync_in,
    input wire vsync_in,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire [9:0] xpos_tank_op,
    input wire [9:0] ypos_tank_op,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_0, //PICTURE OF TANK - UP
    input wire [11:0] rgb_pixel_1, //PICTURE OF TANK - DOWN
    input wire [11:0] rgb_pixel_2, //PICTURE OF TANK - LEFT
    input wire [11:0] rgb_pixel_3, //PICTURE OF TANK - RIGHT
    input wire [1:0] direction_tank, 
     
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg select_out,
    output [11:0] pixel_addr
);

//Registers, Wires and Localparams
//****************************************************************************************************************//
   
wire [5:0] addr_x, addr_y;

reg [1:0] direction_tank_temp;
reg [11:0] rgb_temp, rgb_out_nxt;
reg [10:0] hcount_temp;
reg [9:0] vcount_temp;
reg hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, select_temp;

localparam WHITE = 12'hf_f_f;
//TANK DIMENSIONS
localparam LENGTH = 48;
localparam HEIGTH = 64;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************// 
always@(posedge clk) begin
    if (rst) begin
        {hsync_out, vsync_out, hblnk_out, vblnk_out, hcount_out, vcount_out, rgb_out} <= 0;
        {hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, hcount_temp, vcount_temp, rgb_temp} <= 0; 
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
        
        hsync_out <= hsync_temp;
        vsync_out <= vsync_temp;
        hblnk_out <= hblnk_temp;
        vblnk_out <= vblnk_temp;
        hcount_out <= hcount_temp;
        vcount_out <= vcount_temp;
        rgb_out <= rgb_out_nxt;
        select_out <= select_temp;
    end
end
//****************************************************************************************************************//

//Logic
//****************************************************************************************************************//
always@* begin
    if(direction_tank==0) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_0 == WHITE) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=ypos_tank_op && vcount_temp<(ypos_tank_op+HEIGTH) && hcount_temp>=xpos_tank_op && hcount_temp<(xpos_tank_op+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_0;
        else rgb_out_nxt = rgb_temp;
    end
    else if(direction_tank==1) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_1 == WHITE) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=ypos_tank_op && vcount_temp<(ypos_tank_op+HEIGTH) && hcount_temp>=xpos_tank_op && hcount_temp<(xpos_tank_op+LENGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_1;
        else rgb_out_nxt = rgb_temp;
    end   
    else if(direction_tank==2) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_2 == WHITE) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=ypos_tank_op && vcount_temp<(ypos_tank_op+LENGTH) && hcount_temp>=xpos_tank_op && hcount_temp<(xpos_tank_op+HEIGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_2;
        else rgb_out_nxt = rgb_temp;
    end  
    else if(direction_tank==3) begin
        if(select == 0) rgb_out_nxt = rgb_temp;
        else if (rgb_pixel_3 == WHITE) rgb_out_nxt = rgb_temp;
        else if (vcount_temp>=ypos_tank_op && vcount_temp<(ypos_tank_op+LENGTH) && hcount_temp>=xpos_tank_op && hcount_temp<(xpos_tank_op+HEIGTH) && hblnk_temp==0 && vblnk_temp==0) rgb_out_nxt = rgb_pixel_3;
        else rgb_out_nxt = rgb_temp;
    end  
    else rgb_out_nxt = rgb_temp;
end
//****************************************************************************************************************// 

//Outputs
//****************************************************************************************************************// 
assign addr_y = vcount_in - ypos_tank_op;
assign addr_x = hcount_in - xpos_tank_op;
assign pixel_addr = {addr_y[5:0], addr_x[5:0]};
endmodule
