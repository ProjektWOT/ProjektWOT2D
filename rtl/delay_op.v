`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module delay_op(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
    
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out  
);  

//Sequential data execute
//****************************************************************************************************************//     
always@(posedge clk)
    if(rst) begin
        {hcount_out, vcount_out} <= 0;
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
    end
    else begin
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hcount_out <= hcount;
        vcount_out <= vcount;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
    end
endmodule
