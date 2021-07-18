`timescale 1ns / 1ps

module PMOD_JOYSTICK(
    input wire clk,	
    input wire reset,              
    input wire MISO,       
    
    output wire CS,      
    output wire MOSI, 
    output wire SCLK,
    output wire [9:0] Data_out_X,
    output wire [9:0] Data_out_Y
    );

	wire [7:0] Data_send;
	wire Data_mode;
	
	//Dane odczytywane z joysticka
	wire [39:0] Data_jstk;

    PmodJSTK PmodJSTK(
	    .clk(clk),
	    .rst(reset),
	    .Data_mode(Data_mode),
        .Data_in(Data_send),   
	    .MISO(MISO),
	    .CS(CS),
	    .SCLK(SCLK),
        .MOSI(MOSI),
	    .Data_out(Data_jstk)
	);

	clk_5Hz clk_5Hz(
	    .clk(clk),
		.rst(reset),
		.CLKOUT(Data_mode)
	);
    
    assign Data_out_Y = {Data_jstk[25:24], Data_jstk[39:32]};
    assign Data_out_X = {Data_jstk[9:8], Data_jstk[23:16]};
// Dane wysy³ane do joysticka - zapalanie diody
	assign Data_send = {8'b10000001};

endmodule