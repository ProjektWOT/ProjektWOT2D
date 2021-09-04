`timescale 1ns / 1ps
/*
//https://www.instructables.com/How-to-Use-the-PmodJSTK-With-the-Basys3-FPGA/
We used program from Xilinx forum and edited it to our needs.
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    PmodJSTK_Demo 
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This is a demo for the Digilent PmodJSTK. Data is sent and received
//					 to and from the PmodJSTK at a frequency of 5Hz, and positional 
//					 data is displayed on the seven segment display (SSD). The positional
//					 data of the joystick ranges from 0 to 1023 in both the X and Y
//					 directions. Only one coordinate can be displayed on the SSD at a
//					 time, therefore switch SW0 is used to select which coordinate's data
//	   			 to display. The status of the buttons on the PmodJSTK are
//					 displayed on LD2, LD1, and LD0 on the Nexys3. The LEDs will
//					 illuminate when a button is pressed. Switches SW2 and SW1 on the
//					 Nexys3 will turn on LD1 and LD2 on the PmodJSTK respectively. Button
//					 BTND on the Nexys3 is used for resetting the demo. The PmodJSTK
//					 connects to pins [4:1] on port JA on the Nexys3. SPI mode 0 is used
//					 for communication between the PmodJSTK and the Nexys3.
//
//					 NOTE: The digits on the SSD may at times appear to flicker, this
//						    is due to small pertebations in the positional data being read
//							 by the PmodJSTK's ADC. To reduce the flicker simply reduce
//							 the rate at which the data being displayed is updated.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/
module pmod_joystick(
    input wire clk,	
    input wire reset,              
    input wire miso,       
    
    output wire cs,      
    output wire mosi, 
    output wire sclk,
    output wire [9:0] data_out_x,
    output wire [9:0] data_out_y
);

wire [7:0] data_send;
wire data_mode;

//Data from Joystick
wire [39:0] data_jstk;

pmod_jstk pmod_jstk(
    .clk(clk),
    .rst(reset),
    .data_mode(data_mode),
    .data_in(data_send),   
    .miso(miso),
    .cs(cs),
    .sclk(sclk),
    .mosi(mosi),
    .data_out(data_jstk)
);

clk_5hz clk_5hz(
    .clk(clk),
    .rst(reset),
    .clkout(data_mode)
);

assign data_out_y = {data_jstk[25:24], data_jstk[39:32]};
assign data_out_x = {data_jstk[9:8], data_jstk[23:16]};
// Data send to Joystick - LED on
assign data_send = {8'b10000001};

endmodule
