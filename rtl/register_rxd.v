`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module register_rxd(
    input wire clk,
    input wire rst,
    input wire rx_done,
    input wire [7:0] current_rx,
    
    output wire [15:0] xpos_tank_uart_out,
    output wire [15:0] ypos_tank_uart_out,
    output wire [9:0] xpos_bullet_our_uart_out,
    output wire [9:0] ypos_bullet_our_uart_out,
    output wire [2:0] direction_for_enemy_uart_out,
    output wire tank_our_hit_uart_out,
    output wire obstacle_hit_uart_out,
    output wire [1:0] direction_tank_uart_out,
    output wire [7:0] hp_our_uart_out
);

//Registers and Localparams
//****************************************************************************************************************//
reg state, state_nxt;
reg [3:0] counter, counter_nxt;
reg [7:0] current_rx_nxt;
reg [31:0] prestart_bytes, prestart_bytes_nxt;

reg [7:0] data_rx_temp1, data_rx_temp1_nxt;
reg [7:0] data_rx_temp2, data_rx_temp2_nxt;
reg [7:0] data_rx_temp3, data_rx_temp3_nxt;
reg [7:0] data_rx_temp4, data_rx_temp4_nxt;
reg [15:0] data_rx1, data_rx1_nxt;
reg [15:0] data_rx2, data_rx2_nxt;
reg [9:0]  data_rx3, data_rx3_nxt;
reg [9:0]  data_rx4, data_rx4_nxt;
reg [7:0]  data_rx5, data_rx5_nxt;
reg [7:0]  data_rx6, data_rx6_nxt;

//STATES
localparam PRESTART = 1'b0;
localparam RECEIVING = 1'b1;

localparam FOUR_BYTES   = 32'hFFFFFFFF;
localparam PRESTARTBYTE = 32'h00000000;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//   
always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        state <= PRESTART;
        prestart_bytes <= 0;
        {data_rx1, data_rx2} <= 0;
        {data_rx3, data_rx4} <= 0;
        {data_rx5, data_rx6} <= 0;
        {data_rx_temp1, data_rx_temp2, data_rx_temp3, data_rx_temp4} <= 0;
    end
    else begin
        state <= state_nxt;
        counter <= counter_nxt;
        prestart_bytes <= prestart_bytes_nxt;
        data_rx_temp1 <= data_rx_temp1_nxt;
        data_rx_temp2 <= data_rx_temp2_nxt;
        data_rx_temp3 <= data_rx_temp3_nxt;
        data_rx_temp4 <= data_rx_temp4_nxt;
        data_rx1 <= data_rx1_nxt;
        data_rx2 <= data_rx2_nxt;
        data_rx3 <= data_rx3_nxt;
        data_rx4 <= data_rx4_nxt;
        data_rx5 <= data_rx5_nxt;
        data_rx6 <= data_rx6_nxt;   
    end
end
//****************************************************************************************************************// 

//Logic and StateMachine
//****************************************************************************************************************//
always @* begin
    //To avoid the inferrings
    counter_nxt = counter;
    prestart_bytes_nxt = prestart_bytes;
    state_nxt = state;
    data_rx1_nxt = data_rx1;
    data_rx2_nxt = data_rx2;
    data_rx3_nxt = data_rx3;
    data_rx4_nxt = data_rx4;
    data_rx5_nxt = data_rx5;
    data_rx6_nxt = data_rx6;
    data_rx_temp1_nxt = data_rx_temp1;
    data_rx_temp2_nxt = data_rx_temp2;
    data_rx_temp3_nxt = data_rx_temp3;
    data_rx_temp4_nxt = data_rx_temp4;
    
    //States of Machine
    case(state)
        PRESTART: begin
            counter_nxt = 0;
            if(rx_done) begin
                prestart_bytes_nxt = {current_rx, prestart_bytes[31:8]};
                state_nxt = RECEIVING;
            end
            else state_nxt = PRESTART;
        end
        RECEIVING: begin
            if(prestart_bytes != FOUR_BYTES) state_nxt = PRESTART;
            else begin
                if(~rx_done) state_nxt = RECEIVING;
                else begin
                    if(counter == 0) begin
                        data_rx_temp1_nxt = current_rx;
                        state_nxt = RECEIVING;
                    end
                    else if(counter == 1) begin
                        data_rx1_nxt = {current_rx, data_rx_temp1};
                        state_nxt = RECEIVING;
                    end
                    else if(counter == 2) begin
                        data_rx_temp2_nxt = current_rx;
                        state_nxt = RECEIVING;
                    end
                    else if(counter == 3) begin
                        data_rx2_nxt = {current_rx, data_rx_temp2};
                        state_nxt = RECEIVING;
                    end
                    else if(counter == 4) begin
                        data_rx_temp3_nxt = current_rx;
                        state_nxt = RECEIVING;
                        end
                    else if(counter == 5) begin
                        data_rx3_nxt = {current_rx, data_rx_temp3};
                        state_nxt = RECEIVING;
                        end
                    else if(counter == 6) begin
                        data_rx_temp4_nxt = current_rx;
                        state_nxt = RECEIVING;
                        end
                    else if(counter == 7) begin
                        data_rx4_nxt = {current_rx, data_rx_temp4};
                        state_nxt = RECEIVING;
                        end
                    else if(counter == 8) begin
                        data_rx5_nxt = current_rx;
                        state_nxt = RECEIVING;
                    end
                    else if(counter == 9) begin
                        data_rx6_nxt = current_rx;
                        state_nxt = PRESTART;
                        prestart_bytes_nxt = PRESTARTBYTE; //Last data receive and than need to reset the PreStart data
                        end               
                    //Others cases
                    else begin
                        state_nxt = PRESTART;
                        prestart_bytes_nxt = PRESTARTBYTE;
                    end
                    counter_nxt = counter + 1;
                end
            end
        end
    endcase
end
//****************************************************************************************************************// 
 
//Outputs
//****************************************************************************************************************// 
assign xpos_tank_uart_out = data_rx1;
assign ypos_tank_uart_out = data_rx2;
assign xpos_bullet_our_uart_out = data_rx3[9:0];
assign ypos_bullet_our_uart_out = data_rx4[9:0];
assign hp_our_uart_out = data_rx5;
assign direction_for_enemy_uart_out = data_rx6[3:1];
assign tank_our_hit_uart_out = data_rx6[0];
assign direction_tank_uart_out = data_rx6[5:4];
assign obstacle_hit_uart_out = data_rx6[6];

endmodule
