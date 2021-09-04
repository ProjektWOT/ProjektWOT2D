`timescale 1ns / 1ps

module Draw_Map(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0]  vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    
    output reg [11:0] rgb_out
    );
   
reg [11:0] rgb_out_nxt, rgb_out_temp;
    
always@ (posedge clk) begin
    if (rst) rgb_out <= 0;    
    else begin
        rgb_out_temp <= rgb_out_nxt;
        rgb_out <= rgb_out_temp;
        end
end
   
localparam BORDERS = 12'hf_f_f;
      
always @* begin
    if (vblnk_in || hblnk_in) {rgb_out_nxt} = 12'h0_0_0; 
    else begin
        if ((vcount_in >= 0 && vcount_in <= 1) || (vcount_in >= 766 && vcount_in <= 767))      {rgb_out_nxt} = BORDERS;
        else if ((hcount_in >= 0 && hcount_in <= 1) || (hcount_in >= 1023 && hcount_in <= 1023) || (hcount_in >= 767 && hcount_in <= 768)) {rgb_out_nxt} = BORDERS;
        //H
        else if ((vcount_in >= 96 && vcount_in <= 151) && ((hcount_in >= 341 && hcount_in <= 351)|| (hcount_in >= 371 && hcount_in <= 381))||((vcount_in >= 115 && vcount_in <= 125) && (hcount_in >= 350 && hcount_in <= 372))) {rgb_out_nxt} = 12'hf_f_f;
        //KOMIN CZARNE WYPEŁNIENIE + OPONY
        else if (((vcount_in >= 579 && vcount_in <= 583) && (hcount_in >= 419 && hcount_in <= 425))||((vcount_in >= 755 && vcount_in <= 755) && (hcount_in >= 726 && hcount_in <= 730))||
        ((vcount_in >= 744 && vcount_in <= 744) && (hcount_in >= 726 && hcount_in <= 730)) || ((vcount_in >= 755 && vcount_in <= 755) && (hcount_in >= 738 && hcount_in <= 742))||
        ((vcount_in >= 744 && vcount_in <= 744) && (hcount_in >= 738 && hcount_in <= 742))) {rgb_out_nxt} = 12'h0_0_0;
        //KOMIN
        else if ((vcount_in >= 574 && vcount_in <= 588) && (hcount_in >= 414 && hcount_in <= 430)) {rgb_out_nxt} = 12'h7_2_0;
        //BUDYNKI
        else if (((vcount_in >= 563 && vcount_in <= 642) && (hcount_in >= 291 && hcount_in <= 452))||((vcount_in >= 81 && vcount_in <= 170) && (hcount_in >= 308 && hcount_in <= 440))) {rgb_out_nxt} = 12'h7_7_7;
        //BELKI TOROW
        else if ((vcount_in >= 337 && vcount_in <= 367) && ((hcount_in >= 23 && hcount_in <= 26) || (hcount_in >= 61 && hcount_in <= 64) ||(hcount_in >= 99 && hcount_in <= 102) || 
        (hcount_in >= 137 && hcount_in <= 140) || (hcount_in >= 175 && hcount_in <= 178) || (hcount_in >= 213 && hcount_in <= 216) || (hcount_in >= 251 && hcount_in <= 254) || 
        (hcount_in >= 289 && hcount_in <= 292) || (hcount_in >= 327 && hcount_in <= 330) || (hcount_in >= 365 && hcount_in <= 368) || (hcount_in >= 403 && hcount_in <= 406) ||
        (hcount_in >= 441 && hcount_in <= 444) || (hcount_in >= 479 && hcount_in <= 482) || (hcount_in >= 517 && hcount_in <= 520) || (hcount_in >= 555 && hcount_in <= 558) ||
        (hcount_in >= 593 && hcount_in <= 596) || (hcount_in >= 631 && hcount_in <= 634) || (hcount_in >= 669 && hcount_in <= 672) || (hcount_in >= 707 && hcount_in <= 710) || 
        (hcount_in >= 745 && hcount_in <= 748))) {rgb_out_nxt} = 12'h7_4_0;
        //TORY
        else if (((vcount_in >= 335 && vcount_in <= 338)||(vcount_in >= 366 && vcount_in <= 369))&& (hcount_in >= 2 && hcount_in <= 766)) {rgb_out_nxt} = 12'h5_1_2;
        //MURKI
        else if (((vcount_in >= 377 && vcount_in <= 393) && (hcount_in >= 38 && hcount_in <= 180))||((vcount_in >= 310 && vcount_in <= 328) && (hcount_in >= 269 && hcount_in <= 401))||
        ((vcount_in >= 376 && vcount_in <= 390) && (hcount_in >= 390 && hcount_in <= 517))) {rgb_out_nxt} = 12'hD_A_0;
        //KAMYKI
        else if(((vcount_in >= 223 && vcount_in <= 260) && (hcount_in >= 101 && hcount_in <= 142))||((vcount_in >= 260 && vcount_in <= 301) && (hcount_in >= 581 && hcount_in <= 634)) || 
        ((vcount_in >= 123 && vcount_in <= 154) && (hcount_in >= 675 && hcount_in <= 710))||((vcount_in >= 479 && vcount_in <= 519) && (hcount_in >= 197 && hcount_in <= 244))|| 
         ((vcount_in >= 511 && vcount_in <= 580) && (hcount_in >= 555 && hcount_in <= 604))||((vcount_in >= 446 && vcount_in <= 482) && (hcount_in >= 694 && hcount_in <= 740))) {rgb_out_nxt} = 12'h8_9_F;
        //GĄSKI
        else if (((vcount_in >= 64 && vcount_in <= 76) && (hcount_in >= 693 && hcount_in <= 757))||((vcount_in >= 102 && vcount_in <= 114) && (hcount_in >= 693 && hcount_in <= 757))) {rgb_out_nxt} = 12'h4_4_5;
        //WIEŻĄ
        else if (((vcount_in >= 40 && vcount_in <= 46) && (hcount_in >= 700 && hcount_in <= 725))||((hcount_in-733)*(hcount_in-733) + (vcount_in-43)*(vcount_in-43) < 12*12)) {rgb_out_nxt} = 12'h1_4_0;
        //POJAZDY
        else if (((vcount_in >= 745 && vcount_in <= 754) && (hcount_in >= 723 && hcount_in <= 744))||((vcount_in >= 77 && vcount_in <= 101) && (hcount_in >= 700 && hcount_in <= 751))) {rgb_out_nxt} = 12'h1_5_0;
        //TŁO
        else if ((vcount_in >= 2 && vcount_in <= 765) && (hcount_in >= 2 && hcount_in <= 766)) {rgb_out_nxt} = 12'hE_C_1;
        //PRZYCISK
        else if ((vcount_in >= 10 && vcount_in <= 30) && (hcount_in >= 993 && hcount_in <= 1013)) {rgb_out_nxt} = 12'hC_1_2;
        else {rgb_out_nxt} = 12'h8_8_8;    
    end
end
    
endmodule
