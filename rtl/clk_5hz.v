`timescale 1ns / 1ps
/*
We used program from Xilinx forum and edited it to our needs.
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_5Hz
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 5Hz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module clk_5hz(
    input wire clk,
    input wire rst,
    output reg clkout			
);

	parameter CNTENDVAL = 24'h989680;
	reg [23:0] clk_count = 24'h000000;
	
	always @(posedge clk) begin
		if(rst == 1'b1) begin
	    	clkout <= 1'b0;
			clk_count <= 24'h000000;
		end
		else begin
		    if(clk_count == CNTENDVAL) begin
			    clkout <= ~clkout;
			    clk_count <= 24'h000000;
		    end
		    else begin
			    clk_count <= clk_count + 1'b1;
		    end
	    end
	end

endmodule
