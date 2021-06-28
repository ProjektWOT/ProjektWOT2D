`timescale 1ns / 1ps

module MouseImage(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire [10:0] hcount,
    input wire [9:0]  vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [11:0] rgb_in,
    input wire SelectMode,
    
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg [9:0]  vcount_out,
    output reg [11:0] rgb_out
    );
    
reg [11:0] rgb_out_nxt;
reg [9:0]  vcount_temp1, vcount_temp2;
reg [10:0] hcount_temp1, hcount_temp2;
reg vsync_temp1, vsync_temp2;
reg hsync_temp1, hsync_temp2;
reg vblnk_temp1, vblnk_temp2;
reg hblnk_temp1, hblnk_temp2;
reg State, State_nxt;

localparam PIXEL_lINE = 17;
localparam MOUSE = 1'b0;
localparam SCOPE = 1'b1;
    
always@ (posedge clk) begin
if (rst) begin
    hsync_out <= 0;
    vsync_out <= 0;
    hblnk_out <= 0;
    vblnk_out <= 0;
    hcount_out <= 0;
    vcount_out <= 0;
    rgb_out <= 0;  
    State <= MOUSE;  
    end
else begin
    hsync_temp1 <= hsync;
    vsync_temp1 <= vsync;
    hblnk_temp1 <= hblnk;
    vblnk_temp1 <= vblnk;
    hcount_temp1 <= hcount;
    vcount_temp1 <= vcount;
    hsync_temp2 <= hsync_temp1;
    vsync_temp2 <= vsync_temp1;
    hblnk_temp2 <= hblnk_temp1;
    vblnk_temp2 <= vblnk_temp1;
    hcount_temp2 <= hcount_temp1;
    vcount_temp2 <= vcount_temp1;
    
    hsync_out <= hsync_temp2;
    vsync_out <= vsync_temp2;
    hblnk_out <= hblnk_temp2;
    vblnk_out <= vblnk_temp2;
    hcount_out <= hcount_temp2;
    vcount_out <= vcount_temp2;
    rgb_out <= rgb_out_nxt;
    State <= State_nxt;
    end
end
          
always @* begin
    case(State)
        MOUSE: begin
            if(SelectMode == 1 && xpos < 600) State_nxt = SCOPE;
            else State_nxt = MOUSE;
            end
        SCOPE: begin
            if(SelectMode == 1 && xpos < 600) State_nxt = SCOPE;
            else State_nxt = MOUSE;
            end
        endcase
    end
          
always @* begin
    case(State)
    MOUSE: begin
        if (vcount_temp2 >= ypos && vcount_temp2 <= ypos + PIXEL_lINE && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 1 && hcount_temp2 == xpos + 1 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 2 && hcount_temp2 == xpos + 2 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 3 && hcount_temp2 == xpos + 3 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 4 && hcount_temp2 == xpos + 4 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 5 && hcount_temp2 == xpos + 5 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 6 && hcount_temp2 == xpos + 6 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 7 && hcount_temp2 == xpos + 7 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 8 && hcount_temp2 == xpos + 8 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 9 && hcount_temp2 == xpos + 9 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 10 && hcount_temp2 == xpos +10) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 11 && hcount_temp2 == xpos +11) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos +12) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos +11) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos +10) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos + 9) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos + 8) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos + 7) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos + 6) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 12 && hcount_temp2 == xpos + 5) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 16 && hcount_temp2 == xpos + 1) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 15 && hcount_temp2 == xpos + 2) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 14 && hcount_temp2 == xpos + 3) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 == ypos + 13 && hcount_temp2 == xpos + 4) rgb_out_nxt = 12'h0_0_0;
        else if (vcount_temp2 >= ypos + 2 && vcount_temp2 <= ypos + 15 && hcount_temp2 == xpos + 1) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 3 && vcount_temp2 <= ypos + 14 && hcount_temp2 == xpos + 2) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 4 && vcount_temp2 <= ypos + 13 && hcount_temp2 == xpos + 3) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 5 && vcount_temp2 <= ypos + 12 && hcount_temp2 == xpos + 4) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 6 && vcount_temp2 <= ypos + 11 && hcount_temp2 == xpos + 5) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 7 && vcount_temp2 <= ypos + 11 && hcount_temp2 == xpos + 6) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 8 && vcount_temp2 <= ypos + 11 && hcount_temp2 == xpos + 7) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 9 && vcount_temp2 <= ypos + 11 && hcount_temp2 == xpos + 8) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 >= ypos + 10 &&vcount_temp2 <= ypos + 11 && hcount_temp2 == xpos + 9) rgb_out_nxt = 12'hf_f_f;
        else if (vcount_temp2 == ypos + 11 && hcount_temp2 == xpos + 10) rgb_out_nxt = 12'hf_f_f;
            else rgb_out_nxt = rgb_in;  
        end
    SCOPE: begin
        if(vcount_temp2 == ypos && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos && hcount_temp2 >= xpos + 2 && hcount_temp2 <= xpos + 4) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 >= ypos + 2 && vcount_temp2 <= ypos + 4 && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos && hcount_temp2 == xpos - 2) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos && hcount_temp2 == xpos - 3) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos && hcount_temp2 == xpos - 4) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos -2 && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos -3 && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount_temp2 == ypos -4 && hcount_temp2 == xpos) rgb_out_nxt = 12'h0_0_0;
            else rgb_out_nxt = rgb_in;
        end
    endcase
    end
endmodule
