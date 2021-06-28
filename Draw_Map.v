`timescale 1ns / 1ps

module Draw_Map(
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
   
localparam BORDERS = 12'hf_f_f;
      
always @* begin
    if (vblnk_in || hblnk_in) {rgb_out_nxt} = 12'h0_0_0; 
    else begin
        if ((vcount_in >= 0 && vcount_in <= 2) || (vcount_in >= 597 && vcount_in <= 599))      {rgb_out_nxt} = BORDERS;
        else if ((hcount_in >= 0 && hcount_in <= 2) || (hcount_in >= 797 && hcount_in <= 799)) {rgb_out_nxt} = BORDERS;
        else {rgb_out_nxt} = 12'h8_8_8;    
    end
end
    
endmodule
