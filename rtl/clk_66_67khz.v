`timescale 1ns / 1ps
/*
We used program from Xilinx forum and edited it to our needs.
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_66_67kHz 
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 66.67kHz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/
module clk_66_67khz(
    input wire clk,											
    input wire rst,										
    output reg clkout						
    );

	parameter CNTENDVAL = 10'b1011101110;
	reg [9:0] counter,counter_nxt;
    reg clkout_nxt;

	always @(posedge clk) begin
		if(rst) begin
			clkout <= 1'b0;
			counter <= 10'b0000000000;
		end
		else begin
		    clkout <= clkout_nxt;
		    counter <= counter_nxt;
		end
	end
	
	always@* begin
        if(counter == CNTENDVAL) begin
			clkout_nxt = ~clkout;
			counter_nxt = 10'b0000000000;
		end
		else begin
		    clkout_nxt = clkout;
			counter_nxt = counter + 1'b1;
		end
	end

endmodule
