`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module control(
    input wire clk,
    input wire rst,
    input wire select_mode,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [11:0] rgb_in,
    input wire [9:0] data_in_x_jstk,
    input wire [9:0] data_in_y_jstk,
    input wire [9:0] xpos_tank_op,
    input wire [9:0] ypos_tank_op,
    
    output reg select_out,
    output reg [10:0] hcount_out,
    output reg [9:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out,
    output reg [9:0] xpos_tank_uart_in,
    output reg [9:0] ypos_tank_uart_in,
    output reg [1:0] direction_tank
);

//Registers and Localparams
//****************************************************************************************************************//

reg [1:0] direction_tank_nxt;   
reg [11:0] xpos_tank_nxt, ypos_tank_nxt;
reg [23:0] counter, counter_nxt;

localparam X_POS_0 = 300;
localparam Y_POS_0 = 5;
localparam LEFT = 400;
localparam DOWN = 400;
localparam UP   = 600;
localparam RIGHT= 600;
localparam STEP = 1;
localparam DELAY = 1000000;
localparam LEFT_BORDER = 2;
localparam RIGHT_BORDER = 719;
localparam UP_BORDER = 2;
localparam DOWN_BORDER = 702;
//TANK
localparam LENGTH = 64;
localparam LENGTH_1 = 63;
localparam WIDTH  = 48;
localparam WIDTH_1  = 47;
//OBSTACLES
localparam H_BUILDING_UP = 17;
localparam H_BUILDING_DOWN = 171;
localparam H_BUILDING_LEFT = 260;
localparam H_BUILDING_RIGHT = 441;
localparam HOUSE_UP = 499;
localparam HOUSE_DOWN = 643;
localparam HOUSE_LEFT = 243;
localparam HOUSE_RIGHT = 453;
localparam WALL1_UP = 313;
localparam WALL1_DOWN = 394;
localparam WALL1_LEFT = 0;
localparam WALL1_RIGHT = 181;
localparam WALL2_UP = 246;
localparam WALL2_DOWN = 329;
localparam WALL2_LEFT = 221;
localparam WALL2_RIGHT = 402;
localparam WALL3_UP = 312;
localparam WALL3_DOWN = 391;
localparam WALL3_LEFT = 342;
localparam WALL3_RIGHT = 518;  
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//              
always@(posedge clk) begin
    if(rst) begin
        {hcount_out, vcount_out} <= 0;
        {hblnk_out, vblnk_out, hsync_out, vsync_out}  <= 0;
        rgb_out <= 0;
        xpos_tank_uart_in <= X_POS_0;
        ypos_tank_uart_in <= Y_POS_0;
        counter <= 0;
        select_out <= select_mode;
        direction_tank <= 1;
    end
    else begin
        select_out <= select_mode;
        hcount_out <= hcount;
        vcount_out <= vcount;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        rgb_out <= rgb_in;
        xpos_tank_uart_in <= xpos_tank_nxt;
        ypos_tank_uart_in <= ypos_tank_nxt;
        counter <= counter_nxt;
        direction_tank <= direction_tank_nxt;
    end
end

//****************************************************************************************************************// 

//Logic
//****************************************************************************************************************//     
//Movement speed counter      
always @* begin
    if (counter == DELAY) counter_nxt = 0;
    else counter_nxt = counter + 1;
end

//Movement logic
always@* begin
    direction_tank_nxt = direction_tank;
    if(select_mode == 0) begin
        xpos_tank_nxt = X_POS_0;
        ypos_tank_nxt = Y_POS_0; 
    end
    else begin       
        //MAP BORDERS
        if (xpos_tank_uart_in < LEFT_BORDER) begin
            xpos_tank_nxt = LEFT_BORDER;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if (xpos_tank_uart_in > RIGHT_BORDER) begin
            xpos_tank_nxt = RIGHT_BORDER;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if (ypos_tank_uart_in < UP_BORDER) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = UP_BORDER;
        end
        else if (ypos_tank_uart_in > DOWN_BORDER) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = DOWN_BORDER;
        end
        //OBSTACLE - TANK
         else if((xpos_tank_uart_in+WIDTH == (xpos_tank_op+1))&&(xpos_tank_uart_in < (xpos_tank_op+ WIDTH))&&(ypos_tank_uart_in < (ypos_tank_op+LENGTH))&&(ypos_tank_uart_in+LENGTH > ypos_tank_op)) begin
             xpos_tank_nxt = xpos_tank_op-WIDTH_1;
             ypos_tank_nxt = ypos_tank_uart_in;
         end
         else if(((xpos_tank_uart_in+WIDTH) > xpos_tank_op)&&(xpos_tank_uart_in == (xpos_tank_op+WIDTH_1))&&(ypos_tank_uart_in < (ypos_tank_op+LENGTH))&&((ypos_tank_uart_in+LENGTH) > ypos_tank_op)) begin
            xpos_tank_nxt = xpos_tank_op+WIDTH;
            ypos_tank_nxt = ypos_tank_uart_in;
         end
         else if(((xpos_tank_uart_in+WIDTH) > xpos_tank_op)&&(xpos_tank_uart_in < (xpos_tank_op+WIDTH))&&(ypos_tank_uart_in == (ypos_tank_op+LENGTH_1))&&((ypos_tank_uart_in+LENGTH) > ypos_tank_op)) begin
             xpos_tank_nxt = xpos_tank_uart_in;
             ypos_tank_nxt = ypos_tank_op+LENGTH;
         end 
         else if(((xpos_tank_uart_in+WIDTH) > xpos_tank_op)&&(xpos_tank_uart_in < (xpos_tank_op+WIDTH))&&(ypos_tank_uart_in < (ypos_tank_op+LENGTH))&&((ypos_tank_uart_in+LENGTH)==(ypos_tank_op + 1))) begin
             xpos_tank_nxt = xpos_tank_uart_in;
             ypos_tank_nxt = ypos_tank_op-LENGTH_1;
         end
        //OBSTACLE - H BUILDING
        else if((xpos_tank_uart_in == (H_BUILDING_LEFT+1))&&(xpos_tank_uart_in < H_BUILDING_RIGHT)&&(ypos_tank_uart_in < H_BUILDING_DOWN)&&(ypos_tank_uart_in > H_BUILDING_UP)) begin
            xpos_tank_nxt = H_BUILDING_LEFT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > H_BUILDING_LEFT)&&(xpos_tank_uart_in == (H_BUILDING_RIGHT-1))&&(ypos_tank_uart_in < H_BUILDING_DOWN)&&(ypos_tank_uart_in > H_BUILDING_UP)) begin
            xpos_tank_nxt = H_BUILDING_RIGHT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > H_BUILDING_LEFT)&&(xpos_tank_uart_in < H_BUILDING_RIGHT)&&(ypos_tank_uart_in == (H_BUILDING_DOWN-1))&&(ypos_tank_uart_in > H_BUILDING_UP)) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = H_BUILDING_DOWN;
        end 
        else if((xpos_tank_uart_in > H_BUILDING_LEFT)&&(xpos_tank_uart_in < H_BUILDING_RIGHT)&&(ypos_tank_uart_in < H_BUILDING_DOWN)&&(ypos_tank_uart_in == (H_BUILDING_UP+1))) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = H_BUILDING_UP;
        end
        //OBSTACLE - HOUSE
        else if((xpos_tank_uart_in == (HOUSE_LEFT+1))&&(xpos_tank_uart_in < HOUSE_RIGHT)&&(ypos_tank_uart_in < HOUSE_DOWN)&&(ypos_tank_uart_in > HOUSE_UP)) begin
            xpos_tank_nxt = HOUSE_LEFT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > HOUSE_LEFT)&&(xpos_tank_uart_in == (HOUSE_RIGHT-1))&&(ypos_tank_uart_in < HOUSE_DOWN)&&(ypos_tank_uart_in > HOUSE_UP)) begin
            xpos_tank_nxt = HOUSE_RIGHT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > HOUSE_LEFT)&&(xpos_tank_uart_in < HOUSE_RIGHT)&&(ypos_tank_uart_in == (HOUSE_DOWN-1))&&(ypos_tank_uart_in > HOUSE_UP)) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = HOUSE_DOWN;
        end 
        else if((xpos_tank_uart_in > HOUSE_LEFT)&&(xpos_tank_uart_in < HOUSE_RIGHT)&&(ypos_tank_uart_in < HOUSE_DOWN)&&(ypos_tank_uart_in == (HOUSE_UP+1))) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = HOUSE_UP;
        end
        //OBSTACLE - WALL1
        else if((xpos_tank_uart_in == (WALL1_LEFT+1))&&(xpos_tank_uart_in < WALL1_RIGHT)&&(ypos_tank_uart_in < WALL1_DOWN)&&(ypos_tank_uart_in > WALL1_UP)) begin
            xpos_tank_nxt = WALL1_LEFT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL1_LEFT)&&(xpos_tank_uart_in == (WALL1_RIGHT-1))&&(ypos_tank_uart_in < WALL1_DOWN)&&(ypos_tank_uart_in > WALL1_UP)) begin
            xpos_tank_nxt = WALL1_RIGHT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL1_LEFT)&&(xpos_tank_uart_in < WALL1_RIGHT)&&(ypos_tank_uart_in == (WALL1_DOWN-1))&&(ypos_tank_uart_in > WALL1_UP)) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL1_DOWN;
        end 
        else if((xpos_tank_uart_in > WALL1_LEFT)&&(xpos_tank_uart_in < WALL1_RIGHT)&&(ypos_tank_uart_in < WALL1_DOWN)&&(ypos_tank_uart_in == (WALL1_UP+1))) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL1_UP;
        end
        //OBSTACLE - WALL2
        else if((xpos_tank_uart_in == (WALL2_LEFT+1))&&(xpos_tank_uart_in < WALL2_RIGHT)&&(ypos_tank_uart_in < WALL2_DOWN)&&(ypos_tank_uart_in > WALL2_UP)) begin
            xpos_tank_nxt = WALL2_LEFT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL2_LEFT)&&(xpos_tank_uart_in == (WALL2_RIGHT-1))&&(ypos_tank_uart_in < WALL2_DOWN)&&(ypos_tank_uart_in > WALL2_UP)) begin
            xpos_tank_nxt = WALL2_RIGHT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL2_LEFT)&&(xpos_tank_uart_in < WALL2_RIGHT)&&(ypos_tank_uart_in == (WALL2_DOWN-1))&&(ypos_tank_uart_in > WALL2_UP)) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL2_DOWN;
        end 
        else if((xpos_tank_uart_in > WALL2_LEFT)&&(xpos_tank_uart_in < WALL2_RIGHT)&&(ypos_tank_uart_in < WALL2_DOWN)&&(ypos_tank_uart_in == (WALL2_UP+1))) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL2_UP;
        end
        //OBSTACLE - WALL3
        else if((xpos_tank_uart_in == (WALL3_LEFT+1))&&(xpos_tank_uart_in < WALL3_RIGHT)&&(ypos_tank_uart_in < WALL3_DOWN)&&(ypos_tank_uart_in > WALL3_UP)) begin
            xpos_tank_nxt = WALL3_LEFT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL3_LEFT)&&(xpos_tank_uart_in == (WALL3_RIGHT-1))&&(ypos_tank_uart_in < WALL3_DOWN)&&(ypos_tank_uart_in > WALL3_UP)) begin
            xpos_tank_nxt = WALL3_RIGHT;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
        else if((xpos_tank_uart_in > WALL3_LEFT)&&(xpos_tank_uart_in < WALL3_RIGHT)&&(ypos_tank_uart_in == (WALL3_DOWN-1))&&(ypos_tank_uart_in > WALL3_UP)) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL3_DOWN;
        end 
        else if((xpos_tank_uart_in > WALL3_LEFT)&&(xpos_tank_uart_in < WALL3_RIGHT)&&(ypos_tank_uart_in < WALL3_DOWN)&&(ypos_tank_uart_in == (WALL3_UP+1))) begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = WALL3_UP;
        end       
        //MOVEMENT LOGIC
        else if (counter == 0) begin
            if (data_in_x_jstk < LEFT && data_in_y_jstk < DOWN) begin
                xpos_tank_nxt = xpos_tank_uart_in + STEP;
                ypos_tank_nxt = ypos_tank_uart_in + STEP;
            end
            else if (data_in_x_jstk > RIGHT && data_in_y_jstk < DOWN) begin
                xpos_tank_nxt = xpos_tank_uart_in - STEP;
                ypos_tank_nxt = ypos_tank_uart_in + STEP;
            end
            else if (data_in_x_jstk < LEFT && data_in_y_jstk > UP) begin
                xpos_tank_nxt = xpos_tank_uart_in + STEP;
                ypos_tank_nxt = ypos_tank_uart_in - STEP;
            end
            else if (data_in_x_jstk > RIGHT && data_in_y_jstk > UP) begin
                xpos_tank_nxt = xpos_tank_uart_in - STEP;
                ypos_tank_nxt = ypos_tank_uart_in - STEP;
            end
            else if (data_in_x_jstk < LEFT) begin
                xpos_tank_nxt = xpos_tank_uart_in + STEP;
                ypos_tank_nxt = ypos_tank_uart_in;
                direction_tank_nxt = 3; 
            end  
            else if (data_in_x_jstk > RIGHT) begin
                xpos_tank_nxt = xpos_tank_uart_in - STEP;
                ypos_tank_nxt = ypos_tank_uart_in;
                direction_tank_nxt = 2;
            end
            else if (data_in_y_jstk < DOWN) begin
                xpos_tank_nxt = xpos_tank_uart_in;
                ypos_tank_nxt = ypos_tank_uart_in + STEP;
                direction_tank_nxt = 1;
            end
            else if (data_in_y_jstk > UP) begin
                xpos_tank_nxt = xpos_tank_uart_in;
                ypos_tank_nxt = ypos_tank_uart_in - STEP;
                direction_tank_nxt = 0;
            end
            else begin
                xpos_tank_nxt = xpos_tank_uart_in;
                ypos_tank_nxt = ypos_tank_uart_in;
            end
        end
        else begin
            xpos_tank_nxt = xpos_tank_uart_in;
            ypos_tank_nxt = ypos_tank_uart_in;
        end
    end   
end
       
endmodule
