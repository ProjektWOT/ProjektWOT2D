`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module draw_menu(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0]  vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    
    output reg [11:0] rgb_out
);
 
//Registers and Localparams
//****************************************************************************************************************//
reg [11:0] rgb_out_nxt;
 
localparam BORDERS      = 12'hf_0_0;
localparam BLACK        = 12'h0_0_0; 
localparam BACKGROUND   = 12'h8_8_8;

localparam BORDER_WIDTH_LEFT_UP = 2;
localparam BORDER_WIDTH_RIGHT1  = 765; 
localparam BORDER_WIDTH_RIGHT2  = 767;  
localparam BORDER_WIDTH_DOWN1   = 1021;
localparam BORDER_WIDTH_DOWN2   = 1023;
//****************************************************************************************************************//

//Sequential data execute
//****************************************************************************************************************//    
always@(posedge clk) begin
    if(rst) rgb_out <= 0;
    else rgb_out <= rgb_out_nxt;
end
//****************************************************************************************************************// 

//Logic
//****************************************************************************************************************//     
always @* begin
    if (vblnk_in || hblnk_in) {rgb_out_nxt} = BLACK; 
    else begin
        if ((vcount_in >= 0 && vcount_in <= BORDER_WIDTH_LEFT_UP)||(vcount_in >= BORDER_WIDTH_RIGHT1 && vcount_in <= BORDER_WIDTH_RIGHT2)) {rgb_out_nxt} = BORDERS;
        else if ((hcount_in >= 0 && hcount_in <= BORDER_WIDTH_LEFT_UP)||(hcount_in >= BORDER_WIDTH_DOWN1 && hcount_in <= BORDER_WIDTH_DOWN2)) {rgb_out_nxt} = BORDERS;
        else {rgb_out_nxt} = BACKGROUND;    
    end
end

endmodule