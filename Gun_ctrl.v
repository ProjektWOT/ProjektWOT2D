`timescale 1ns / 1ps

module Gun_ctrl(
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
    input wire [11:0] xpos_m,
    input wire [11:0] ypos_m,
    input wire [9:0]  xpos_t,
    input wire [9:0]  ypos_t,
    input wire [9:0]  xpos_t_op,
    input wire [9:0]  ypos_t_op,
    input wire [1:0] direction_bullet,
    input wire [7:0] HP_our_state,
     
    output reg select_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_m_out,
    output reg [11:0] ypos_m_out,
    output reg tank_central_hit,
    output reg obstacle_hit,
    output reg [9:0] xpos_bullet_green,
    output reg [9:0] ypos_bullet_green,
    output reg [2:0] direction_for_enemy,
    output reg [7:0] HP_enemy_state,
    output reg [3:0] Seconds 
);

reg [7:0] HP_enemy_state_nxt = 150;
reg [11:0] rgb_nxt;
reg [16:0] counter,  counter_nxt;
reg [10:0] pos_bullet, pos_bullet_nxt;
reg [9:0] xpos_block, ypos_block, xpos_block_nxt, ypos_block_nxt;
reg [9:0] xpos_bullet_green_nxt, ypos_bullet_green_nxt;
reg [2:0] direction_for_enemy_nxt;
reg tank_central_hit_nxt, obstacle_hit_nxt;

reg [23:0] ReloadTime, ReloadTime_nxt;
reg [3:0]  Seconds_nxt=9;
localparam DELAY = 130000;
localparam RELOAD = 13000000; //13 000 000 -> 200ms

localparam LOWER_LIMIT = 768;
localparam UPPER_LIMIT = 2;
localparam RIGHT_LIMIT = 768;
localparam LEFT__LIMIT = 2;
localparam H_BUILDING_UP = 81;
localparam H_BUILDING_DOWN = 170;
localparam H_BUILDING_LEFT = 308;
localparam H_BUILDING_RIGHT = 440,
           HOUSE_UP = 563,
           HOUSE_DOWN = 642,
           HOUSE_LEFT = 291,
           HOUSE_RIGHT = 452,
           WALL1_UP = 377,
           WALL1_DOWN = 393,
           WALL1_LEFT = 38,
           WALL1_RIGHT = 180,
           WALL2_UP = 310,
           WALL2_DOWN = 328,
           WALL2_LEFT = 269,
           WALL2_RIGHT = 401,
           WALL3_UP = 376,
           WALL3_DOWN = 390,
           WALL3_LEFT = 390,
           WALL3_RIGHT = 517; 

reg [2:0] state, state_nxt;
localparam IDLE = 3'b000;
localparam SHOT_0 = 3'b001;
localparam SHOT_1 = 3'b010;
localparam SHOT_3 = 3'b011;
localparam SHOT_2 = 3'b100;
localparam HIT_TANK = 3'b101;
localparam HIT_OBSTACLE = 3'b110;

always@(posedge clk) begin
    if(rst) begin
        {select_out, hblnk_out, vblnk_out, hsync_out, vsync_out} <= 0;
        {hcount_out, vcount_out, rgb_out} <= 0;
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
        pos_bullet <= ypos_t;
        xpos_block <= xpos_t;
        ypos_block <= ypos_t;
        state <= IDLE;
        HP_enemy_state <= 150;
        Seconds <= 9;
        {counter, tank_central_hit, obstacle_hit, xpos_bullet_green, ypos_bullet_green, direction_for_enemy, ReloadTime} <= 0;
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
        xpos_m_out <= xpos_m;
        ypos_m_out <= ypos_m;
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
        HP_enemy_state <= HP_enemy_state_nxt;
        ReloadTime <= ReloadTime_nxt;
        Seconds <= Seconds_nxt;
    end
end

always@* begin
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
    HP_enemy_state_nxt = HP_enemy_state;
    
    ReloadTime_nxt = ReloadTime;
    Seconds_nxt = Seconds;
    if(select == 1 && HP_enemy_state != 0 && HP_our_state != 0) begin
        if(left_click == 1 && Seconds == 0) Seconds_nxt = 9;
        else if(Seconds == 0) Seconds_nxt = 0;
        else if(ReloadTime >= RELOAD) begin
            Seconds_nxt = Seconds - 1;
            ReloadTime_nxt = 0;
            end
        else ReloadTime_nxt = ReloadTime + 1;
    end
    else Seconds_nxt = 9;

    case(state)
    IDLE: begin
        if(select == 1 && left_click == 1 && Seconds == 0) begin
            state_nxt = SHOT_0 + direction_bullet;
            tank_central_hit_nxt = 0;
            obstacle_hit_nxt = 0;
            xpos_block_nxt = xpos_t;
            ypos_block_nxt = ypos_t;
            counter_nxt = 0;
            pos_bullet_nxt = 0;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
            rgb_nxt = rgb;
            direction_for_enemy_nxt = 0;
        end
        else begin
            counter_nxt = 0;
            pos_bullet_nxt = 0;
            state_nxt = IDLE;
            rgb_nxt = rgb;
            tank_central_hit_nxt = 0;
            obstacle_hit_nxt = 0;
            xpos_block_nxt = xpos_t;
            ypos_block_nxt = ypos_t;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
            direction_for_enemy_nxt = 0;
            end
        end
    SHOT_0: begin
        if (counter == DELAY) begin 
            counter_nxt = 0;
            pos_bullet_nxt = pos_bullet + 1;
            end
        else begin
            counter_nxt = counter + 1;
            pos_bullet_nxt = pos_bullet;
            end
            
        if(ypos_block - pos_bullet - 5 <= UPPER_LIMIT) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if((ypos_block-pos_bullet-48 <= ypos_t_op)&&(xpos_block + 24 >= xpos_t_op)&&(xpos_block-24 <= xpos_t_op)&&(ypos_block-pos_bullet+5 >= ypos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK H 
        else if((ypos_block-pos_bullet-5 >= H_BUILDING_UP)&&(xpos_block+24 <= H_BUILDING_RIGHT)&&(xpos_block +24 >= H_BUILDING_LEFT)&&(ypos_block-pos_bullet-5 <= H_BUILDING_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK DOM 
        else if((ypos_block-pos_bullet-5 >= HOUSE_UP)&&(xpos_block+24 <= HOUSE_RIGHT)&&(xpos_block +24 >= HOUSE_LEFT)&&(ypos_block-pos_bullet-5 <= HOUSE_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK MUR 1 
        else if((ypos_block-pos_bullet-5 >= WALL1_UP)&&(xpos_block+24 <= WALL1_RIGHT)&&(xpos_block +24 >= WALL1_LEFT)&&(ypos_block-pos_bullet-5 <= WALL1_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK MUR 2 
        else if((ypos_block-pos_bullet-5 >= WALL2_UP)&&(xpos_block+24 <= WALL2_RIGHT)&&(xpos_block +24 >= WALL2_LEFT)&&(ypos_block-pos_bullet-5 <= WALL2_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK MUR 3 
        else if((ypos_block-pos_bullet-5 >= WALL3_UP)&&(xpos_block+24 <= WALL3_RIGHT)&&(xpos_block +24 >= WALL3_LEFT)&&(ypos_block-pos_bullet-5 <= WALL3_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        else if(vcount >= ypos_block - pos_bullet - 5 && vcount <= ypos_block - pos_bullet + 5 && hcount >= xpos_block + 22 && hcount <= xpos_block + 26) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+24;
        ypos_bullet_green_nxt = ypos_block - pos_bullet;
        direction_for_enemy_nxt = 1;
        end
    SHOT_1: begin
        if (counter == DELAY) begin 
            counter_nxt = 0;
            pos_bullet_nxt = pos_bullet + 1;
            end
        else begin
            counter_nxt = counter + 1;
            pos_bullet_nxt = pos_bullet;
            end
            
        if(ypos_block + pos_bullet + 27 >= LOWER_LIMIT) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if((ypos_block+pos_bullet + 5 >= ypos_t_op)&&(xpos_block + 24 >= xpos_t_op)&&(xpos_block-24 <= xpos_t_op)&&(ypos_block+pos_bullet-53 <= ypos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK H 
        else if((ypos_block+pos_bullet+27 >= H_BUILDING_UP)&&(xpos_block + 24 <= H_BUILDING_RIGHT)&&(xpos_block + 24 >= H_BUILDING_LEFT)&&(ypos_block+pos_bullet+5 <= H_BUILDING_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA DOM 
        else if((ypos_block+pos_bullet+27 >= HOUSE_UP)&&(xpos_block + 24 <= HOUSE_RIGHT)&&(xpos_block + 24 >= HOUSE_LEFT)&&(ypos_block+pos_bullet+5 <= HOUSE_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 1
        else if((ypos_block+pos_bullet+27 >= WALL1_UP)&&(xpos_block + 24 <= WALL1_RIGHT)&&(xpos_block + 24 >= WALL1_LEFT)&&(ypos_block+pos_bullet+5 <= WALL1_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 2
        else if((ypos_block+pos_bullet+27 >= WALL2_UP)&&(xpos_block + 24 <= WALL2_RIGHT)&&(xpos_block + 24 >= WALL2_LEFT)&&(ypos_block+pos_bullet+5 <= WALL2_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 3
        else if((ypos_block+pos_bullet+27 >= WALL3_UP)&&(xpos_block + 24 <= WALL3_RIGHT)&&(xpos_block + 24 >= WALL3_LEFT)&&(ypos_block+pos_bullet+5 <= WALL3_DOWN))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        else if(vcount >= ypos_block + pos_bullet + 27 && vcount <= ypos_block + pos_bullet + 37 && hcount >= xpos_block + 22 && hcount <= xpos_block + 26) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+24;
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
            
        if (xpos_block + pos_bullet + 27 >= RIGHT_LIMIT) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if((xpos_block+pos_bullet+5 >= xpos_t_op)&&(ypos_block + 24 >= ypos_t_op)&&(ypos_block-24 <= ypos_t_op)&&(xpos_block+pos_bullet-53 <= xpos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        //PRZESZKODA BUDYNEK H 
        else if((xpos_block+pos_bullet+27 >= H_BUILDING_LEFT)&&(ypos_block+24 <= H_BUILDING_DOWN)&&(ypos_block+24 >= H_BUILDING_UP)&&(xpos_block+pos_bullet+5 <= H_BUILDING_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA DOM
        else if((xpos_block+pos_bullet+27 >= HOUSE_LEFT)&&(ypos_block+24 <= HOUSE_DOWN)&&(ypos_block+24 >= HOUSE_UP)&&(xpos_block+pos_bullet+5 <= HOUSE_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 1
        else if((xpos_block+pos_bullet+27 >= WALL1_LEFT)&&(ypos_block+24 <= WALL1_DOWN)&&(ypos_block+24 >= WALL1_UP)&&(xpos_block+pos_bullet+5 <= WALL1_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 2
        else if((xpos_block+pos_bullet+27 >= WALL2_LEFT)&&(ypos_block+24 <= WALL2_DOWN)&&(ypos_block+24 >= WALL2_UP)&&(xpos_block+pos_bullet+5 <= WALL2_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 3
        else if((xpos_block+pos_bullet+27 >= WALL3_LEFT)&&(ypos_block+24 <= WALL3_DOWN)&&(ypos_block+24 >= WALL3_UP)&&(xpos_block+pos_bullet+5 <= WALL3_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        else if((hcount >= xpos_block + pos_bullet + 27) && (hcount <= xpos_block + pos_bullet + 37) && (vcount >= ypos_block + 22) && (vcount <= ypos_block + 26)) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+pos_bullet;
        ypos_bullet_green_nxt = ypos_block+24;
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
        
        if (xpos_block - pos_bullet -5 <= LEFT__LIMIT) begin state_nxt = IDLE; rgb_nxt = rgb; end
        else if((xpos_block-pos_bullet-48 <= xpos_t_op)&&(ypos_block + 24 >= ypos_t_op)&&(ypos_block-24 <= ypos_t_op)&&(xpos_block-pos_bullet+5 >= xpos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
         //PRZESZKODA BUDYNEK H 
        else if((xpos_block-pos_bullet-5 >= H_BUILDING_LEFT)&&(ypos_block+24 <= H_BUILDING_DOWN)&&(ypos_block+24 >= H_BUILDING_UP)&&(xpos_block-pos_bullet+5 <= H_BUILDING_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
         //PRZESZKODA DOM 
        else if((xpos_block-pos_bullet-5 >= HOUSE_LEFT)&&(ypos_block+24 <= HOUSE_DOWN)&&(ypos_block+24 >= HOUSE_UP)&&(xpos_block-pos_bullet+5 <= HOUSE_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 1
        else if((xpos_block-pos_bullet-5 >= WALL1_LEFT)&&(ypos_block+24 <= WALL1_DOWN)&&(ypos_block+24 >= WALL1_UP)&&(xpos_block-pos_bullet+5 <= WALL1_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 2
        else if((xpos_block-pos_bullet-5 >= WALL2_LEFT)&&(ypos_block+24 <= WALL2_DOWN)&&(ypos_block+24 >= WALL2_UP)&&(xpos_block-pos_bullet+5 <= WALL2_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        //PRZESZKODA MUR 3
        else if((xpos_block-pos_bullet-5 >= WALL3_LEFT)&&(ypos_block+24 <= WALL3_DOWN)&&(ypos_block+24 >= WALL3_UP)&&(xpos_block-pos_bullet+5 <= WALL3_RIGHT))  begin state_nxt = HIT_OBSTACLE; rgb_nxt = rgb; end
        else if((hcount >= xpos_block - pos_bullet - 5) && (hcount <= xpos_block - pos_bullet + 5) && (vcount >= ypos_block +22) && (vcount <= ypos_block + 27)) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block-pos_bullet;
        ypos_bullet_green_nxt = ypos_block+24;
        direction_for_enemy_nxt = 4;
        end
    HIT_TANK: begin
        state_nxt = IDLE;
        tank_central_hit_nxt = 1;
        rgb_nxt = rgb;
        xpos_bullet_green_nxt = 0;
        ypos_bullet_green_nxt = 0;
        direction_for_enemy_nxt = 0;
        if(HP_enemy_state == 0) HP_enemy_state_nxt=0;
        else HP_enemy_state_nxt = HP_enemy_state - 15;
    end
    HIT_OBSTACLE: begin
        state_nxt = IDLE;
        obstacle_hit_nxt = 1;
        rgb_nxt = rgb;
        xpos_bullet_green_nxt = 0;
        ypos_bullet_green_nxt = 0;
        direction_for_enemy_nxt = 0;
    end
    default: begin state_nxt = IDLE; rgb_nxt=rgb; end
    endcase
    end

endmodule
