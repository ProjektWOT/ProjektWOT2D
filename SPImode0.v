`timescale 1ns / 1ps

module spiMode0(
    input wire clk,                 
    input wire rst,                 
    input wire Data_mode,              
    input wire [7:0] Data_in,
    input wire MISO,
    
    output wire MOSI,
    output wire SCLK,
    output wire [7:0] Data_out,     
    output reg BUSY                 // Jeœli dane s¹ wysy³ane lub otrzymywane 
    );

	parameter [1:0] IDLE = 2'b00,
					INIT = 2'b01,
					RXTX = 2'b10,
				    DONE = 2'b11;

	reg [4:0] bit_counter, bit_counter_nxt ;							
	reg [7:0] rSR, rSR_nxt;						
	reg [7:0] wSR, wSR_nxt;						
	reg [1:0] State, State_nxt;				

	reg CE, CE_nxt, BUSY_nxt;										
													
	
	// Jeœli aktywne CE wyjœcie zegar - clk
	assign SCLK = (CE == 1) ? clk : 1'b0;
	assign MOSI = wSR[7];
	assign Data_out = rSR;
	

	// 	slave, master czyta dane na rising edge
	// slave, master zmieniaj¹ wyjœcia na falling edges
	always @(negedge clk) begin
		if(rst == 1)
		    wSR <= 8'h00;
		else
		    wSR <= wSR_nxt;  
	end
	

    always @(posedge clk) begin
        if(rst == 1)
            rSR <= 8'h00;
        else
            rSR <= rSR_nxt;
	end	
	
   
    // SPI Mode 0 FSM
    always @(negedge clk) begin
        if(rst == 1) begin
            CE <= 0;                    
            BUSY <= 0;                  
            bit_counter <= 4'h0;
            State <= IDLE;              
        end
        else begin
            CE <= CE_nxt;
            BUSY <= BUSY_nxt;
            bit_counter <= bit_counter_nxt;
            State <= State_nxt;
        end
     end
     
     always@* begin
        case(State)
            IDLE: begin
                wSR_nxt = Data_in;
                rSR_nxt = rSR;
                CE_nxt = 0;				    
                BUSY_nxt = 0;               
                bit_counter_nxt = 4'd0;                     
                // Rozpoczynanie transmisji danych po otrzymaniu sygna³u odbioru 
                State_nxt = (Data_mode == 1) ? INIT : IDLE;     
            end
            INIT: begin
                wSR_nxt = wSR;
                rSR_nxt = rSR;
                BUSY_nxt = 1;			    
                bit_counter_nxt = 4'h0;     
                CE_nxt = 0;                           
                State_nxt = RXTX;                    
            end
            RXTX: begin
                if(CE == 1) begin
                    wSR_nxt = {wSR[6:0], 1'b0};
                    rSR_nxt = {rSR[6:0], MISO};
                end
                else begin
                    wSR_nxt = wSR;
                    rSR_nxt = rSR;
                end
                BUSY_nxt = 1;						  
                bit_counter_nxt = bit_counter + 1;                      
   
                CE_nxt = (bit_counter >= 4'd8) ? 0 : 1;
                State_nxt = (bit_counter == 4'd8) ? DONE : RXTX;
            end
            DONE: begin
                wSR_nxt = wSR;
                rSR_nxt = rSR;
                CE_nxt  = 0;			 
                BUSY_nxt = 1;            
                bit_counter_nxt = 4'd0;                   
                State_nxt = IDLE;
            end
            default: begin
                wSR_nxt = wSR;
                rSR_nxt = rSR;
                CE_nxt  = CE;          
                BUSY_nxt = BUSY;        
                bit_counter_nxt = bit_counter;                    
                State_nxt = IDLE;
            end
        endcase
     end 
endmodule