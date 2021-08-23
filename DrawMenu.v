`timescale 1ns / 1ps

module DrawMenu(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0]  vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    
    output reg [11:0] rgb_out
    ); 
reg [11:0] rgb_out_nxt;
    
always@ (posedge clk) begin
    if (rst) rgb_out <= 0;
    else rgb_out <= rgb_out_nxt;
end
   
localparam BORDERS = 12'hf_0_0;
      
always @* begin
    if (vblnk_in || hblnk_in) {rgb_out_nxt} = 12'h0_0_0; 
    else begin
        if ((vcount_in >= 0 && vcount_in <= 2) || (vcount_in >= 765 && vcount_in <= 767))      {rgb_out_nxt} = BORDERS;
        else if ((hcount_in >= 0 && hcount_in <= 2) || (hcount_in >= 1021 && hcount_in <= 1023)) {rgb_out_nxt} = BORDERS;
        else if ((hcount_in >= 500 && hcount_in <= 560) && (vcount_in >= 320 && vcount_in <= 350)) {rgb_out_nxt} = 12'h1_8_6;
        else {rgb_out_nxt} = 12'h8_8_8;    
    end
end
endmodule
