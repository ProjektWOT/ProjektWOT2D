`timescale 1ns / 1ps

module Control(
    input wire clk,
    input wire rst,
    input wire SelectMode,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [11:0] rgb_in,
    input wire [9:0] Data_in_X,
    input wire [9:0] Data_in_Y,
    
    output reg Select_out,
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out   
    );
    
localparam X_POS_0 = 200,
           Y_POS_0 = 200;
    
reg [11:0] xpos, ypos, rgb_nxt, xpos_nxt, ypos_nxt;
reg [23:0] counter, counter_nxt;
    
always@(posedge clk) begin
    if(rst) begin
        Select_out <= SelectMode;
        hcount_out <= 0;
        vcount_out <= 0;
        hblnk_out <= 0;
        vblnk_out <= 0;
        hsync_out <= 0;
        vsync_out <= 0;
        rgb_out <= 0;
        xpos <= X_POS_0;
        ypos <= Y_POS_0;
        counter <= 0;
    end
    else begin
        Select_out <= SelectMode;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hcount_out <= hcount;
        vcount_out <= vcount;
        rgb_out <= rgb_nxt;
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        counter <= counter_nxt;     
    end
end

localparam LEFT = 400,
           DOWN = 400,
           UP   = 600,
           RIGHT= 600,
           STEP = 1,
           DELAY = 1000000;
           
//Licznik szybkoœci przemieszczania       
always @* begin
    if (counter == DELAY) counter_nxt = 0;
    else counter_nxt = counter + 1;
end

//Logika poruszania
always@* begin
    if(SelectMode == 0) begin
        xpos_nxt = X_POS_0;
        ypos_nxt = Y_POS_0; 
        end
    else begin
        if (xpos < 3) begin
            xpos_nxt = 3;
            ypos_nxt = ypos;
            end
        else if (xpos > 1004) begin
            xpos_nxt = 1004;
            ypos_nxt = ypos;
            end
        else if (ypos < 3) begin
            xpos_nxt = xpos;
            ypos_nxt = 3;
            end
        else if (ypos > 744) begin
            xpos_nxt = xpos;
            ypos_nxt = 744;
            end
            
        else if (counter == 0) begin
            if (Data_in_X < LEFT && Data_in_Y < DOWN) begin
                xpos_nxt = xpos + STEP;
                ypos_nxt = ypos + STEP;
                end
            else if (Data_in_X > RIGHT && Data_in_Y < DOWN) begin
                xpos_nxt = xpos - STEP;
                ypos_nxt = ypos + STEP;
                end
            else if (Data_in_X < LEFT && Data_in_Y > UP) begin
                xpos_nxt = xpos + STEP;
                ypos_nxt = ypos - STEP;
                end
            else if (Data_in_X > RIGHT && Data_in_Y > UP) begin
                xpos_nxt = xpos - STEP;
                ypos_nxt = ypos - STEP;
                end
            else if (Data_in_X < LEFT) begin
                xpos_nxt = xpos + STEP;
                ypos_nxt = ypos;
                end  
            else if (Data_in_X > RIGHT) begin
                xpos_nxt = xpos - STEP;
                ypos_nxt = ypos;
                end
            else if (Data_in_Y < DOWN) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + STEP;
                end
            else if (Data_in_Y > UP) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - STEP;
                end
            else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                end
        end
        else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end
    end   
end

//Renderowanie grafiki 
always@* begin
    if(SelectMode == 0) rgb_nxt = rgb_in;
    else begin
        if(hcount > xpos && hcount < xpos + 20 && vcount > ypos && vcount < ypos + 20) rgb_nxt = 12'h0_0_0;
        else rgb_nxt = rgb_in;
    end
end
       
endmodule
