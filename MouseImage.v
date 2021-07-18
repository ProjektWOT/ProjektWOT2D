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
    hsync_out <= hsync;
    vsync_out <= vsync;
    hblnk_out <= hblnk;
    vblnk_out <= vblnk;
    hcount_out <= hcount;
    vcount_out <= vcount;
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
        if (vcount >= ypos && vcount <= ypos + PIXEL_lINE && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 1 && hcount == xpos + 1 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 2 && hcount == xpos + 2 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 3 && hcount == xpos + 3 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 4 && hcount == xpos + 4 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 5 && hcount == xpos + 5 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 6 && hcount == xpos + 6 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 7 && hcount == xpos + 7 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 8 && hcount == xpos + 8 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 9 && hcount == xpos + 9 ) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 10 && hcount == xpos +10) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 11 && hcount == xpos +11) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos +12) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos +11) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos +10) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos + 9) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos + 8) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos + 7) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos + 6) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 12 && hcount == xpos + 5) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 16 && hcount == xpos + 1) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 15 && hcount == xpos + 2) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 14 && hcount == xpos + 3) rgb_out_nxt = 12'h0_0_0;
        else if (vcount == ypos + 13 && hcount == xpos + 4) rgb_out_nxt = 12'h0_0_0;
        else if (vcount >= ypos + 2 && vcount <= ypos + 15 && hcount == xpos + 1) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 3 && vcount <= ypos + 14 && hcount == xpos + 2) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 4 && vcount <= ypos + 13 && hcount == xpos + 3) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 5 && vcount <= ypos + 12 && hcount == xpos + 4) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 6 && vcount <= ypos + 11 && hcount == xpos + 5) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 7 && vcount <= ypos + 11 && hcount == xpos + 6) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 8 && vcount <= ypos + 11 && hcount == xpos + 7) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 9 && vcount <= ypos + 11 && hcount == xpos + 8) rgb_out_nxt = 12'hf_f_f;
        else if (vcount >= ypos + 10 && vcount <= ypos + 11 && hcount == xpos + 9) rgb_out_nxt = 12'hf_f_f;
        else if (vcount == ypos + 11 && hcount == xpos + 10) rgb_out_nxt = 12'hf_f_f;
            else rgb_out_nxt = rgb_in;  
        end
    SCOPE: begin
        if(vcount == ypos && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos && hcount >= xpos + 2 && hcount <= xpos + 4) rgb_out_nxt = 12'h0_0_0;
        else if(vcount >= ypos + 2 && vcount <= ypos + 4 && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos && hcount == xpos - 2) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos && hcount == xpos - 3) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos && hcount == xpos - 4) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos -2 && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos -3 && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
        else if(vcount == ypos -4 && hcount == xpos) rgb_out_nxt = 12'h0_0_0;
            else rgb_out_nxt = rgb_in;
        end
    endcase
    end
endmodule
