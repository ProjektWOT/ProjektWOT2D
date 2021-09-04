/*
Authors:
Orze� �ukasz
�wiebocki Jakub
*/

module image_tank_up(
    input wire clk ,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    
    output reg [11:0] rgb
);

reg [11:0] rom [0:4095];

initial $readmemh("image_tank_up.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule
