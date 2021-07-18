`timescale 1ns / 1ps

module Mouse_130To65(
    input wire clk,
    input wire rst,
    input wire [11:0] B_posX,
    input wire [11:0] B_posY,

    output reg [11:0] posX,
    output reg [11:0] posY
);

reg [11:0] posX_nxt, posY_nxt;

always @(posedge clk)
    if(rst) begin
        posX <= 0;
        posY <= 0;
    end
    else begin
        posX <= B_posX;
        posY <= B_posY;
end

endmodule

