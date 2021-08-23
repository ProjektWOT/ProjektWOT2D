`timescale 1ns / 1ps

module Opponent_Bullet(
    input wire clk,
    input wire rst,
    input wire [9:0] xpos_bullet_red,
    input wire [9:0] ypos_bullet_red,
    input wire tank_enemy_hit_us,
    input wire tank_our_hit,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire [11:0] rgb,
    input wire [11:0] xpos_m,
    input wire [11:0] ypos_m,
        
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_m_out,
    output reg [11:0] ypos_m_out,
    output reg tank_enemy_hit_us_out,
    output reg tank_our_hit_out
);
 
reg [11:0] rgb_nxt;
reg state, state_nxt;
localparam IDLE = 1'b0;
localparam FLY  = 1'b1;

always@(posedge clk) begin
    if(rst) begin
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out, rgb_out} <= 0;
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
        {tank_enemy_hit_us_out, tank_our_hit_out} <= 0;
        state <= IDLE;
    end
    else begin
        state <= state_nxt;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hcount_out <= hcount;
        vcount_out <= vcount; 
        rgb_out <= rgb_nxt;
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
        tank_enemy_hit_us_out <= tank_enemy_hit_us;
        tank_our_hit_out <= tank_our_hit;         
    end
end

always@* begin
    state_nxt = state;
    rgb_nxt = rgb_out;
    case(state)
        IDLE: begin
            if(xpos_bullet_red == 0 && ypos_bullet_red == 0) begin
                state_nxt = IDLE;
                rgb_nxt = rgb;
            end
            else begin
                state_nxt = FLY;
                rgb_nxt = rgb;
            end
        end
        FLY: begin
            rgb_nxt = rgb;
        end
        default: state_nxt =IDLE;
    endcase
end
endmodule
