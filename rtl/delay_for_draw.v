`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module delay_for_draw(
    input wire clk,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
    
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out
);
    
always @(posedge clk) begin
    xpos_mouse_out <= xpos_mouse_in;
    ypos_mouse_out <= ypos_mouse_in;
end

endmodule
