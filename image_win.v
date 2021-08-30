`timescale 1ns / 1ps

module image_win(
    input wire clk ,
    input wire [13:0] address,  // address = {addry[5:0], addrx[7:0]}
    output reg [11:0] rgb
);

reg [13:0] rom [0:16383];

initial $readmemh("win.data", rom); 

always @(posedge clk)
rgb <= rom[address];


endmodule
