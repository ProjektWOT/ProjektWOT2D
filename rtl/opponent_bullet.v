`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module opponent_bullet(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [9:0] xpos_bullet_enemy,
    input wire [9:0] ypos_bullet_enemy,
    input wire tank_enemy_hit_us,
    input wire obstacle_hit,
    input wire [11:0] rgb,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
    input wire [2:0] direction_from_enemy,
   
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,     
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out
);

//Registers and Localparams
//****************************************************************************************************************//
reg [11:0] rgb_nxt;
reg [2:0] state, state_nxt;

localparam BLACK = 12'h0_0_0;

localparam BUL_WIDTH  = 2;
localparam BUL_LENGTH = 5;
localparam BUL_DIM1   = 19;
localparam BUL_DIM2   = 29;
//STATES
localparam IDLE = 3'b000;
localparam GEN_SHELL_0  = 3'b001;
localparam GEN_SHELL_1  = 3'b010;
localparam GEN_SHELL_2  = 3'b011;
localparam GEN_SHELL_3  = 3'b100;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//  
always@(posedge clk) begin
    if(rst) begin
        {hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out} <= 0;
        rgb_out <= 0;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
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
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;     
    end
end
//****************************************************************************************************************// 

//Logic and StateMachine
//****************************************************************************************************************//
always@* begin
    //To avoid the inferrings
    state_nxt = state;
    rgb_nxt = rgb_out;
    //States of Machine
    case(state)
        IDLE: begin
            if(direction_from_enemy == 0) begin
                state_nxt = IDLE;
                rgb_nxt = rgb;
            end
            else begin
                state_nxt = IDLE + direction_from_enemy;
                rgb_nxt = rgb;
            end
        end
        GEN_SHELL_0: begin
            if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_bullet_enemy-BUL_WIDTH))&&(hcount <= (xpos_bullet_enemy+BUL_WIDTH))&&(vcount >= (ypos_bullet_enemy-BUL_LENGTH))&&(vcount <= (ypos_bullet_enemy+BUL_LENGTH))) rgb_nxt=BLACK;
            else rgb_nxt = rgb;
        end
        GEN_SHELL_1: begin
            if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_bullet_enemy-BUL_WIDTH))&&(hcount <= (xpos_bullet_enemy+BUL_WIDTH))&&(vcount >= (ypos_bullet_enemy+BUL_DIM1))&&(vcount <= (ypos_bullet_enemy+BUL_DIM2))) rgb_nxt=BLACK;
            else rgb_nxt = rgb;
        end
        GEN_SHELL_2: begin
            if((tank_enemy_hit_us ==1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_bullet_enemy+BUL_DIM1))&&(hcount <= (xpos_bullet_enemy+BUL_DIM2))&&(vcount >= (ypos_bullet_enemy-BUL_WIDTH))&&(vcount <= (ypos_bullet_enemy+BUL_WIDTH))) rgb_nxt=BLACK;
            else rgb_nxt = rgb;
        end
        GEN_SHELL_3: begin
            if((tank_enemy_hit_us == 1)||(direction_from_enemy == 0)||(obstacle_hit == 1)) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_bullet_enemy-BUL_LENGTH))&&(hcount <= (xpos_bullet_enemy+BUL_LENGTH))&&(vcount >= (ypos_bullet_enemy-BUL_WIDTH))&&(vcount <= (ypos_bullet_enemy+BUL_WIDTH))) rgb_nxt=BLACK;
            else rgb_nxt = rgb;
        end
        default: begin 
            state_nxt =IDLE; 
            rgb_nxt = rgb; 
        end
    endcase
end
endmodule
