`timescale 1ns / 1ps
/*
We used program from Xilinx forum and edited it to our needs.
////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    PmodJSTK
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This component consists of three subcomponents a 66.67kHz serial clock,
//					 a SPI controller and a SPI interface. The SPI interface component is 
//					 responsible for sending and receiving a byte of data to and from the 
//					 PmodJSTK when a request is made. The SPI controller component manages all
//					 data transfer requests, and manages the data bytes being sent to the PmodJSTK.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
////////////////////////////////////////////////////////////////////////////////////////////
Edit Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module pmod_jstk(
    input wire clk,
	input wire rst,
	input wire data_mode,
	input wire [7:0] data_in,
	input wire miso,
	
	output wire cs,
	output wire	sclk,
	output wire	mosi,
	output wire [39:0] data_out
);

wire get_byte;							// Inicjuje transfer bajtów danych w spiMode0
wire [7:0] data_send;					// Dane wysy³ane do Slave
wire [7:0] data_rx;						// dane z spiMode0
wire busy;								// Wymiana z spiMode0 do spiCtrl
        
// 66.67kHz
wire isclk;

spi_ctrl spi_ctrl(
    .clk(isclk),
    .rst(rst),
    .data_mode(data_mode),
    .busy(busy),
    .data_in(data_in),
    .data_rx(data_rx),
    .cs(cs),
    .get_byte(get_byte),
    .data_send(data_send),
    .data_out(data_out)
);

spi_mode0 spi_mode0(
    .clk(isclk),
    .rst(rst),
    .data_mode(get_byte),
    .data_in(data_send),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .busy(busy),
    .data_out(data_rx)
);

clk_66_67khz clk_66_67khz(
    .clk(clk),
    .rst(rst),
    .clkout(isclk)
);

endmodule
