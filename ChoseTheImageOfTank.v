`timescale 1ns / 1ps

module ChoseTheImageOfTank(
    input wire clk,
    input wire [11:0] address,
    
    output wire [11:0] rgb0,
    output wire [11:0] rgb1,
    output wire [11:0] rgb2,
    output wire [11:0] rgb3
    );
    
image_tank ImageTank          (.clk(clk), .address(address), .rgb(rgb0));
ImageTankDown ImageTankDown   (.clk(clk), .address(address), .rgb(rgb1));
ImageTankRight ImageTankRight (.clk(clk), .address(address), .rgb(rgb2));
ImageTankLeft ImageTankLeft   (.clk(clk), .address(address), .rgb(rgb3));
endmodule
