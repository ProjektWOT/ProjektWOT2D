`timescale 1ns / 1ps

module spiCtrl(
	input wire clk,
	input wire rst,
	input wire Data_mode,
	input wire BUSY,                   // Jeœli aktwyne to transfer danych jest w toku
	input wire [7:0] Data_in,
	input wire [7:0] Data_rx,          // Ostatni otrzymany bajt
	
	output reg CS,                     // aktywny stanem niskim
	output reg getByte,                // inicjuje transfer danych w spimode0
	output reg [7:0] Data_send,
	output reg [39:0] Data_out      
    );

	parameter [2:0] IDLE  = 3'b000,
					INIT  = 3'b001,
					WAIT  = 3'b010,
					CHECK = 3'b011,
					DONE  = 3'b100;
    parameter byteEndVal  = 3'b101;				         // Nliczba bajtów do wys³ania/otrzymania
    
	reg [2:0] State, State_nxt;
	reg [2:0] byte_counter, byte_counter_nxt;
	reg [39:0] tmpSR, tmpSR_nxt, Data_out_nxt;
	reg CS_nxt, getByte_nxt;
	reg [7:0] Data_send_nxt;
	
	always @(negedge clk) begin
	    if(rst == 1) begin
            CS <= 1'b1;
			getByte <= 1'b0;
			Data_send <= 8'h00;
			tmpSR <= 40'h0000000000;
		    Data_out <= 40'h0000000000;
			byte_counter <= 3'd0;
			State <= IDLE;
		end
		else begin
		    CS <= CS_nxt;
            getByte <= getByte_nxt;
            Data_send <= Data_send_nxt;
            tmpSR <= tmpSR_nxt;
            Data_out <= Data_out_nxt;
            byte_counter <= byte_counter_nxt;
            State <= State_nxt;
		end
	end
	
	always@* begin
	    case(State)
	        IDLE: begin
                CS_nxt = 1;                                 
                getByte_nxt = 0;                            // Nie oczekuj danych
                Data_send_nxt = 8'h00;                      // puste dane do wys³ania
                tmpSR_nxt = 40'h0000000000;                 
                Data_out_nxt = Data_out;       
                byte_counter_nxt = 3'd0;
            // Rozpoczynanie transmisji danych po otrzymaniu sygna³u odbioru 
                State_nxt = (Data_mode == 1) ? INIT : IDLE;
            end
            INIT: begin
                CS_nxt = 0;								
                getByte_nxt = 1;                        // Inicjalizacja transferu danych
                Data_send_nxt = Data_in;                
                tmpSR_nxt = tmpSR;                       
                Data_out_nxt = Data_out;                  
                if(BUSY == 1) begin
                    State_nxt = WAIT;
                    byte_counter_nxt = byte_counter + 1;  
                end
                else begin
                    State_nxt = INIT;
                    byte_counter_nxt = byte_counter;
                end                
            end
            WAIT: begin
                CS_nxt = 0;								
                getByte_nxt = 0;                        // Trwa oczekiwanie na dane
                Data_send_nxt = Data_send;
                tmpSR_nxt = tmpSR;                       
                Data_out_nxt = Data_out;                            
                byte_counter_nxt = byte_counter;                                       
                //Pobierz dane, gdy zakoñczone odczytywanie bajtu - CHECK
                State_nxt = (BUSY == 0) ? CHECK : WAIT;
            end
            CHECK: begin
                CS_nxt = 0;								
                getByte_nxt = 0;                        //  Nie oczekuj danych
                Data_send_nxt = Data_send;              
                tmpSR_nxt = {tmpSR[31:0], Data_rx};
                Data_out_nxt = Data_out;                
                byte_counter_nxt = byte_counter; 
                // Odczytano bajty - DONE
                State_nxt = (byte_counter == 3'd5) ? DONE : INIT;                        
            end
            DONE: begin
                CS_nxt = 1;							
                getByte_nxt = 0;                    // Nie oczekuj danych
                Data_send_nxt = 8'h00;                    // Wyczyœæ wysy³ane dane
                tmpSR_nxt = tmpSR;                    
                Data_out_nxt[39:0] = tmpSR[39:0];        // Zaktualizuj dane wyjœciowe
                byte_counter_nxt = byte_counter;                    
                State_nxt = (Data_mode == 0) ? IDLE : DONE;                                   
            end
            default: begin
                CS_nxt = CS;							
                getByte_nxt = getByte;                    
                Data_send_nxt = Data_send;                    
                tmpSR_nxt = tmpSR;                    
                Data_out_nxt = Data_out;        
                byte_counter_nxt = byte_counter;                        
                State_nxt = IDLE;          
            end
	    endcase
	end	
endmodule
