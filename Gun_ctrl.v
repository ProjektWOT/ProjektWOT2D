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
    output reg [9:0] xpos_bullet_green,
    output reg [9:0] ypos_bullet_green
);

reg [11:0] rgb_nxt;
reg [16:0] counter,  counter_nxt;
reg [10:0] pos_bullet, pos_bullet_nxt;
reg [9:0] xpos_block, ypos_block, xpos_block_nxt, ypos_block_nxt;
reg [9:0] xpos_bullet_green_nxt, ypos_bullet_green_nxt;
reg tank_central_hit_nxt;
localparam DELAY = 130000;
localparam RELOAD = 195000000; //195 000 000

localparam LOWER_LIMIT = 768;
localparam UPPER_LIMIT = 2;
localparam RIGHT_LIMIT = 768;
localparam LEFT__LIMIT = 2;

reg [2:0] state, state_nxt;
localparam IDLE = 3'b000;
localparam SHOT_0 = 3'b001;
localparam SHOT_1 = 3'b010;
localparam SHOT_3 = 3'b011;
localparam SHOT_2 = 3'b100;
localparam HIT_TANK = 3'b101;

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
        {counter, tank_central_hit, xpos_bullet_green, ypos_bullet_green} <= 0;
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
    xpos_bullet_green_nxt = xpos_bullet_green;
    ypos_bullet_green_nxt = ypos_bullet_green;
    case(state)
    IDLE: begin
        if(select == 1 && left_click == 1) begin
            state_nxt = SHOT_0 + direction_bullet;
            tank_central_hit_nxt = 0;
            xpos_block_nxt = xpos_t;
            ypos_block_nxt = ypos_t;
            counter_nxt = 0;
            pos_bullet_nxt = 0;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
            rgb_nxt = rgb;
        end
        else begin
            counter_nxt = 0;
            pos_bullet_nxt = 0;
            state_nxt = IDLE;
            rgb_nxt = rgb;
            tank_central_hit_nxt = 0;
            xpos_block_nxt = xpos_t;
            ypos_block_nxt = ypos_t;
            xpos_bullet_green_nxt = 0;
            ypos_bullet_green_nxt = 0;
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
        else if((ypos_block-pos_bullet-48 <= ypos_t_op)&&(xpos_block + 24 >= xpos_t_op)&&(xpos_block-24 <= xpos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        else if(vcount >= ypos_block - pos_bullet - 5 && vcount <= ypos_block - pos_bullet + 5 && hcount >= xpos_block + 22 && hcount <= xpos_block + 26) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+24;
        ypos_bullet_green_nxt = ypos_block - pos_bullet;
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
        else if((ypos_block+pos_bullet + 5 >= ypos_t_op)&&(xpos_block + 24 >= xpos_t_op)&&(xpos_block-24 <= xpos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        else if(vcount >= ypos_block + pos_bullet + 27 && vcount <= ypos_block + pos_bullet + 37 && hcount >= xpos_block + 22 && hcount <= xpos_block + 26) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+24;
        ypos_bullet_green_nxt = ypos_block + pos_bullet;
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
        else if((xpos_block+pos_bullet+5 >= xpos_t_op)&&(ypos_block + 24 >= ypos_t_op)&&(ypos_block-24 <= ypos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        else if((hcount >= xpos_block + pos_bullet + 27) && (hcount <= xpos_block + pos_bullet + 37) && (vcount >= ypos_block + 22) && (vcount <= ypos_block + 26)) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block+pos_bullet;
        ypos_bullet_green_nxt = ypos_block+24;
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
        else if((xpos_block-pos_bullet-48 <= xpos_t_op)&&(ypos_block + 24 >= ypos_t_op)&&(ypos_block-24 <= ypos_t_op)) begin state_nxt = HIT_TANK; rgb_nxt = rgb; end
        else if((hcount >= xpos_block - pos_bullet - 5) && (hcount <= xpos_block - pos_bullet + 5) && (vcount >= ypos_block +22) && (vcount <= ypos_block + 27)) rgb_nxt = 12'h000;
        else rgb_nxt = rgb;
        xpos_bullet_green_nxt = xpos_block-pos_bullet;
        ypos_bullet_green_nxt = ypos_block+24;
        end
    HIT_TANK: begin
        state_nxt = IDLE;
        tank_central_hit_nxt = 1;
        rgb_nxt = rgb;
        xpos_bullet_green_nxt = 0;
        ypos_bullet_green_nxt = 0;
    end
    default: begin state_nxt = IDLE; rgb_nxt=rgb; end
    endcase
    end

endmodule
