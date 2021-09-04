`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module draw_image_menu(
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

//Registers and Localparams
//****************************************************************************************************************//
reg [11:0] rgb_out_nxt;
reg [10:0] hcount_temp;
reg [9:0] vcount_temp;
reg hblnk_temp, vblnk_temp;

wire [9:0] addr_x;
wire [6:0] addr_y;

localparam WHITE = 12'hf_f_f;
localparam IMAGE_X_POS = 256;
localparam IMAGE_Y_POS = 320;
localparam LENGTH = 512;
localparam HEIGTH = 64;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//      
always@(posedge clk) begin
    if (rst) begin
        {hblnk_temp, vblnk_temp} <= 0;
        {hcount_temp, vcount_temp} <= 0; 
        rgb_out <= 0;
    end 
    else begin
        hcount_temp <= hcount_in;
        vcount_temp <= vcount_in;
        hblnk_temp <= hblnk_in;
        vblnk_temp <= vblnk_in;
        rgb_out <= rgb_out_nxt;
    end
end
//****************************************************************************************************************// 

//Logic
//****************************************************************************************************************//
always @* begin
    if (rgb_pixel == WHITE) rgb_out_nxt = rgb_in;
    else if ((vcount_temp>=IMAGE_Y_POS)&&(vcount_temp<IMAGE_Y_POS+HEIGTH)&&(hcount_temp>=IMAGE_X_POS)&&(hcount_temp<IMAGE_X_POS + LENGTH)&&(hblnk_temp==0)&&(vblnk_temp==0)) rgb_out_nxt = rgb_pixel;
    else rgb_out_nxt = rgb_in;
end
//****************************************************************************************************************// 
 
//Outputs
//****************************************************************************************************************//    
assign addr_y = vcount_in - IMAGE_Y_POS;
assign addr_x = hcount_in - IMAGE_X_POS;
assign pixel_addr = {addr_y[5:0], addr_x[8:0]};

endmodule