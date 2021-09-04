`timescale 1ns / 1ps
/*
Authors:
Orze� �ukasz
�wiebocki Jakub
*/

module choose_image_of_end_game(
    input wire clk,
    input wire [13:0] address,
    
    output wire [11:0] rgb_win,
    output wire [11:0] rgb_lose
);

image_win image_win     (.clk(clk), .address(address), .rgb(rgb_win));
image_lose image_lose   (.clk(clk), .address(address), .rgb(rgb_lose));

endmodule
