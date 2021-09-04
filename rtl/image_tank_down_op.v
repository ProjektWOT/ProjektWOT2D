`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module image_tank_down_op(
    input wire clk ,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    
    output reg [11:0] rgb
);

reg [11:0] rom [0:4095];

initial $readmemh("image_dirop_down.data", rom); 

always @(posedge clk)
rgb <= rom[address];

endmodule
