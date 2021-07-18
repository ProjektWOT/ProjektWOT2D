`timescale 1ns / 1ps

module PmodJSTK(
    input wire clk,
	input wire rst,
	input wire Data_mode,
	input wire [7:0] Data_in,
	input wire MISO,
	
	output wire CS,
	output wire	SCLK,
	output wire	MOSI,
	output wire [39:0]	Data_out
    );

	wire getByte;							// Inicjuje transfer bajtów danych w spiMode0
	wire [7:0] Data_send;					// Dane wysy³ane do Slave
	wire [7:0] Data_rx;						// dane z spiMode0
	wire BUSY;								// Wymiana z spiMode0 do spiCtrl
			
	// 66.67kHz
	wire iSCLK;
	
	spiCtrl spiCtrl(
	    .clk(iSCLK),
		.rst(rst),
		.Data_mode(Data_mode),
		.BUSY(BUSY),
		.Data_in(Data_in),
		.Data_rx(Data_rx),
		.CS(CS),
		.getByte(getByte),
		.Data_send(Data_send),
		.Data_out(Data_out)
	);

	spiMode0 spiMode0(
		.clk(iSCLK),
		.rst(rst),
		.Data_mode(getByte),
		.Data_in(Data_send),
		.MISO(MISO),
		.MOSI(MOSI),
		.SCLK(SCLK),
		.BUSY(BUSY),
		.Data_out(Data_rx)
	);

	clk_66_67kHz clk_66_67kHz(
		.clk(clk),
		.rst(rst),
		.CLKOUT(iSCLK)
	);

endmodule
