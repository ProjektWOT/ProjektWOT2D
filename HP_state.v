`timescale 1ns / 1ps

module HP_state(
    input wire clk,
    input wire rst,
    input wire [7:0] HP_enemy_state,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire [11:0] rgb,
    input wire [11:0] xpos_m,
    input wire [11:0] ypos_m,
    input wire select,
    input wire [7:0] HP_our_state,
    
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_m_out,
    output reg [11:0] ypos_m_out,
    output reg select_out,
    output reg [1:0] game_end 
);

reg [11:0] rgb_nxt;
reg [1:0] game_end_nxt;
always@(posedge clk) begin
    if(rst) begin
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out, rgb_out} <= 0;
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
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
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
        select_out <= select;
        game_end <= game_end_nxt;
    end
end

always@* begin
    if(select==1) begin    
        if(hcount >= 810 && hcount <= 810 + HP_our_state && vcount >= 40 && vcount <= 55 ) rgb_nxt=12'h3A0;
        else if(hcount >= 810 && hcount <= 810 + HP_enemy_state && vcount >= 70 && vcount <= 85) rgb_nxt=12'hF20;
        else rgb_nxt = rgb;
    end
    else rgb_nxt = rgb; 
    
    if(HP_our_state==0) game_end_nxt=2;
    else if(HP_enemy_state==0) game_end_nxt=1;
    else game_end_nxt=0;
end
endmodule
