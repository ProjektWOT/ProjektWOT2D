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

localparam HOR_TIME = 1024;
localparam VER_TIME = 768;
localparam HOR_FRONT_PORCH = 24;
localparam VER_FRONT_PORCH = 3;
localparam HOR_SYNC_PULSE = 136;
localparam VER_SYNC_PULSE = 6;
localparam HOR_WHOLE = 1344;
localparam VER_WHOLE = 806;


always@* begin
    // horizontal counter  
    if (hcount == (HOR_WHOLE-1)) hcount_nxt <= 11'b0;
        else hcount_nxt <= hcount + 1;
    // vertical counter
    if (hcount == (HOR_WHOLE-1) && vcount == (VER_WHOLE-1)) vcount_nxt <= 11'b0;
    else if (hcount == (HOR_WHOLE-1)) vcount_nxt <= vcount + 1;
        else vcount_nxt <= vcount;
              
    // Synchronization time                
    if (hcount >= (HOR_TIME+HOR_FRONT_PORCH - 1) && hcount <= (HOR_TIME+HOR_FRONT_PORCH+HOR_SYNC_PULSE-2)) hsync_nxt <= 1;
        else hsync_nxt <= 0;
    if (vcount == (VER_TIME) && hcount == (HOR_WHOLE-1)) vsync_nxt <= 1;
    else if (vcount >= (VER_TIME+VER_FRONT_PORCH) && vcount <= (VER_TIME+VER_SYNC_PULSE-1)) vsync_nxt <= 1;
    else if (vcount == (VER_TIME+VER_SYNC_PULSE) && hcount <= (HOR_WHOLE-2)) vsync_nxt <= 1;
    else if (vcount == (VER_TIME+VER_SYNC_PULSE) && hcount == (HOR_WHOLE-1)) vsync_nxt <= 0;
        else vsync_nxt <= 0;
                        
    // Blank spaces
    if (hcount >= (HOR_TIME-1) && hcount <= (HOR_WHOLE-2)) hblnk_nxt <= 1;
        else hblnk_nxt <= 0;
    if (vcount == (VER_TIME-1) && hcount == (HOR_WHOLE-1)) vblnk_nxt <= 1;
    else if (vcount >= (VER_TIME) && vcount <= ((VER_WHOLE-2))) vblnk_nxt <= 1;
    else if (vcount == (VER_WHOLE-1) && hcount <= (HOR_WHOLE-2)) vblnk_nxt <= 1;
    else if (vcount == (VER_WHOLE-1) && hcount == (HOR_WHOLE-1)) vblnk_nxt <= 0;
        else vblnk_nxt <= 0;
    end
endmodule
