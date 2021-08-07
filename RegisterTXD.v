`timescale 1ns / 1ps

module RegisterTXD(
    input wire clk,
    input wire rst,
    input wire [9:0] XPosIn,
    input wire [9:0] YPosIn,
    output reg [7:0] PosOut,
    output reg TX_start
    );

reg tx_start_nxt;
reg [9:0] XPosInHold_nxt, XPosInHold;
reg [7:0] PosOut_nxt;
reg [25:0] counter, counter_nxt;

localparam DELAY = 20000;

always @(posedge clk) begin
    if(rst) begin
    PosOut <= 0;
    TX_start <= 0;
    counter <= 0;
    end
    else begin
    PosOut <= PosOut_nxt;
    XPosInHold <= XPosInHold_nxt;
    counter <= counter_nxt;
    TX_start <= tx_start_nxt;
    end
end    
    
always @* begin
        if (counter == DELAY*8) counter_nxt = 0;
        else counter_nxt = counter + 1;
    end
    
always @* begin
//Start bytes 4*FF
    if(counter == 0) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = PosOut;
        tx_start_nxt = 0;
        end
    else if (counter == 1) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 1;
    end
    else if(counter < DELAY*1) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 0;
        end
    else if (counter == DELAY*1) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 1;
        end
    else if(counter < DELAY*2) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 0;
        end
    else if (counter == DELAY*2) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 1;
        end
    else if(counter < DELAY*3) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 0;
        end
    else if (counter == DELAY*3) begin   
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 1;
        end          
    else if(counter < ((DELAY*4) - 1)) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = 8'hFF;
        tx_start_nxt = 0;
        end

//Data_1
//Loading Data_1
    else if (counter == ((DELAY*4) - 1)) begin
        XPosInHold_nxt = XPosIn;
        PosOut_nxt = XPosInHold[7:0];
        tx_start_nxt = 0;
        end
//Data_1 part 1
    else if (counter == DELAY*4) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = XPosInHold[7:0];
        tx_start_nxt = 1;
        end
    else if(counter < DELAY*5) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = XPosInHold[7:0];
        tx_start_nxt = 0;
        end     
//Data_1 part 2
    else if (counter == DELAY*5) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = {5'b00000, XPosInHold[9:8]};
        tx_start_nxt = 1;
        end
    else if (counter < ((DELAY*6)-1)) begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = {5'b00000, XPosInHold[9:8]};
        tx_start_nxt = 0;
        end
        
        //Data_2
        //Loading Data_2
            else if (counter == ((DELAY*6) - 1)) begin
                XPosInHold_nxt = YPosIn;
                PosOut_nxt = XPosInHold[7:0];
                tx_start_nxt = 0;
                end
        //Data_2 part 1
            else if (counter == DELAY*6) begin
                XPosInHold_nxt = XPosInHold;
                PosOut_nxt = XPosInHold[7:0];
                tx_start_nxt = 1;
                end
            else if(counter < DELAY*7) begin
                XPosInHold_nxt = XPosInHold;
                PosOut_nxt = XPosInHold[7:0];
                tx_start_nxt = 0;
                end     
        //Data_2 part 2
            else if (counter == DELAY*7) begin
                XPosInHold_nxt = XPosInHold;
                PosOut_nxt = {5'b00000, XPosInHold[9:8]};
                tx_start_nxt = 1;
                end
            else if (counter <= DELAY*8) begin
                XPosInHold_nxt = XPosInHold;
                PosOut_nxt = {5'b00000, XPosInHold[9:8]};
                tx_start_nxt = 0;
                end

//Diffrent cases                     
    else begin
        XPosInHold_nxt = XPosInHold;
        PosOut_nxt = PosOut;
        tx_start_nxt = 0;
        end
    end
endmodule