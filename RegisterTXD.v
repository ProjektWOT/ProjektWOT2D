`timescale 1ns / 1ps

module RegisterTXD(
    input wire clk,
    input wire rst,
    input wire [9:0] XPosTankIn,
    input wire [9:0] YPosTankIn,
    output reg [7:0] DataPosOut,
    output reg TX_start
    );

//Registers and Localparams
//****************************************************************************************************************//
reg tx_start_nxt;
reg [9:0] HoldData_nxt, HoldData;
reg [7:0] DataPosOut_nxt;
reg [2:0] StepCounter, StepCounter_nxt;
reg [14:0] counter, counter_nxt;

reg [2:0] state, state_nxt;
localparam DELAY = 20000; // Transmittion time ~ 261[us] = ((1/38400)*10bit)[s]
localparam IDLE = 3'b111;
localparam StartTXD = 3'b000;
localparam Transmit = 3'b001;
localparam PreStart = 3'b010;
localparam Data1_Part1 = 3'b011;
localparam Data1_Part2 = 3'b100;
localparam Data2_Part1 = 3'b101;
localparam Data2_Part2 = 3'b110;

//Sequential data execute
//****************************************************************************************************************//
always @(posedge clk) begin
    if(rst) begin
        DataPosOut <= 0;
        TX_start <= 0;
        counter <= 0;
        state <= IDLE;
        StepCounter <= 0;
    end
    else begin
        state <= state_nxt;
        TX_start <= tx_start_nxt;
        counter <= counter_nxt;
        StepCounter <= StepCounter_nxt;
        
        DataPosOut <= DataPosOut_nxt;
        HoldData <= HoldData_nxt;
    end
end    
//****************************************************************************************************************//

//Counter
//****************************************************************************************************************//  
always @* begin
    if (counter >= DELAY) counter_nxt = 0;
    else        counter_nxt = counter + 1;
end
//****************************************************************************************************************//

//StateMachine
//****************************************************************************************************************//
always@* begin
    //For avoid the inferrings
    tx_start_nxt = TX_start;
    state_nxt = state;
    StepCounter_nxt = StepCounter;
    DataPosOut_nxt = DataPosOut;
    HoldData_nxt = HoldData;
    
    //3 states of machine for save start
    case(state)
    IDLE: begin
        tx_start_nxt = 0;
        StepCounter_nxt = 0;
        state_nxt = PreStart;
    end
    PreStart: begin
        state_nxt = StartTXD;
        HoldData_nxt = {2'b00, 8'hFF};
        StepCounter_nxt = StepCounter + 1;
    end
    StartTXD: begin
        tx_start_nxt = 1;
        state_nxt = Transmit; 
        DataPosOut_nxt = HoldData[7:0];
    end
    
    //Main state
    Transmit: begin
        tx_start_nxt = 0;
        if(counter != DELAY) state_nxt = Transmit;
        else begin
            if(StepCounter <= 3) state_nxt = PreStart;
            else if(StepCounter == 4) state_nxt = Data1_Part1;
            else if(StepCounter == 5) state_nxt = Data1_Part2;
            else if(StepCounter == 6) state_nxt = Data2_Part1;
            else if(StepCounter == 7) state_nxt = Data2_Part2;
            else state_nxt = IDLE;
        end
    end
    
    //Useable data part
    Data1_Part1: begin
        state_nxt = StartTXD;
        HoldData_nxt = XPosTankIn;
        StepCounter_nxt = StepCounter + 1;
    end
    Data1_Part2: begin
        state_nxt = StartTXD;
        HoldData_nxt = {7'b00000, HoldData[9:8]};
        StepCounter_nxt = StepCounter + 1;
    end
    Data2_Part1: begin
        state_nxt = StartTXD;
        HoldData_nxt = YPosTankIn;
        StepCounter_nxt = StepCounter + 1;
    end
    Data2_Part2: begin
        state_nxt = StartTXD;
        HoldData_nxt = {7'b00000, HoldData[9:8]};
        StepCounter_nxt = StepCounter + 1;
    end
    default: state_nxt = IDLE;
    endcase
end
endmodule
