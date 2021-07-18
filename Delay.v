`timescale 1ns / 1ps

module Delay(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out  
    );
    
    reg [10:0] hcount_temp1, hcount_temp2;
    reg [9:0] vcount_temp1, vcount_temp2;
    reg vsync_temp1, vsync_temp2, hsync_temp1, hsync_temp2;
    reg vblnk_temp1, vblnk_temp2, hblnk_temp1, hblnk_temp2;
    
    always@(posedge clk)
        if(rst) begin
            hsync_temp1 <= 0;
            vsync_temp1 <= 0;
            hblnk_temp1 <= 0;
            vblnk_temp1 <= 0;
            hcount_temp1 <= 0;
            vcount_temp1 <= 0;
            hsync_temp2 <= 0;
            vsync_temp2 <= 0;
            hblnk_temp2 <= 0;
            vblnk_temp2 <= 0;
            hcount_temp2 <= 0;
            vcount_temp2 <= 0;
                    
            hsync_out <= 0;
            vsync_out <= 0;
            hblnk_out <= 0;
            vblnk_out <= 0;
            hcount_out <= 0;
            vcount_out <= 0;
            xpos_out <= xpos;
            ypos_out <= ypos;
        end
        else begin
            hsync_temp1 <= hsync;
            vsync_temp1 <= vsync;
            hblnk_temp1 <= hblnk;
            vblnk_temp1 <= vblnk;
            hcount_temp1 <= hcount;
            vcount_temp1 <= vcount;
            hsync_temp2 <= hsync_temp1;
            vsync_temp2 <= vsync_temp1;
            hblnk_temp2 <= hblnk_temp1;
            vblnk_temp2 <= vblnk_temp1;
            hcount_temp2 <= hcount_temp1;
            vcount_temp2 <= vcount_temp1;
                    
            hsync_out <= hsync_temp2;
            vsync_out <= vsync_temp2;
            hblnk_out <= hblnk_temp2;
            vblnk_out <= vblnk_temp2;
            hcount_out <= hcount_temp2;
            vcount_out <= vcount_temp2;
            xpos_out <= xpos;
            ypos_out <= ypos;
        end
endmodule
