`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module hp_state(
    input wire clk,
    input wire rst,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire [11:0] rgb,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
    input wire select,
    input wire [7:0] hp_enemy_state,
    input wire [7:0] hp_our_state,
    
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out,
    output reg select_out,
    output reg [1:0] game_end 
);

//Registers and Localparams
//****************************************************************************************************************//
reg [11:0] rgb_nxt;
reg [1:0] game_end_nxt;

localparam GREEN_HP = 12'h3_A_0;
localparam RED_HP = 12'hF_2_0;
localparam HP_POSITION = 810;
localparam HP_OUR_WIDTH1 = 40;
localparam HP_OUR_WIDTH2 = 55;
localparam HP_ENEMY_WIDTH1 = 70;
localparam HP_ENEMY_WIDTH2 = 85;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************// 
always@(posedge clk) begin
    if(rst) begin
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        hcount_out <= 0;
        vcount_out <= 0;
        rgb_out <= 0;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
        select_out <= 0;
        game_end <= 0;
    end
    else begin
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hcount_out <= hcount;
        vcount_out <= vcount; 
        rgb_out <= rgb_nxt;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
        select_out <= select;
        game_end <= game_end_nxt;
    end
end
//****************************************************************************************************************// 

//Logic
//****************************************************************************************************************//
always@* begin
    if(select==1) begin    
        if(hcount >= HP_POSITION && hcount <= HP_POSITION + hp_our_state && vcount >= HP_OUR_WIDTH1 && vcount <= HP_OUR_WIDTH2) rgb_nxt = GREEN_HP;
        else if(hcount >= HP_POSITION && hcount <= HP_POSITION + hp_enemy_state && vcount >= HP_ENEMY_WIDTH1 && vcount <= HP_ENEMY_WIDTH2) rgb_nxt = RED_HP;
        else rgb_nxt = rgb;
    end
    else rgb_nxt = rgb; 
    
    if(hp_our_state==0 && hp_enemy_state != 0) game_end_nxt=2;
    else if(hp_enemy_state==0 && hp_our_state!=0) game_end_nxt=1;
    else game_end_nxt=0;
end
endmodule