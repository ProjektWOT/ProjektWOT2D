`timescale 1ns / 1ps

module RegisterRXD(
    input wire clk,
    input wire rst,
    input wire rx_done,
    input wire [7:0] current_rx,
    
    output wire [15:0] X_tank_pos,
    output wire [15:0] Y_tank_pos,
    output wire [9:0] xpos_bullet_green_fromUART,
    output wire [9:0] ypos_bullet_green_fromUART,
    output wire [2:0] direction_for_enemy_fromUART,
    output wire tank_our_hit_fromUART,
    output wire obstacle_hit_fromUART,
    output wire [1:0] direction_tank_fromUART,
    output wire [7:0] HP_our_state_fromUART
    );

//Registers and Localparams
//****************************************************************************************************************//
localparam PreStart = 1'b0;
localparam Receiving = 1'b1;

reg state, state_nxt;
reg [3:0] counter, counter_nxt;
reg [7:0] current_rx_nxt;
reg [31:0] PreStartBytes, PreStartBytes_nxt;

reg [7:0] DataRxTemp1 ,DataRxTemp1_nxt;
reg [7:0] DataRxTemp2 ,DataRxTemp2_nxt;
reg [7:0] DataRxTemp3 ,DataRxTemp3_nxt;
reg [7:0] DataRxTemp4 ,DataRxTemp4_nxt;
reg [15:0] Data_rx1, Data_rx1_nxt;
reg [15:0] Data_rx2, Data_rx2_nxt;
reg [9:0] Data_rx3, Data_rx3_nxt;
reg [9:0] Data_rx4, Data_rx4_nxt;
reg [7:0] Data_rx5, Data_rx5_nxt;
reg [7:0] Data_rx6, Data_rx6_nxt;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//   
always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        Data_rx1 <= 0;
        Data_rx2 <= 0;
        Data_rx3 <= 0;
        Data_rx4 <= 0;
        Data_rx5 <= 0;
        Data_rx6 <= 0;
        state <= PreStart;
        PreStartBytes <= 0;
        DataRxTemp1 <= 0;
        DataRxTemp2 <= 0;
        DataRxTemp3 <= 0;
        DataRxTemp4 <= 0;
        end
    else begin
        counter <= counter_nxt;
        Data_rx1 <= Data_rx1_nxt;
        Data_rx2 <= Data_rx2_nxt;
        Data_rx3 <= Data_rx3_nxt;
        Data_rx4 <= Data_rx4_nxt;
        Data_rx5 <= Data_rx5_nxt;
        Data_rx6 <= Data_rx6_nxt;
        state <= state_nxt;
        PreStartBytes <= PreStartBytes_nxt;
        DataRxTemp1 <= DataRxTemp1_nxt;
        DataRxTemp2 <= DataRxTemp2_nxt;
        DataRxTemp3 <= DataRxTemp3_nxt;
        DataRxTemp4 <= DataRxTemp4_nxt;
        end
    end
//****************************************************************************************************************// 

//Logic and StateMachine
//****************************************************************************************************************//
always @* begin
    //For avoid the inferrings
    counter_nxt = counter;
    PreStartBytes_nxt = PreStartBytes;
    state_nxt = state;
    Data_rx1_nxt = Data_rx1;
    Data_rx2_nxt = Data_rx2;
    Data_rx3_nxt = Data_rx3;
    Data_rx4_nxt = Data_rx4;
    Data_rx5_nxt = Data_rx5;
    Data_rx6_nxt = Data_rx6;
    DataRxTemp1_nxt = DataRxTemp1;
    DataRxTemp2_nxt = DataRxTemp2;
    DataRxTemp3_nxt = DataRxTemp3;
    DataRxTemp4_nxt = DataRxTemp4;
    
    //States of Machine
    case(state)
    PreStart: begin
        counter_nxt = 0;
        if(rx_done) begin
            PreStartBytes_nxt = {current_rx, PreStartBytes[31:8]};
            state_nxt = Receiving;
        end
        else state_nxt = PreStart;
    end
    Receiving: begin
        if(PreStartBytes != 32'hFFFFFFFF) state_nxt = PreStart;
        else begin
            if(~rx_done) state_nxt = Receiving;
            else begin
                if(counter == 0) begin
                    DataRxTemp1_nxt = current_rx;
                    state_nxt = Receiving;
                end
                else if(counter == 1) begin
                    Data_rx1_nxt = {current_rx, DataRxTemp1};
                    state_nxt = Receiving;
                end
                else if(counter == 2) begin
                    DataRxTemp2_nxt = current_rx;
                    state_nxt = Receiving;
                end
                else if(counter == 3) begin
                    Data_rx2_nxt = {current_rx, DataRxTemp2};
                    state_nxt = Receiving;
                end
                else if(counter == 4) begin
                    DataRxTemp3_nxt = current_rx;
                    state_nxt = Receiving;
                    end
                else if(counter == 5) begin
                    Data_rx3_nxt = {current_rx, DataRxTemp3};
                    state_nxt = Receiving;
                    end
                else if(counter == 6) begin
                    DataRxTemp4_nxt = current_rx;
                    state_nxt = Receiving;
                    end
                else if(counter == 7) begin
                    Data_rx4_nxt = {current_rx, DataRxTemp4};
                    state_nxt = Receiving;
                    end
                else if(counter == 8) begin
                    Data_rx5_nxt = current_rx;
                    state_nxt = Receiving;
                end
                else if(counter == 9) begin
                    Data_rx6_nxt = current_rx;
                    state_nxt = PreStart;
                    PreStartBytes_nxt = 32'h00000000; //Last data receive and than need to reset the PreStart data
                    end               
                //Others cases
                else begin
                    state_nxt = PreStart;
                    PreStartBytes_nxt = 32'h00000000;
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
assign X_tank_pos = Data_rx1;
assign Y_tank_pos = Data_rx2;
assign xpos_bullet_green_fromUART = Data_rx3[9:0];
assign ypos_bullet_green_fromUART = Data_rx4[9:0];
assign HP_our_state_fromUART = Data_rx5;
assign direction_for_enemy_fromUART = Data_rx6[3:1];
assign tank_our_hit_fromUART = Data_rx6[0];
assign direction_tank_fromUART = Data_rx6[5:4];
assign obstacle_hit_fromUART = Data_rx6[6];
endmodule
