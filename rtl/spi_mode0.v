`timescale 1ns / 1ps
/*
We used program from Xilinx forum and edited it to our needs.
///////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    spiMode0
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This module provides the interface for sending and receiving data
//					 to and from the PmodJSTK, SPI mode 0 is used for communication.  The
//					 master (Nexys3) reads the data on the MISO input on rising edges, the
//					 slave (PmodJSTK) reads the data on the MOSI output on rising edges.
//					 Output data to the slave is changed on falling edges, and input data
//					 from the slave changes on falling edges.
//
//					 To initialize a data transfer between the master and the slave simply
//					 assert the sndRec input.  While the data transfer is in progress the
//					 BUSY output is asserted to indicate to other componenets that a data
//					 transfer is in progress.  Data to send to the slave is input on the 
//					 DIN input, and data read from the slave is output on the DOUT output.
//
//					 Once a sndRec signal has been received a byte of data will be sent
//					 to the PmodJSTK, and a byte will be read from the PmodJSTK.  The
//					 data that is sent comes from the DIN input. Received data is output
//					 on the DOUT output.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
///////////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module spi_mode0(
    input wire clk,                 
    input wire rst,                 
    input wire data_mode,              
    input wire [7:0] data_in,
    input wire miso,
    
    output wire mosi,
    output wire sclk,
    output wire [7:0] data_out,     
    output reg busy                // Jeœli dane s¹ wysy³ane lub otrzymywane 
    );

	parameter [1:0] IDLE = 2'b00,
					INIT = 2'b01,
					RXTX = 2'b10,
				    DONE = 2'b11;

	reg [4:0] bit_counter, bit_counter_nxt ;							
	reg [7:0] rsr, rsr_nxt;						
	reg [7:0] wsr, wsr_nxt;						
	reg [1:0] state, state_nxt;				

	reg ce, ce_nxt, busy_nxt;										
													
	
	// Jeœli aktywne CE wyjœcie zegar - clk
	assign sclk = (ce == 1) ? clk : 1'b0;
	assign mosi = wsr[7];
	assign data_out = rsr;
	

	// 	slave, master czyta dane na rising edge
	// slave, master zmieniaj¹ wyjœcia na falling edges
	always @(negedge clk) begin
		if(rst == 1)
		    wsr <= 8'h00;
		else
		    wsr <= wsr_nxt;  
	end
	

    always @(posedge clk) begin
        if(rst == 1)
            rsr <= 8'h00;
        else
            rsr <= rsr_nxt;
	end	
	
   
    // SPI Mode 0 FSM
    always @(negedge clk) begin
        if(rst == 1) begin
            ce <= 0;                    
            busy <= 0;                  
            bit_counter <= 4'h0;
            state <= IDLE;              
        end
        else begin
            ce <= ce_nxt;
            busy <= busy_nxt;
            bit_counter <= bit_counter_nxt;
            state <= state_nxt;
        end
     end
     
     always@* begin
        case(state)
            IDLE: begin
                wsr_nxt = data_in;
                rsr_nxt = rsr;
                ce_nxt = 0;				    
                busy_nxt = 0;               
                bit_counter_nxt = 4'd0;                     
                // Rozpoczynanie transmisji danych po otrzymaniu sygna³u odbioru 
                state_nxt = (data_mode == 1) ? INIT : IDLE;     
            end
            INIT: begin
                wsr_nxt = wsr;
                rsr_nxt = rsr;
                busy_nxt = 1;			    
                bit_counter_nxt = 4'h0;     
                ce_nxt = 0;                           
                state_nxt = RXTX;                    
            end
            RXTX: begin
                if(ce == 1) begin
                    wsr_nxt = {wsr[6:0], 1'b0};
                    rsr_nxt = {rsr[6:0], miso};
                end
                else begin
                    wsr_nxt = wsr;
                    rsr_nxt = rsr;
                end
                busy_nxt = 1;						  
                bit_counter_nxt = bit_counter + 1;                      
   
                ce_nxt = (bit_counter >= 4'd8) ? 0 : 1;
                state_nxt = (bit_counter == 4'd8) ? DONE : RXTX;
            end
            DONE: begin
                wsr_nxt = wsr;
                rsr_nxt = rsr;
                ce_nxt  = 0;			 
                busy_nxt = 1;            
                bit_counter_nxt = 4'd0;                   
                state_nxt = IDLE;
            end
            default: begin
                wsr_nxt = wsr;
                rsr_nxt = rsr;
                ce_nxt  = ce;          
                busy_nxt = busy;        
                bit_counter_nxt = bit_counter;                    
                state_nxt = IDLE;
            end
        endcase
     end 
endmodule