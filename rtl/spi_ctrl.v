`timescale 1ns / 1ps
/*
We used program from Xilinx forum and edited it to our needs.
////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    spiCtrl
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This component manages all data transfer requests,
//					 and manages the data bytes being sent to the PmodJSTK.
//
//  				 For more information on the contents of the bytes being sent/received 
//					 see page 2 in the PmodJSTK reference manual found at the link provided
//					 below.
//
//					 http://www.digilentinc.com/Data/Products/XUPV2P-COVERS/PmodJSTK_rm_RevC.pdf
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
////////////////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module spi_ctrl(
	input wire clk,
	input wire rst,
	input wire data_mode,
	input wire busy,                   // Jeœli aktwyne to transfer danych jest w toku
	input wire [7:0] data_in,
	input wire [7:0] data_rx,          // Ostatni otrzymany bajt
	
	output reg cs,                     // aktywny stanem niskim
	output reg get_byte,                // inicjuje transfer danych w spimode0
	output reg [7:0] data_send,
	output reg [39:0] data_out      
);

parameter [2:0] IDLE  = 3'b000,
                INIT  = 3'b001,
                WAIT  = 3'b010,
                CHECK = 3'b011,
                DONE  = 3'b100;
parameter byteEndVal  = 3'b101;				         // Nliczba bajtów do wys³ania/otrzymania

reg [2:0] state, state_nxt;
reg [2:0] byte_counter, byte_counter_nxt;
reg [39:0] tmpsr, tmpsr_nxt, data_out_nxt;
reg cs_nxt, get_byte_nxt;
reg [7:0] data_send_nxt;

always @(negedge clk) begin
    if(rst == 1) begin
        cs <= 1'b1;
        get_byte <= 1'b0;
        data_send <= 8'h00;
        tmpsr <= 40'h0000000000;
        data_out <= 40'h0000000000;
        byte_counter <= 3'd0;
        state <= IDLE;
    end
    else begin
        cs <= cs_nxt;
        get_byte <= get_byte_nxt;
        data_send <= data_send_nxt;
        tmpsr <= tmpsr_nxt;
        data_out <= data_out_nxt;
        byte_counter <= byte_counter_nxt;
        state <= state_nxt;
    end
end

always@* begin
    case(state)
        IDLE: begin
            cs_nxt = 1;                                 
            get_byte_nxt = 0;                            // Nie oczekuj danych
            data_send_nxt = 8'h00;                      // puste dane do wys³ania
            tmpsr_nxt = 40'h0000000000;                 
            data_out_nxt = data_out;       
            byte_counter_nxt = 3'd0;
        // Rozpoczynanie transmisji danych po otrzymaniu sygna³u odbioru 
            state_nxt = (data_mode == 1) ? INIT : IDLE;
        end
        INIT: begin
            cs_nxt = 0;								
            get_byte_nxt = 1;                        // Inicjalizacja transferu danych
            data_send_nxt = data_in;                
            tmpsr_nxt = tmpsr;                       
            data_out_nxt = data_out;                  
            if(busy == 1) begin
                state_nxt = WAIT;
                byte_counter_nxt = byte_counter + 1;  
            end
            else begin
                state_nxt = INIT;
                byte_counter_nxt = byte_counter;
            end                
        end
        WAIT: begin
            cs_nxt = 0;								
            get_byte_nxt = 0;                        // Trwa oczekiwanie na dane
            data_send_nxt = data_send;
            tmpsr_nxt = tmpsr;                       
            data_out_nxt = data_out;                            
            byte_counter_nxt = byte_counter;                                       
            //Pobierz dane, gdy zakoñczone odczytywanie bajtu - CHECK
            state_nxt = (busy == 0) ? CHECK : WAIT;
        end
        CHECK: begin
            cs_nxt = 0;								
            get_byte_nxt = 0;                        //  Nie oczekuj danych
            data_send_nxt = data_send;              
            tmpsr_nxt = {tmpsr[31:0], data_rx};
            data_out_nxt = data_out;                
            byte_counter_nxt = byte_counter; 
            // Odczytano bajty - DONE
            state_nxt = (byte_counter == 3'd5) ? DONE : INIT;                        
        end
        DONE: begin
            cs_nxt = 1;							
            get_byte_nxt = 0;                    // Nie oczekuj danych
            data_send_nxt = 8'h00;                    // Wyczyœæ wysy³ane dane
            tmpsr_nxt = tmpsr;                    
            data_out_nxt[39:0] = tmpsr[39:0];        // Zaktualizuj dane wyjœciowe
            byte_counter_nxt = byte_counter;                    
            state_nxt = (data_mode == 0) ? IDLE : DONE;                                   
        end
        default: begin
            cs_nxt = cs;							
            get_byte_nxt = get_byte;                    
            data_send_nxt = data_send;                    
            tmpsr_nxt = tmpsr;                    
            data_out_nxt = data_out;        
            byte_counter_nxt = byte_counter;                        
            state_nxt = IDLE;          
        end
    endcase
end	
endmodule
