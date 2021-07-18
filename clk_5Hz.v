`timescale 1ns / 1ps

module clk_5Hz(
    input wire clk,
    input wire rst,
    output reg CLKOUT			
    );

	parameter cntEndVal = 24'h989680;
	reg [23:0] clkCount = 24'h000000;
	
	always @(posedge clk) begin
		if(rst == 1'b1) begin
	    	CLKOUT <= 1'b0;
			clkCount <= 24'h000000;
		end
		else begin
		    if(clkCount == cntEndVal) begin
			    CLKOUT <= ~CLKOUT;
			    clkCount <= 24'h000000;
		    end
		    else begin
			    clkCount <= clkCount + 1'b1;
		    end
	    end
	end

endmodule
