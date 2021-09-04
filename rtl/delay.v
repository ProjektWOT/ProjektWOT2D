`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module delay(
    input wire clk,
    input wire [9:0] xpos_tank_in,
    input wire [9:0] ypos_tank_in,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,
 
    output reg [9:0] xpos_tank_out,
    output reg [9:0] ypos_tank_out,
    output reg [11:0] xpos_mouse_out,
    output reg [11:0] ypos_mouse_out  
);  

//Sequential data execute
//****************************************************************************************************************//      
always@(posedge clk) begin
    xpos_tank_out <= xpos_tank_in;
    ypos_tank_out <= ypos_tank_in;
    xpos_mouse_out <= xpos_mouse_in;
    ypos_mouse_out <= ypos_mouse_in;
end

endmodule
