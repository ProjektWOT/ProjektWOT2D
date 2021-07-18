`timescale 1ns / 1ps

module clk_66_67kHz(
    input wire clk,											
    input wire rst,										
    output reg CLKOUT						
    );

	parameter cntEndVal = 10'b1011101110;
	reg [9:0] counter,counter_nxt;
    reg CLKOUT_nxt;

	always @(posedge clk) begin
		if(rst) begin
			CLKOUT <= 1'b0;
			counter <= 10'b0000000000;
		end
		else begin
		    CLKOUT <= CLKOUT_nxt;
		    counter <= counter_nxt;
		end
	end
	
	always@* begin
        if(counter == cntEndVal) begin
			CLKOUT_nxt = ~CLKOUT;
			counter_nxt = 10'b0000000000;
		end
		else begin
		    CLKOUT_nxt = CLKOUT;
			counter_nxt = counter + 1'b1;
		end
	end

endmodule
