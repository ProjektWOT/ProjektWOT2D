`timescale 1ns / 1ps

module Reset(
    input wire clk,
    input wire locked,
    output reg reset
    );
    
always@(posedge clk or negedge locked) begin
    if(locked == 0) reset <= 1;
    else reset <= 0;
    end
endmodule












/* zachodzi na 3 zbocza zegara pclk 40MHz i reset nie dzia�a. W tym wy�ej zahacza o jedno zbocze narastaj�ce i dzia�a.
`timescale 1ns / 1ps

module Reset_Mate(
    input wire pclk,
    input wire locked,
    
    output reg Reset
    );
    
reg Reset_nxt, StartRst;
reg STReset, STReset_nxt;

always @(posedge pclk) begin
    Reset <= Reset_nxt;
    STReset <= STReset_nxt;
end

always @* begin
    if(locked == 0) begin
        StartRst = 1;
        STReset_nxt = 0;
        Reset_nxt = 0;
        end
    else if(locked == 1 && StartRst == 1 && STReset == 0) begin
        Reset_nxt = 1;
        StartRst = 0;
        STReset_nxt = 1;
        end
    else if(locked == 1 && STReset == 1) begin
        Reset_nxt = 1;
        StartRst = 0;
        STReset_nxt = 0;
        end
    else begin
        StartRst = 0;
        Reset_nxt = 0;
        STReset_nxt = 0;
        end
    end
endmodule
*/