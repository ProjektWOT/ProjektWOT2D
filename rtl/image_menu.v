`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module image_menu(
    input wire clk ,
    input wire [14:0] address,
    
    output reg [11:0] rgb_menu
);

reg [14:0] rom [0:32767];

initial $readmemh("menu_start.data", rom); 

always @(posedge clk)
    rgb_menu <= rom[address];

endmodule
