`timescale 1ns / 1ps

module BaseControl(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire ButtonLeft,
    input wire [11:0] rgbMapa,
    input wire [11:0] rgbMenu,
    
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out,
    output reg [11:0] rgb,
    output reg Select
    );
    
reg [11:0] rgb_nxt;
reg Select_nxt;

//***********
//Maszyna Stanvo;
reg State, State_nxt;
localparam MENU = 1'b0;
localparam MAPA = 1'b1;
//***********
    
always @(posedge clk) begin
    if(rst) begin
        State <= MENU;
        xpos_out <= xpos;
        ypos_out <= ypos;
        rgb <= rgbMenu;
        Select <= 0;
        end
    else begin
        State <= State_nxt;
        xpos_out <= xpos;
        ypos_out <= ypos;
        rgb <= rgb_nxt;
        Select <= Select_nxt;
        end
    end

always @* begin
    case(State)
        MENU: State_nxt = Select ? MAPA : MENU;
        MAPA: State_nxt = Select ? MAPA : MENU;
        default: State_nxt = MENU;
    endcase 
    end
    
always @* begin
    case(State)
    MENU: begin
        if(ypos >= 354 && ypos <= 379 && xpos >= 452 && xpos <= 581 && ButtonLeft == 1) begin
            Select_nxt = 1;
            rgb_nxt <= rgbMapa;
            end
        else begin
            Select_nxt = 0;
            rgb_nxt <= rgbMenu;
            end
        end
    MAPA: begin
        if(ypos >= 10 && ypos <= 30 && xpos >= 993 && xpos <= 1013 && ButtonLeft == 1 ) begin 
            Select_nxt = 0;
            rgb_nxt <= rgbMenu;
            end
        else begin
            Select_nxt = 1;
            rgb_nxt <= rgbMapa;
            end
        end
    default: begin
        Select_nxt = 0;
        rgb_nxt <= rgbMenu;
        end
    endcase 
    end
    
endmodule
