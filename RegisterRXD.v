`timescale 1ns / 1ps

module RegisterRXD(
    input wire clk,
    input wire rst,
    input wire rx_done,
    input wire [7:0] current_rx,
    
    output wire [15:0] X_tank_pos,
    output wire [15:0] Y_tank_pos
    );

localparam PreStart = 1'b0;
localparam Receiving = 1'b1;

reg state, state_nxt;
reg [1:0] counter, counter_nxt;
reg [7:0] current_rx_nxt;
reg [7:0] DataRxTemp1 ,DataRxTemp_nxt1;
reg [7:0] DataRxTemp2 ,DataRxTemp_nxt2;
reg [15:0] Data_rx1, Data_rx_nxt1;
reg [15:0] Data_rx2, Data_rx_nxt2;
reg [31:0] PreStartBytes, PreStartBytes_nxt;
    
always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        Data_rx1 <= 0;
        Data_rx2 <= 0;
        state <= PreStart;
        PreStartBytes <= 0;
        DataRxTemp1 <= 0;
        DataRxTemp2 <= 0;
        end
    else begin
        counter <= counter_nxt;
        Data_rx1 <= Data_rx_nxt1;
        Data_rx2 <= Data_rx_nxt2;
        state <= state_nxt;
        PreStartBytes <= PreStartBytes_nxt;
        DataRxTemp1 <= DataRxTemp_nxt1;
        DataRxTemp2 <= DataRxTemp_nxt2;
        end
    end
    
always @* begin
    counter_nxt = counter;
    PreStartBytes_nxt = PreStartBytes;
    state_nxt = state;
    Data_rx_nxt1 = Data_rx1;
    Data_rx_nxt2 = Data_rx2;
    DataRxTemp_nxt1 = DataRxTemp1;
    DataRxTemp_nxt2 = DataRxTemp2;
    
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
            if(PreStartBytes == 32'hFFFFFFFF) begin
                if(rx_done) begin 
                    if(counter == 0) begin
                        DataRxTemp_nxt1 = current_rx;
                        state_nxt = Receiving;
                    end
                    else if(counter == 1) begin
                        Data_rx_nxt1 = {current_rx, DataRxTemp1};
                        state_nxt = Receiving;
                    end
                    else if(counter == 2) begin
                        DataRxTemp_nxt2 = current_rx;
                        state_nxt = Receiving;
                    end
                    else if(counter == 3) begin
                        Data_rx_nxt2 = {current_rx, DataRxTemp2};
                        state_nxt = PreStart;
                        PreStartBytes_nxt = 32'h00000000;
                    end
                    else begin
                        state_nxt = PreStart;
                        PreStartBytes_nxt = 32'h00000000;
                    end
                    counter_nxt = counter + 1;
                end
                else state_nxt = Receiving;
            end
            else state_nxt = PreStart;
        end
    endcase
    end
    
assign X_tank_pos = Data_rx1;
assign Y_tank_pos = Data_rx2;
endmodule
