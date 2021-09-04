`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module base_control(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_mouse,
    input wire [11:0] ypos_mouse,
    input wire [11:0] rgb_mapa,
    input wire [11:0] rgb_menu,
    input wire left_button,
        
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out,
    output reg [11:0] rgb,
    output reg select
);

//Registers and Localparams
//****************************************************************************************************************//    
reg [11:0] rgb_nxt;
reg select_nxt;

//Machine States
reg state, state_nxt;

localparam MENU = 1'b0;
localparam MAPA = 1'b1;
//*******************************//
//BATTLE BUTTON
localparam BATTLE_BUT_UP    = 354;
localparam BATTLE_BUT_DOWN  = 379;  
localparam BATTLE_BUT_LEFT  = 452; 
localparam BATTLE_BUT_RIGHT = 581; 
//EXIT BUTTON
localparam EXIT_BUT_UP     = 10;
localparam EXIT_BUT_DOWN   = 30; 
localparam EXIT_BUT_LEFT   = 993;
localparam EXIT_BUT_RIGHT  = 1013; 
//*******************************//  

//Sequential data execute
//****************************************************************************************************************//   
always @(posedge clk) begin
    if(rst) begin
        state <= MENU;
        xpos_mouse_out <= xpos_mouse;
        ypos_mouse_out <= ypos_mouse;
        rgb <= rgb_menu;
        select <= 0;
        end
    else begin
        state <= state_nxt;
        xpos_mouse_out <= xpos_mouse;
        ypos_mouse_out <= ypos_mouse;
        rgb <= rgb_nxt;
        select <= select_nxt;
        end
    end
//****************************************************************************************************************//  

//Logic and StateMachine
//****************************************************************************************************************//
always @* begin
    case(state)
        MENU: state_nxt = select ? MAPA : MENU;
        MAPA: state_nxt = select ? MAPA : MENU;
        default: state_nxt = MENU;
    endcase 
    end
    
always @* begin
    //To avoid the inferrings
    select_nxt = select;
    rgb_nxt    = rgb;
    case(state)
        //States of Machine
        MENU: begin
            if(ypos_mouse >= BATTLE_BUT_UP && ypos_mouse <= BATTLE_BUT_DOWN && xpos_mouse >= BATTLE_BUT_LEFT && xpos_mouse <= BATTLE_BUT_RIGHT && left_button) begin
                select_nxt = 1;
                rgb_nxt <= rgb_mapa;
            end
            else begin
                select_nxt = 0;
                rgb_nxt <= rgb_menu;
            end
        end
        MAPA: begin
            if(ypos_mouse >= EXIT_BUT_UP && ypos_mouse <= BATTLE_BUT_DOWN && xpos_mouse >= EXIT_BUT_LEFT && xpos_mouse <= EXIT_BUT_RIGHT && left_button) begin 
                select_nxt = 0;
                rgb_nxt <= rgb_menu;
            end
            else begin
                select_nxt = 1;
                rgb_nxt <= rgb_mapa;
            end
        end
        default: begin
            select_nxt = 0;
            rgb_nxt <= rgb_menu;
        end
    endcase 
end
//****************************************************************************************************************//
   
endmodule
