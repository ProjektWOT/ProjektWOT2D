`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module choose_the_image_of_tank(
    input wire clk,
    input wire [11:0] address,
    
    output wire [11:0] rgb0,
    output wire [11:0] rgb1,
    output wire [11:0] rgb2,
    output wire [11:0] rgb3
);
    
image_tank_up    image_tank_up   (.clk(clk), .address(address), .rgb(rgb0));
image_tank_down  image_tank_down (.clk(clk), .address(address), .rgb(rgb1));
image_tank_right image_tank_right (.clk(clk), .address(address), .rgb(rgb2));
image_tank_left  image_tank_left (.clk(clk), .address(address), .rgb(rgb3));

endmodule
