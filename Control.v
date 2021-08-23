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
    input wire [9:0] Data_X_op,
    input wire [9:0] Data_Y_op,
    
    output reg Select_out,
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out,
    output reg [9:0] xpos_UART,
    output reg [9:0] ypos_UART,
    output reg [1:0] direction_bullet
    );
    
localparam X_POS_0 = 300,
           Y_POS_0 = 700;

reg [1:0] direction_bullet_nxt;   
reg [11:0] xpos_nxt, ypos_nxt;
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
        xpos_UART <= X_POS_0;
        ypos_UART <= Y_POS_0;
        counter <= 0;
        direction_bullet <= 0;
    end
    else begin
        Select_out <= SelectMode;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hcount_out <= hcount;
        vcount_out <= vcount;
        rgb_out <= rgb_in;
        xpos_UART <= xpos_nxt;
        ypos_UART <= ypos_nxt;
        counter <= counter_nxt;
        direction_bullet <= direction_bullet_nxt;
    end
end

localparam LEFT = 400,
           DOWN = 400,
           UP   = 600,
           RIGHT= 600,
           STEP = 1,
           DELAY = 1000000,
           LEFT_BORDER = 2,
           RIGHT_BORDER = 719,
           UP_BORDER = 2,
           DOWN_BORDER = 702,
           H_BUILDING_UP = 17,
           H_BUILDING_DOWN = 171,
           H_BUILDING_LEFT = 260,
           H_BUILDING_RIGHT = 441,
           HOUSE_UP = 499,
           HOUSE_DOWN = 643,
           HOUSE_LEFT = 243,
           HOUSE_RIGHT = 453;

//Licznik szybkości przemieszczania       
always @* begin
    if (counter == DELAY) counter_nxt = 0;
    else counter_nxt = counter + 1;
end

//Logika poruszania
always@* begin
    direction_bullet_nxt = direction_bullet;
    if(SelectMode == 0) begin
        xpos_nxt = X_POS_0;
        ypos_nxt = Y_POS_0; 
        end
    else begin       
        //GRANICE MAPY
        if (xpos_UART < LEFT_BORDER) begin
            xpos_nxt = LEFT_BORDER;
            ypos_nxt = ypos_UART;
            end
        else if (xpos_UART > RIGHT_BORDER) begin
            xpos_nxt = RIGHT_BORDER;
            ypos_nxt = ypos_UART;
            end
        else if (ypos_UART < UP_BORDER) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = UP_BORDER;
            end
        else if (ypos_UART > DOWN_BORDER) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = DOWN_BORDER;
            end
        //PRZESZKODA CZOŁG
         else if((xpos_UART+48 == (Data_X_op+1))&&(xpos_UART < (Data_X_op+48))&&(ypos_UART < (Data_Y_op+64))&&(ypos_UART+64 > Data_Y_op)) begin
             xpos_nxt = Data_X_op-47;
             ypos_nxt = ypos_UART;
         end
         else if((xpos_UART+48 > Data_X_op)&&(xpos_UART == (Data_X_op+47))&&(ypos_UART < (Data_Y_op+64))&&(ypos_UART+64 > Data_Y_op)) begin
            xpos_nxt = Data_X_op+48;
            ypos_nxt = ypos_UART;
         end
         else if((xpos_UART+48 > Data_X_op)&&(xpos_UART < (Data_X_op+48))&&(ypos_UART ==(Data_Y_op+63))&&(ypos_UART+64 > Data_Y_op)) begin
             xpos_nxt = xpos_UART;
             ypos_nxt = Data_Y_op+64;
         end 
         else if((xpos_UART+48 > Data_X_op)&&(xpos_UART < (Data_X_op+48))&&(ypos_UART < (Data_Y_op+64))&&(ypos_UART+64 == (Data_Y_op + 1))) begin
             xpos_nxt = xpos_UART;
             ypos_nxt = Data_Y_op-63;
         end
        //PRZESZKODA BUDYNEK H 
        else if((xpos_UART == H_BUILDING_LEFT+1)&&(xpos_UART < H_BUILDING_RIGHT)&&(ypos_UART < H_BUILDING_DOWN)&&(ypos_UART > H_BUILDING_UP)) begin
            xpos_nxt = H_BUILDING_LEFT;
            ypos_nxt = ypos_UART;
        end
        else if((xpos_UART > H_BUILDING_LEFT)&&(xpos_UART == H_BUILDING_RIGHT-1)&&(ypos_UART < H_BUILDING_DOWN)&&(ypos_UART > H_BUILDING_UP)) begin
            xpos_nxt = H_BUILDING_RIGHT;
            ypos_nxt = ypos_UART;
        end
        else if((xpos_UART > H_BUILDING_LEFT)&&(xpos_UART < H_BUILDING_RIGHT)&&(ypos_UART == H_BUILDING_DOWN-1)&&(ypos_UART > H_BUILDING_UP)) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = H_BUILDING_DOWN;
        end 
        else if((xpos_UART > H_BUILDING_LEFT)&&(xpos_UART < H_BUILDING_RIGHT)&&(ypos_UART < H_BUILDING_DOWN)&&(ypos_UART == H_BUILDING_UP + 1)) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = H_BUILDING_UP;
        end
        //PRZESZKODA DOM 
        else if((xpos_UART == HOUSE_LEFT+1)&&(xpos_UART < HOUSE_RIGHT)&&(ypos_UART < HOUSE_DOWN)&&(ypos_UART > HOUSE_UP)) begin
            xpos_nxt = HOUSE_LEFT;
            ypos_nxt = ypos_UART;
        end
        else if((xpos_UART > HOUSE_LEFT)&&(xpos_UART == HOUSE_RIGHT-1)&&(ypos_UART < HOUSE_DOWN)&&(ypos_UART > HOUSE_UP)) begin
            xpos_nxt = HOUSE_RIGHT;
            ypos_nxt = ypos_UART;
        end
        else if((xpos_UART > HOUSE_LEFT)&&(xpos_UART < HOUSE_RIGHT)&&(ypos_UART == HOUSE_DOWN-1)&&(ypos_UART > HOUSE_UP)) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = HOUSE_DOWN;
        end 
        else if((xpos_UART > HOUSE_LEFT)&&(xpos_UART < HOUSE_RIGHT)&&(ypos_UART < HOUSE_DOWN)&&(ypos_UART == HOUSE_UP + 1)) begin
            xpos_nxt = xpos_UART;
            ypos_nxt = HOUSE_UP;
        end
        //LOGIKA PORUSZANIA
        else if (counter == 0) begin
            if (Data_in_X < LEFT && Data_in_Y < DOWN) begin
                xpos_nxt = xpos_UART + STEP;
                ypos_nxt = ypos_UART + STEP;
                end
            else if (Data_in_X > RIGHT && Data_in_Y < DOWN) begin
                xpos_nxt = xpos_UART - STEP;
                ypos_nxt = ypos_UART + STEP;
                end
            else if (Data_in_X < LEFT && Data_in_Y > UP) begin
                xpos_nxt = xpos_UART + STEP;
                ypos_nxt = ypos_UART - STEP;
                end
            else if (Data_in_X > RIGHT && Data_in_Y > UP) begin
                xpos_nxt = xpos_UART - STEP;
                ypos_nxt = ypos_UART - STEP;
                end
            else if (Data_in_X < LEFT) begin
                xpos_nxt = xpos_UART + STEP;
                ypos_nxt = ypos_UART;
                direction_bullet_nxt = 3; 
                end  
            else if (Data_in_X > RIGHT) begin
                xpos_nxt = xpos_UART - STEP;
                ypos_nxt = ypos_UART;
                direction_bullet_nxt = 2;
                end
            else if (Data_in_Y < DOWN) begin
                xpos_nxt = xpos_UART;
                ypos_nxt = ypos_UART + STEP;
                direction_bullet_nxt = 1;
                end
            else if (Data_in_Y > UP) begin
                xpos_nxt = xpos_UART;
                ypos_nxt = ypos_UART - STEP;
                direction_bullet_nxt = 0;
                end
            else begin
                xpos_nxt = xpos_UART;
                ypos_nxt = ypos_UART;
                end
        end
        else begin
            xpos_nxt = xpos_UART;
            ypos_nxt = ypos_UART;
        end
    end   
end
       
endmodule
