`timescale 1ns / 1ps

module Opponent_Bullet(
    input wire clk,
    input wire rst,
    input wire [9:0] xpos_bullet_red,
    input wire [9:0] ypos_bullet_red,
    input wire tank_enemy_hit_us,
    input wire obstacle_hit,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire [11:0] rgb,
    input wire [11:0] xpos_m,
    input wire [11:0] ypos_m,
    input wire [2:0] direction_from_enemy,
        
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_m_out,
    output reg [11:0] ypos_m_out
);
 
reg [11:0] rgb_nxt;
reg [2:0] state, state_nxt;
localparam IDLE = 3'b000;
localparam GEN_SHELL_0  = 3'b001;
localparam GEN_SHELL_1  = 3'b010;
localparam GEN_SHELL_2  = 3'b011;
localparam GEN_SHELL_3  = 3'b100;

always@(posedge clk) begin
    if(rst) begin
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out, rgb_out} <= 0;
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
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
    end
end

always@* begin
    state_nxt = state;
    rgb_nxt = rgb_out;
    case(state)
    IDLE: begin
        if(direction_from_enemy == 0) begin
            state_nxt = IDLE;
            rgb_nxt = rgb;
            end
        else begin
            state_nxt = IDLE + direction_from_enemy;
            //state_nxt = IDLE;
            rgb_nxt = rgb;
            end
        end
    GEN_SHELL_0: begin
        if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if(hcount >= xpos_bullet_red - 2 && hcount <= xpos_bullet_red + 2 && vcount >= ypos_bullet_red - 5 && vcount <= ypos_bullet_red + 5) rgb_nxt=12'h000;
        else rgb_nxt = rgb;
        end
    GEN_SHELL_1: begin
        if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if(hcount >= xpos_bullet_red - 2 && hcount <= xpos_bullet_red + 2 && vcount >= ypos_bullet_red + 19 && vcount <= ypos_bullet_red + 29) rgb_nxt=12'h000;
        else rgb_nxt = rgb;
        end
    GEN_SHELL_2: begin
        if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if(hcount >= xpos_bullet_red + 19 && hcount <= xpos_bullet_red + 29 && vcount >= ypos_bullet_red - 2 && vcount <= ypos_bullet_red + 2) rgb_nxt=12'h000;
        else rgb_nxt = rgb;
        end
    GEN_SHELL_3: begin
        if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if(hcount >= xpos_bullet_red - 5 && hcount <= xpos_bullet_red + 5 && vcount >= ypos_bullet_red - 2 && vcount <= ypos_bullet_red + 2) rgb_nxt=12'h000;
        else rgb_nxt = rgb;
        end
    default: begin state_nxt =IDLE; rgb_nxt = rgb; end
    endcase
end
endmodule
