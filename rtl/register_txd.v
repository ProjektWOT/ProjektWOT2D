`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module register_txd(
    input wire clk,
    input wire rst,
    input wire [9:0] xpos_tank_uart_in,
    input wire [9:0] ypos_tank_uart_in,
    input wire [9:0] xpos_bullet_our_uart_in,
    input wire [9:0] ypos_bullet_our_uart_in,
    input wire [2:0] direction_for_enemy_uart_in,
    input wire tank_our_hit_uart_in,
    input wire obstacle_hit_uart_in,
    input wire [1:0] direction_tank_uart_in,
    input wire [7:0] hp_enemy_uart_in,
    
    output reg [7:0] data_out,
    output reg tx_start
);

//Registers and Localparams
//****************************************************************************************************************//
reg tx_start_nxt;
reg [9:0] hold_data_nxt, hold_data;
reg [7:0] data_out_nxt;
reg [3:0] step_counter, step_counter_nxt;
reg [14:0] counter, counter_nxt;

//STATES
reg [3:0] state, state_nxt;
localparam DELAY = 18620; // Transmittion time ~ 261[us] = ((1/38400)*10bit)[s]
localparam IDLE = 4'b0111;
localparam START_TXD = 4'b0000;
localparam TRANSMIT = 4'b0001;
localparam PRESTART = 4'b0010;
localparam DATA1_PART1 = 4'b0011;
localparam DATA1_PART2 = 4'b0100;
localparam DATA2_PART1 = 4'b0101;
localparam DATA2_PART2 = 4'b0110;
localparam DATA3_PART1 = 4'b1000;
localparam DATA3_PART2 = 4'b1001;
localparam DATA4_PART1 = 4'b1010;
localparam DATA4_PART2 = 4'b1011;
localparam DATA5_PART1 = 4'b1100;
localparam DATA6_PART1 = 4'b1101;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//
always @(posedge clk) begin
    if(rst) begin
        state <= IDLE;
        data_out <= 0;
        tx_start <= 0;
        counter <= 0;
        step_counter <= 0;
    end
    else begin
        state <= state_nxt;
        tx_start <= tx_start_nxt;
        counter <= counter_nxt;
        step_counter <= step_counter_nxt;
        
        data_out <= data_out_nxt;
        hold_data <= hold_data_nxt;
    end
end    
//****************************************************************************************************************//

//Counter
//****************************************************************************************************************//  
always @* begin
    if (counter >= DELAY) counter_nxt = 0;
    else counter_nxt = counter + 1;
end
//****************************************************************************************************************//

//StateMachine
//****************************************************************************************************************//
always@* begin
    //For avoid the inferrings
    tx_start_nxt = tx_start;
    state_nxt = state;
    step_counter_nxt = step_counter;
    data_out_nxt = data_out;
    hold_data_nxt = hold_data;
    
    //3 states of machine for save start
    case(state)
        IDLE: begin
            tx_start_nxt = 0;
            step_counter_nxt = 0;
            state_nxt = PRESTART;
        end
        PRESTART: begin
            state_nxt = START_TXD;
            hold_data_nxt = {2'b00, 8'hFF};
            step_counter_nxt = step_counter + 1;
        end
        START_TXD: begin
            tx_start_nxt = 1;
            state_nxt = TRANSMIT; 
            data_out_nxt = hold_data[7:0];
        end
        
        //Main state
        TRANSMIT: begin
            tx_start_nxt = 0;
            if(counter != DELAY) state_nxt = TRANSMIT;
            else begin
                if(step_counter <= 3) state_nxt = PRESTART;
                else if(step_counter == 4) state_nxt = DATA1_PART1;
                else if(step_counter == 5) state_nxt = DATA1_PART2;
                else if(step_counter == 6) state_nxt = DATA2_PART1;
                else if(step_counter == 7) state_nxt = DATA2_PART2;
                else if(step_counter == 8) state_nxt = DATA3_PART1;
                else if(step_counter == 9) state_nxt = DATA3_PART2;
                else if(step_counter == 10)state_nxt = DATA4_PART1;
                else if(step_counter == 11)state_nxt = DATA4_PART2;
                else if(step_counter == 12)state_nxt = DATA5_PART1;
                else if(step_counter == 13)state_nxt = DATA6_PART1;
                else state_nxt = IDLE;
            end
        end
        
        //Useable data part
        DATA1_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = xpos_tank_uart_in;
            step_counter_nxt = step_counter + 1;
        end
        DATA1_PART2: begin
            state_nxt = START_TXD;
            hold_data_nxt = {7'b00000, hold_data[9:8]};
            step_counter_nxt = step_counter + 1;
        end
        DATA2_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = ypos_tank_uart_in;
            step_counter_nxt = step_counter + 1;
        end
        DATA2_PART2: begin
            state_nxt = START_TXD;
            hold_data_nxt = {7'b00000, hold_data[9:8]};
            step_counter_nxt = step_counter + 1;
        end
        
        DATA3_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = xpos_bullet_our_uart_in;
            step_counter_nxt = step_counter + 1;
        end
        DATA3_PART2: begin
            state_nxt = START_TXD;
            hold_data_nxt = {7'b00000, hold_data[9:8]};
            step_counter_nxt = step_counter + 1;
        end
        DATA4_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = ypos_bullet_our_uart_in;
            step_counter_nxt = step_counter + 1;
        end
        DATA4_PART2: begin
            state_nxt = START_TXD;
            hold_data_nxt = {7'b00000, hold_data[9:8]};
            step_counter_nxt = step_counter + 1;
        end
        DATA5_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = {hp_enemy_uart_in};
            step_counter_nxt = step_counter + 1;
        end
        DATA6_PART1: begin
            state_nxt = START_TXD;
            hold_data_nxt = {1'b0, obstacle_hit_uart_in, direction_tank_uart_in, direction_for_enemy_uart_in, tank_our_hit_uart_in};
            step_counter_nxt = step_counter + 1;
        end
        default: state_nxt = IDLE;
    endcase
end

endmodule