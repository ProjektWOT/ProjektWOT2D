`timescale 1 ns / 1 ps

module vga_timing (
    input wire clk,
    input wire rst,
    output reg [9:0]  vcount = 9'b0,
    output reg [10:0] hcount = 10'b0,
    output reg vsync,
    output reg hsync,
    output reg vblnk,
    output reg hblnk
    );
  
reg [9:0]  vcount_nxt;
reg [10:0] hcount_nxt;
reg vsync_nxt;
reg hsync_nxt;
reg vblnk_nxt;
reg hblnk_nxt;

localparam HOR_TOTAL_TIME  = 1344;
localparam HOR_BLANK_START = 1024;
localparam HOR_BLANK_TIME  = 320;
localparam HOR_SYNC_START  = 1048;
localparam HOR_SYNC_TIME   = 136;

localparam VER_TOTAL_TIME  = 806;
localparam VER_BLANK_START = 768;
localparam VER_BLANK_TIME  = 38;
localparam VER_SYNC_START  = 771;
localparam VER_SYNC_TIME   = 6;

always@ (posedge clk) begin
if (rst) begin
    hcount <= 0;
    vcount <= 0;
    vsync <= 0;
    hsync <= 0;
    vblnk <= 0;
    hblnk <= 0;    
    end
else begin
    hcount <= hcount_nxt;
    vcount <= vcount_nxt;
    vsync <= vsync_nxt;
    hsync <= hsync_nxt;
    vblnk <= vblnk_nxt;
    hblnk <= hblnk_nxt;
    end
end

 always@* begin 
        if (hcount == HOR_TOTAL_TIME - 1) 
            hcount_nxt = 0;
        else 
            hcount_nxt = hcount + 1;
        if (hcount == HOR_TOTAL_TIME - 1 && vcount == VER_TOTAL_TIME - 1) 
            vcount_nxt = 0;
        else if (hcount == HOR_TOTAL_TIME - 1) 
            vcount_nxt = vcount + 1;
        else 
            vcount_nxt = vcount;
                
        if (hcount + 1 >= HOR_SYNC_START && hcount + 1 < HOR_SYNC_START + HOR_SYNC_TIME) 
            hsync_nxt = 1;
        else 
            hsync_nxt = 0;
        if (vcount == VER_SYNC_START - 1 && hcount == HOR_TOTAL_TIME - 1||(vcount >= VER_SYNC_START && vcount <= VER_SYNC_START + VER_SYNC_TIME - 2)||(vcount == VER_SYNC_START + VER_SYNC_TIME -1 && hcount < HOR_TOTAL_TIME -1)) 
            vsync_nxt = 1;
        else if (vcount == VER_SYNC_START + VER_SYNC_TIME - 1 && hcount == HOR_TOTAL_TIME -1)
            vsync_nxt = 0; 
        else 
            vsync_nxt = 0; 
                                
        if (hcount + 1 >= HOR_BLANK_START && hcount + 1 < HOR_BLANK_START + HOR_BLANK_TIME) 
            hblnk_nxt = 1;
        else 
            hblnk_nxt = 0;
        if ((vcount == VER_BLANK_START - 1 && hcount == HOR_TOTAL_TIME - 1)||(vcount >= VER_BLANK_START && vcount <= VER_BLANK_START + VER_BLANK_TIME - 2)||(vcount == VER_BLANK_START + VER_BLANK_TIME - 1 && hcount < HOR_TOTAL_TIME -1)) 
            vblnk_nxt = 1;
        else if (vcount == VER_BLANK_START + VER_BLANK_TIME - 1 && hcount == HOR_TOTAL_TIME - 1)
            vblnk_nxt = 0;
        else 
            vblnk_nxt = 0;
                                           
 end
endmodule
