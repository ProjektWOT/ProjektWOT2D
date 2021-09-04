`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module gun_ctrl(
    input wire clk,
    input wire rst,
    input wire left_click,
    input wire select,
    input wire hblnk,
    input wire vblnk,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire [11:0] rgb,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
    input wire [9:0]  xpos_tank_in,
    input wire [9:0]  ypos_tank_in,
    input wire [9:0]  xpos_tank_op,
    input wire [9:0]  ypos_tank_op,
    input wire [1:0]  direction_bullet,
    input wire [7:0]  hp_our_state,
     
    output reg select_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out,
    output reg tank_central_hit,
    output reg obstacle_hit,
    output reg [9:0] xpos_bullet_green,
    output reg [9:0] ypos_bullet_green,
    output reg [2:0] direction_for_enemy,
    output reg [7:0] hp_enemy_state,
    output wire [12:0] bullet_ready 
);

//Registers and Localparams
//****************************************************************************************************************//
reg [7:0] hp_enemy_state_nxt = 150;
reg [11:0] rgb_nxt;
reg [16:0] counter,  counter_nxt;
reg [10:0] pos_bullet, pos_bullet_nxt;
reg [9:0]  xpos_block, ypos_block, xpos_block_nxt, ypos_block_nxt;
reg [9:0]  xpos_bullet_green_nxt, ypos_bullet_green_nxt;
reg [2:0]  direction_for_enemy_nxt;
reg tank_central_hit_nxt, obstacle_hit_nxt;
reg dot_on_display, dot_on_display_nxt;

//DISPLAY COUNTER
reg [19:0] reload_time, reload_time_nxt;
reg [3:0] seconds, seconds_nxt=5;
reg [3:0] milis10, milis10_nxt, milis100, milis100_nxt;

localparam DELAY = 130000;
localparam RELOAD = 650000; //650 000 -> 10ms
localparam R_DISPLAY = 10;
localparam D_DISPLAY = 11;
localparam Y_DISPLAY = 13;
localparam FOUR_DISPLAY = 4;
localparam NINE_DISPLAY = 9;
localparam RST_SEC_DISPLAY = 5;

localparam LOWER_LIMIT = 768;
localparam UPPER_LIMIT = 2;
localparam RIGHT_LIMIT = 768;
localparam LEFT__LIMIT = 2;
//BULLET
localparam TANK_WIDTH    = 48;
localparam TANK_WIDTH_HALF = 24;
localparam TANK_WIDTH_HALF1 = 22;
localparam TANK_WIDTH_HALF2 = 26;
localparam BULLET_CONST = 27;
localparam BULLET_CONST1 = 37;
localparam BULLET_CONST2 = 53;
localparam BULLET_LENGTH = 5;
//OBSTACLES
localparam H_BUILDING_UP = 81;
localparam H_BUILDING_DOWN = 170;
localparam H_BUILDING_LEFT = 308;
localparam H_BUILDING_RIGHT = 440;
localparam HOUSE_UP = 563;
localparam HOUSE_DOWN = 642;
localparam HOUSE_LEFT = 291;
localparam HOUSE_RIGHT = 452;
localparam WALL1_UP = 377;
localparam WALL1_DOWN = 393;
localparam WALL1_LEFT = 38;
localparam WALL1_RIGHT = 180;
localparam WALL2_UP = 310;
localparam WALL2_DOWN = 328;
localparam WALL2_LEFT = 269;
localparam WALL2_RIGHT = 401;
localparam WALL3_UP = 376;
localparam WALL3_DOWN = 390;
localparam WALL3_LEFT = 390;
localparam WALL3_RIGHT = 517; 

localparam BLACK = 12'h0_0_0;
//HP_STATE
localparam FULL_HP = 150;
localparam SHOT_HP = 15;
//MACHINE STATES
reg [2:0] state, state_nxt;
localparam IDLE = 3'b000;
localparam SHOT_0 = 3'b001;
localparam SHOT_1 = 3'b010;
localparam SHOT_3 = 3'b011;
localparam SHOT_2 = 3'b100;
localparam HIT_TANK = 3'b101;
localparam HIT_OBSTACLE = 3'b110;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//   
always@(posedge clk) begin
    if(rst) begin
        {select_out, hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out, rgb_out} <= 0;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
        pos_bullet <= ypos_tank_in;
        xpos_block <= xpos_tank_in;
        ypos_block <= ypos_tank_in;
        state <= IDLE;
        hp_enemy_state <= FULL_HP;
        seconds <= RST_SEC_DISPLAY;
        dot_on_display <= 1;
        {milis100, milis10} <= 0;
        {xpos_bullet_green, ypos_bullet_green} <= 0;
        {tank_central_hit, obstacle_hit} <= 0;
        reload_time <= 0;
        counter <= 0;
        direction_for_enemy <= 0;
    end
    else begin
        select_out <= select;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hcount_out <= hcount;
        vcount_out <= vcount;
        rgb_out <= rgb_nxt;
        xpos_mouse_out <= xpos_mouse_in;
        ypos_mouse_out <= ypos_mouse_in;
        pos_bullet <= pos_bullet_nxt;
        counter <= counter_nxt;
        state <= state_nxt;
        xpos_block <= xpos_block_nxt;
        ypos_block <= ypos_block_nxt;
        xpos_bullet_green <= xpos_bullet_green_nxt;
        ypos_bullet_green <= ypos_bullet_green_nxt;
        tank_central_hit <= tank_central_hit_nxt;
        obstacle_hit <= obstacle_hit_nxt;
        direction_for_enemy <= direction_for_enemy_nxt;
        hp_enemy_state <= hp_enemy_state_nxt;
        reload_time <= reload_time_nxt;
        seconds <= seconds_nxt;
        milis10 <= milis10_nxt;
        milis100 <= milis100_nxt;
        dot_on_display <= dot_on_display_nxt;
    end
end
//****************************************************************************************************************// 

//Logic and StateMachine
//****************************************************************************************************************//
always@* begin
    //To avoid the inferrings
    state_nxt = state;
    pos_bullet_nxt = pos_bullet;
    counter_nxt = counter;
    rgb_nxt = rgb_out;
    xpos_block_nxt = xpos_block;
    ypos_block_nxt = ypos_block;
    tank_central_hit_nxt = tank_central_hit;
    obstacle_hit_nxt = obstacle_hit;
    xpos_bullet_green_nxt = xpos_bullet_green;
    ypos_bullet_green_nxt = ypos_bullet_green;
    direction_for_enemy_nxt = direction_for_enemy;
    hp_enemy_state_nxt = hp_enemy_state;
    
    //Counter on display logic
    reload_time_nxt = reload_time;
    seconds_nxt = seconds;
    milis10_nxt = milis10;
    milis100_nxt = milis100;
    dot_on_display_nxt = dot_on_display;
    if(select == 1 && hp_enemy_state != 0 && hp_our_state != 0) begin
        if(left_click == 1 && seconds == R_DISPLAY) begin 
            seconds_nxt = FOUR_DISPLAY; 
            dot_on_display_nxt = 1; 
        end
        else if((seconds == 0 && milis10 == 0 && milis100 == 0) || seconds == R_DISPLAY) begin
            seconds_nxt = R_DISPLAY;
            milis100_nxt = Y_DISPLAY;
            milis10_nxt = D_DISPLAY;
            dot_on_display_nxt = 0;
        end
        else if(reload_time >= RELOAD) begin
            if(milis10 == 0) begin
                if(milis100 == 0) begin
                    milis10_nxt = NINE_DISPLAY;
                    milis100_nxt = NINE_DISPLAY;
                    seconds_nxt = seconds - 1;
                end
                else begin
                    milis10_nxt = NINE_DISPLAY;
                    milis100_nxt = milis100 - 1;
                end
            end
            else milis10_nxt = milis10 - 1;
            reload_time_nxt = 0;
        end
        else reload_time_nxt = reload_time + 1;
    end
    else begin 
        seconds_nxt = RST_SEC_DISPLAY; 
        dot_on_display_nxt = 1; 
    end
    
    //States of Machine
    case(state)
        IDLE: begin
            if(select == 1 && left_click == 1 && seconds == R_DISPLAY) begin
                counter_nxt = 0;
                pos_bullet_nxt = 0;
                state_nxt = SHOT_0+direction_bullet;
                rgb_nxt = rgb;
                tank_central_hit_nxt = 0;
                obstacle_hit_nxt = 0;       
                xpos_block_nxt = xpos_tank_in;
                ypos_block_nxt = ypos_tank_in;
                xpos_bullet_green_nxt = 0;
                ypos_bullet_green_nxt = 0;
                direction_for_enemy_nxt = 0;
            end
            else begin
                counter_nxt = 0;
                pos_bullet_nxt = 0;
                state_nxt = IDLE;
                rgb_nxt = rgb;
                tank_central_hit_nxt = 0;
                obstacle_hit_nxt = 0;
                xpos_block_nxt = xpos_tank_in;
                ypos_block_nxt = ypos_tank_in;
                xpos_bullet_green_nxt = 0;
                ypos_bullet_green_nxt = 0;
                direction_for_enemy_nxt = 0;
            end
        end
        
        SHOT_0: begin
            if (counter == DELAY) begin 
                counter_nxt = 0;
                pos_bullet_nxt = pos_bullet+1;
            end
            else begin
                counter_nxt = counter+1;
                pos_bullet_nxt = pos_bullet;
            end            
            if((ypos_block-pos_bullet-BULLET_LENGTH) <= UPPER_LIMIT) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if(((ypos_block-pos_bullet-TANK_WIDTH) <= ypos_tank_op)&&((xpos_block+TANK_WIDTH_HALF) >= xpos_tank_op)&&((xpos_block-TANK_WIDTH_HALF) <= xpos_tank_op)&&((ypos_block-pos_bullet+BULLET_LENGTH) >= ypos_tank_op)) begin 
                state_nxt = HIT_TANK; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE H BUILDING
            else if(((ypos_block-pos_bullet-BULLET_LENGTH) >= H_BUILDING_UP)&&((xpos_block+TANK_WIDTH_HALF) <= H_BUILDING_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= H_BUILDING_LEFT)&&((ypos_block-pos_bullet-BULLET_LENGTH) <= H_BUILDING_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE HOUSE 
            else if(((ypos_block-pos_bullet-BULLET_LENGTH) >= HOUSE_UP)&&((xpos_block+TANK_WIDTH_HALF) <= HOUSE_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= HOUSE_LEFT)&&((ypos_block-pos_bullet-BULLET_LENGTH) <= HOUSE_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL1
            else if(((ypos_block-pos_bullet-BULLET_LENGTH) >= WALL1_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL1_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL1_LEFT)&&((ypos_block-pos_bullet-BULLET_LENGTH) <= WALL1_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL2
            else if(((ypos_block-pos_bullet-BULLET_LENGTH) >= WALL2_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL2_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL2_LEFT)&&((ypos_block-pos_bullet-BULLET_LENGTH) <= WALL2_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL3
            else if(((ypos_block-pos_bullet-BULLET_LENGTH) >= WALL3_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL3_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL3_LEFT)&&((ypos_block-pos_bullet-BULLET_LENGTH) <= WALL3_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            else if((vcount >= (ypos_block-pos_bullet-BULLET_LENGTH))&&(vcount <= (ypos_block-pos_bullet+BULLET_LENGTH))&&(hcount >= (xpos_block+TANK_WIDTH_HALF1))&&(hcount <= (xpos_block+TANK_WIDTH_HALF2))) rgb_nxt = BLACK;
            else rgb_nxt = rgb;
            xpos_bullet_green_nxt = xpos_block+TANK_WIDTH_HALF;
            ypos_bullet_green_nxt = ypos_block-pos_bullet;
            direction_for_enemy_nxt = 1;
        end
        
        SHOT_1: begin
            if (counter == DELAY) begin 
                counter_nxt = 0;
                pos_bullet_nxt = pos_bullet+1;
            end
            else begin
                counter_nxt = counter+1;
                pos_bullet_nxt = pos_bullet;
            end      
            if((ypos_block+pos_bullet+BULLET_CONST) >= LOWER_LIMIT) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if(((ypos_block+pos_bullet+BULLET_LENGTH) >= ypos_tank_op)&&((xpos_block+TANK_WIDTH_HALF) >= xpos_tank_op)&&((xpos_block-TANK_WIDTH_HALF) <= xpos_tank_op)&&((ypos_block+pos_bullet-BULLET_CONST2) <= ypos_tank_op)) begin 
                state_nxt = HIT_TANK; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE H BUILDING
            else if(((ypos_block+pos_bullet+BULLET_CONST) >= H_BUILDING_UP)&&((xpos_block+TANK_WIDTH_HALF) <= H_BUILDING_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= H_BUILDING_LEFT)&&((ypos_block+pos_bullet+BULLET_LENGTH) <= H_BUILDING_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb;
            end
            //OBSTACLE HOUSE  
            else if(((ypos_block+pos_bullet+BULLET_CONST) >= HOUSE_UP)&&((xpos_block+TANK_WIDTH_HALF) <= HOUSE_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= HOUSE_LEFT)&&((ypos_block+pos_bullet+BULLET_LENGTH) <= HOUSE_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL1
            else if(((ypos_block+pos_bullet+BULLET_CONST) >= WALL1_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL1_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL1_LEFT)&&((ypos_block+pos_bullet+BULLET_LENGTH) <= WALL1_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL2
            else if(((ypos_block+pos_bullet+BULLET_CONST) >= WALL2_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL2_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL2_LEFT)&&((ypos_block+pos_bullet+BULLET_LENGTH) <= WALL2_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL3
            else if(((ypos_block+pos_bullet+BULLET_CONST) >= WALL3_UP)&&((xpos_block+TANK_WIDTH_HALF) <= WALL3_RIGHT)&&((xpos_block+TANK_WIDTH_HALF) >= WALL3_LEFT)&&((ypos_block+pos_bullet+BULLET_LENGTH) <= WALL3_DOWN)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            else if((vcount >= (ypos_block+pos_bullet+BULLET_CONST))&&(vcount <= (ypos_block+pos_bullet+BULLET_CONST1))&&(hcount >= (xpos_block+TANK_WIDTH_HALF1))&&(hcount <= (xpos_block+TANK_WIDTH_HALF2))) rgb_nxt = BLACK;
            else rgb_nxt = rgb;
            xpos_bullet_green_nxt = xpos_block+TANK_WIDTH_HALF;
            ypos_bullet_green_nxt = ypos_block + pos_bullet;
            direction_for_enemy_nxt = 2;
        end
        
        SHOT_2: begin
            if (counter == DELAY) begin 
                counter_nxt = 0;
                pos_bullet_nxt = pos_bullet + 1;
            end
            else begin
                counter_nxt = counter + 1;
                pos_bullet_nxt = pos_bullet;
            end
                
            if ((xpos_block+pos_bullet+BULLET_CONST) >= RIGHT_LIMIT) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if(((xpos_block+pos_bullet+BULLET_LENGTH) >= xpos_tank_op)&&((ypos_block+TANK_WIDTH_HALF) >= ypos_tank_op)&&((ypos_block-TANK_WIDTH_HALF) <= ypos_tank_op)&&((xpos_block+pos_bullet-BULLET_CONST2) <= xpos_tank_op)) begin 
                state_nxt = HIT_TANK; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE H BUILDING
            else if(((xpos_block+pos_bullet+BULLET_CONST) >= H_BUILDING_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= H_BUILDING_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= H_BUILDING_UP)&&((xpos_block+pos_bullet+BULLET_LENGTH) <= H_BUILDING_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE HOUSE 
            else if(((xpos_block+pos_bullet+BULLET_CONST) >= HOUSE_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= HOUSE_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= HOUSE_UP)&&((xpos_block+pos_bullet+BULLET_LENGTH) <= HOUSE_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL1
            else if(((xpos_block+pos_bullet+BULLET_CONST) >= WALL1_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL1_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL1_UP)&&((xpos_block+pos_bullet+BULLET_LENGTH) <= WALL1_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL2
            else if(((xpos_block+pos_bullet+BULLET_CONST) >= WALL2_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL2_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL2_UP)&&((xpos_block+pos_bullet+BULLET_LENGTH) <= WALL2_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL3
            else if(((xpos_block+pos_bullet+BULLET_CONST) >= WALL3_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL3_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL3_UP)&&((xpos_block+pos_bullet+BULLET_LENGTH) <= WALL3_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_block+pos_bullet+BULLET_CONST))&&(hcount <= (xpos_block+pos_bullet+BULLET_CONST1))&&(vcount >= (ypos_block+TANK_WIDTH_HALF1))&&(vcount <= (ypos_block+TANK_WIDTH_HALF2))) rgb_nxt = BLACK;
            else rgb_nxt = rgb;
            xpos_bullet_green_nxt = xpos_block+pos_bullet;
            ypos_bullet_green_nxt = ypos_block+TANK_WIDTH_HALF;
            direction_for_enemy_nxt = 3;
        end 
        
        SHOT_3: begin
            if (counter == DELAY) begin 
                counter_nxt = 0;
                pos_bullet_nxt = pos_bullet + 1;
            end
            else begin
                counter_nxt = counter + 1;
                pos_bullet_nxt = pos_bullet;
            end
            
            if ((xpos_block-pos_bullet-BULLET_LENGTH) <= LEFT__LIMIT) begin 
                state_nxt = IDLE; 
                rgb_nxt = rgb; 
            end
            else if(((xpos_block-pos_bullet-TANK_WIDTH) <= xpos_tank_op)&&((ypos_block+TANK_WIDTH_HALF) >= ypos_tank_op)&&((ypos_block-TANK_WIDTH_HALF) <= ypos_tank_op)&&((xpos_block-pos_bullet+BULLET_LENGTH) >= xpos_tank_op)) begin 
                state_nxt = HIT_TANK; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE H BUILDING
            else if(((xpos_block-pos_bullet-BULLET_LENGTH) >= H_BUILDING_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= H_BUILDING_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= H_BUILDING_UP)&&((xpos_block-pos_bullet+BULLET_LENGTH) <= H_BUILDING_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE HOUSE  
            else if(((xpos_block-pos_bullet-BULLET_LENGTH) >= HOUSE_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= HOUSE_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= HOUSE_UP)&&((xpos_block-pos_bullet+BULLET_LENGTH) <= HOUSE_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL1
            else if(((xpos_block-pos_bullet-BULLET_LENGTH) >= WALL1_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL1_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL1_UP)&&((xpos_block-pos_bullet+BULLET_LENGTH) <= WALL1_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL2
            else if(((xpos_block-pos_bullet-BULLET_LENGTH) >= WALL2_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL2_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL2_UP)&&((xpos_block-pos_bullet+BULLET_LENGTH) <= WALL2_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            //OBSTACLE WALL3
            else if(((xpos_block-pos_bullet-BULLET_LENGTH) >= WALL3_LEFT)&&((ypos_block+TANK_WIDTH_HALF) <= WALL3_DOWN)&&((ypos_block+TANK_WIDTH_HALF) >= WALL3_UP)&&((xpos_block-pos_bullet+BULLET_LENGTH) <= WALL3_RIGHT)) begin 
                state_nxt = HIT_OBSTACLE; 
                rgb_nxt = rgb; 
            end
            else if((hcount >= (xpos_block-pos_bullet-BULLET_LENGTH))&&(hcount <= (xpos_block-pos_bullet+BULLET_LENGTH))&&(vcount >= (ypos_block+TANK_WIDTH_HALF1))&&(vcount <= (ypos_block+BULLET_CONST))) rgb_nxt = BLACK;
            else rgb_nxt = rgb;
            xpos_bullet_green_nxt = xpos_block-pos_bullet;
            ypos_bullet_green_nxt = ypos_block+TANK_WIDTH_HALF;
            direction_for_enemy_nxt = 4;
        end
        
        HIT_TANK: begin
            state_nxt = IDLE;
            tank_central_hit_nxt = 1;
            rgb_nxt = rgb;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
            direction_for_enemy_nxt = 0;
            if(hp_enemy_state == 0) hp_enemy_state_nxt=0;
            else if(hp_enemy_state != 0 && hp_our_state == 0)  hp_enemy_state_nxt = hp_enemy_state;
            else hp_enemy_state_nxt = hp_enemy_state-SHOT_HP;
        end
        
        HIT_OBSTACLE: begin
            state_nxt = IDLE;
            obstacle_hit_nxt = 1;
            rgb_nxt = rgb;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
            direction_for_enemy_nxt = 0;
        end
        
        default: begin 
            state_nxt = IDLE; 
            rgb_nxt=rgb; 
        end
    endcase
end
//****************************************************************************************************************// 
 
//Output
//****************************************************************************************************************// 
assign bullet_ready = {dot_on_display, milis10, milis100, seconds};

endmodule
