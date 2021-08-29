`timescale 1ns / 1ps

module Choose_image_tank_op(
    input wire clk,
    input wire [11:0] address,
    
    output wire [11:0] rgb0,
    output wire [11:0] rgb1,
    output wire [11:0] rgb2,
    output wire [11:0] rgb3
);

ImageTankUp_op ImageTankUp_op       (.clk(clk), .address(address), .rgb(rgb0));
ImageTankDown_op ImageTankDown_op   (.clk(clk), .address(address), .rgb(rgb1));
ImageTankRight_op ImageTankRight_op (.clk(clk), .address(address), .rgb(rgb2));
ImageTankLeft_op ImageTankLeft_op   (.clk(clk), .address(address), .rgb(rgb3));
endmodule
