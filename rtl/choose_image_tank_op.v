`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module choose_image_tank_op(
    input wire clk,
    input wire [11:0] address,
    
    output wire [11:0] rgb0,
    output wire [11:0] rgb1,
    output wire [11:0] rgb2,
    output wire [11:0] rgb3
);

image_tank_up_op    image_tank_up_op     (.clk(clk), .address(address), .rgb(rgb0));
image_tank_down_op  image_tank_down_op   (.clk(clk), .address(address), .rgb(rgb1));
image_tank_right_op image_tank_right_op  (.clk(clk), .address(address), .rgb(rgb2));
image_tank_left_op  image_tank_left_op   (.clk(clk), .address(address), .rgb(rgb3));
endmodule
