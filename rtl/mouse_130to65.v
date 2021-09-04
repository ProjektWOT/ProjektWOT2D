`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub
*/

module mouse_130to65(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_mouse_in,
    input wire [11:0] ypos_mouse_in,

    output reg [11:0] xpos_mouse,
    output reg [11:0] ypos_mouse
);

always @(posedge clk) begin
    if(rst) begin
        xpos_mouse <= 0;
        ypos_mouse <= 0;
    end
    else begin
        xpos_mouse <= xpos_mouse_in;
        ypos_mouse <= ypos_mouse_in;
    end
end

endmodule
