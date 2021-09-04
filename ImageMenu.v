`timescale 1ns / 1ps

module ImageMenu(
    input wire clk ,
    input wire [14:0] address,  // address = {addry[5:0], addrx[7:0]}
    output reg [11:0] rgb_menu
);

reg [14:0] rom [0:32767];

initial $readmemh("MenuStart.data", rom); 

always @(posedge clk)
rgb_menu <= rom[address];


endmodule
