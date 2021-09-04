`timescale 1ns / 1ps
/*
Authors:
Orze³ £ukasz
Œwiebocki Jakub 
*/
module draw_map(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire [9:0]  vcount_in,
    input wire hblnk_in,
    input wire vblnk_in,
    
    output reg [11:0] rgb_out
);

//Registers and Localparams
//****************************************************************************************************************//  
reg [11:0] rgb_out_nxt, rgb_out_temp;

//COLOURS
localparam WHITE        = 12'hf_f_f;
localparam BLACK        = 12'h0_0_0;
localparam CLARET       = 12'h7_2_0;
localparam GRAY         = 12'h7_7_7;
localparam BROWN        = 12'h7_4_0;
localparam DARK_BROWN   = 12'h5_1_2;
localparam DARK_YELLOW  = 12'hD_A_0;
localparam LIGHT_GRAY   = 12'h8_9_F;
localparam DARK_GRAY    = 12'h4_4_5;
localparam DARK_GREEN   = 12'h1_4_0;
localparam GREEN        = 12'h1_5_0;
localparam YELLOW       = 12'hE_C_1;
localparam RED          = 12'hC_1_2;
localparam GRAY_BACK    = 12'h8_8_8;

/**********ELEMENTS OF MAP**********/
//BORDERS
localparam BORDER_LEFT_UP = 1;
localparam BORDER_RIGHT1  = 1022; 
localparam BORDER_RIGHT2  = 1023; 
localparam BORDER_RIGHT3  = 767; 
localparam BORDER_RIGHT4  = 768;  
localparam BORDER_DOWN1   = 766;
localparam BORDER_DOWN2   = 767;
//"H"
localparam H_1  = 96;  
localparam H_2  = 151; 
localparam H_3  = 341;     
localparam H_4  = 351; 
localparam H_5  = 371; 
localparam H_6  = 381;
localparam H_7  = 115; 
localparam H_8  = 125;
localparam H_9  = 350; 
localparam H_10 = 372;  
//FILLING THE CHIMNEY AND TIRES
localparam C_T_1  = 579; 
localparam C_T_2  = 583;
localparam C_T_3  = 419;
localparam C_T_4  = 425;
localparam C_T_5  = 755; 
localparam C_T_6  = 726;
localparam C_T_7  = 730;
localparam C_T_8  = 744; 
localparam C_T_9  = 738;
localparam C_T_10 = 742;
//CHIMNEY
localparam C_1 = 574;
localparam C_2 = 588; 
localparam C_3 = 414;
localparam C_4 = 430;
//BUILIDNGS
localparam B_1 = 563;
localparam B_2 = 642; 
localparam B_3 = 291;
localparam B_4 = 452; 
localparam B_5 = 81;
localparam B_6 = 170; 
localparam B_7 = 308;
localparam B_8 = 440; 
//TRACK BEAMS
localparam T_B_1  = 337;
localparam T_B_2  = 367; 
localparam T_B_3  = 23;
localparam T_B_4  = 26; 
localparam T_B_5  = 61;
localparam T_B_6  = 64; 
localparam T_B_7  = 99;
localparam T_B_8  = 102; 
localparam T_B_9  = 137;
localparam T_B_10 = 140; 
localparam T_B_11 = 175;
localparam T_B_12 = 178; 
localparam T_B_13 = 213;
localparam T_B_14 = 216; 
localparam T_B_15 = 251;
localparam T_B_16 = 254; 
localparam T_B_17 = 289; 
localparam T_B_18 = 292;
localparam T_B_19 = 327; 
localparam T_B_20 = 330;
localparam T_B_21 = 365; 
localparam T_B_22 = 368;
localparam T_B_23 = 403; 
localparam T_B_24 = 406;
localparam T_B_25 = 441; 
localparam T_B_26 = 444;
localparam T_B_27 = 479; 
localparam T_B_28 = 482;
localparam T_B_29 = 517; 
localparam T_B_30 = 520;
localparam T_B_31 = 555; 
localparam T_B_32 = 558;
localparam T_B_33 = 593; 
localparam T_B_34 = 596;
localparam T_B_35 = 631; 
localparam T_B_36 = 634;
localparam T_B_37 = 669; 
localparam T_B_38 = 672;
localparam T_B_39 = 707; 
localparam T_B_40 = 710;
localparam T_B_41 = 745; 
localparam T_B_42 = 748;    
//TRACKS
localparam T_1 = 335; 
localparam T_2 = 338; 
localparam T_3 = 366; 
localparam T_4 = 369;
localparam T_5 = 2; 
localparam T_6 = 766; 
//WALLS  
localparam W_1 = 377; 
localparam W_2 = 393; 
localparam W_3 = 38; 
localparam W_4 = 180;
localparam W_5 = 310; 
localparam W_6 = 328;
localparam W_7 = 269; 
localparam W_8 = 401; 
localparam W_9 = 376; 
localparam W_10 = 390;
localparam W_11 = 517; 
//STONES
localparam S_1  = 223;
localparam S_2  = 260;
localparam S_3  = 101;
localparam S_4  = 142;
localparam S_5  = 301;
localparam S_6  = 581;
localparam S_7  = 634;
localparam S_8  = 123;
localparam S_9  = 154;
localparam S_10 = 675;
localparam S_11 = 710;
localparam S_12 = 479;
localparam S_13 = 519;
localparam S_14 = 197;
localparam S_15 = 244;
localparam S_16 = 511;
localparam S_17 = 580;
localparam S_18 = 555;
localparam S_19 = 604;
localparam S_20 = 446;
localparam S_21 = 482;
localparam S_22 = 694;
localparam S_23 = 740;
//CATERPILLARS
localparam CP_1 = 64;
localparam CP_2 = 76;
localparam CP_3 = 693;
localparam CP_4 = 757;
localparam CP_5 = 102;
localparam CP_6 = 114;
//TURRET
localparam TR_1 = 40;
localparam TR_2 = 46;
localparam TR_3 = 700;
localparam TR_4 = 725;
localparam TR_5 = 733;
localparam TR_6 = 43;
localparam TR_7 = 12;
//VEHICLES
localparam V_1 = 745;
localparam V_2 = 754;
localparam V_3 = 723;
localparam V_4 = 744;
localparam V_5 = 77;
localparam V_6 = 101;
localparam V_7 = 700;
localparam V_8 = 751;
//BACKGROUND
localparam BG_1 = 2;
localparam BG_2 = 765;
localparam BG_3 = 766;
//EXIT_BUTTON
localparam EB_1 = 10;
localparam EB_2 = 30;
localparam EB_3 = 993;
localparam EB_4 = 1013;
//****************************************************************************************************************//  

//Sequential data execute
//****************************************************************************************************************//   
always@ (posedge clk) begin
    if (rst) rgb_out <= 0;    
    else begin
        rgb_out_temp <= rgb_out_nxt;
        rgb_out <= rgb_out_temp;
        end
end
 
 //Logic
//****************************************************************************************************************// 
always @* begin
    if (vblnk_in || hblnk_in) {rgb_out_nxt} = BLACK; 
    else begin
        if ((vcount_in >= 0 && vcount_in <= BORDER_LEFT_UP)||(vcount_in >= BORDER_DOWN1 && vcount_in <= BORDER_DOWN2)) {rgb_out_nxt} = WHITE;
        else if ((hcount_in >= 0 && hcount_in <= BORDER_LEFT_UP)||(hcount_in >= BORDER_RIGHT1 && hcount_in <= BORDER_RIGHT2)||(hcount_in >= BORDER_RIGHT3 && hcount_in <= BORDER_RIGHT4)) {rgb_out_nxt} = WHITE;
        
        //H
        else if ((vcount_in >= H_1 && vcount_in <= H_2)&&((hcount_in >= H_3 && hcount_in <= H_4)||(hcount_in >= H_5 && hcount_in <= H_6))||((vcount_in >= H_7 && vcount_in <= H_8) && (hcount_in >= H_9 && hcount_in <= H_10))) {rgb_out_nxt} = WHITE;
        
        //FILLING OF CHINEY + TIRES
        else if (((vcount_in >= C_T_1 && vcount_in <= C_T_2)&&(hcount_in >= C_T_3 && hcount_in <= C_T_4))||((vcount_in >= C_T_5 && vcount_in <= C_T_5)&&(hcount_in >= C_T_6 && hcount_in <= C_T_7))||
        ((vcount_in >= C_T_8 && vcount_in <= C_T_8)&&(hcount_in >= C_T_6 && hcount_in <= C_T_7))||((vcount_in >= C_T_5 && vcount_in <= C_T_5)&&(hcount_in >= C_T_9 && hcount_in <= C_T_10))||
        ((vcount_in >= C_T_8 && vcount_in <= C_T_8)&&(hcount_in >= C_T_9 && hcount_in <= C_T_10))) {rgb_out_nxt} = BLACK;
        
        //CHIMNEY
        else if ((vcount_in >= C_1 && vcount_in <= C_2)&&(hcount_in >= C_3 && hcount_in <= C_4)) {rgb_out_nxt} = CLARET;
        
        //BUILDINGS
        else if (((vcount_in >= B_1 && vcount_in <= B_2)&&(hcount_in >= B_3 && hcount_in <= B_4))||((vcount_in >= B_5 && vcount_in <= B_6)&&(hcount_in >= B_7 && hcount_in <= B_8))) {rgb_out_nxt} = GRAY;
        
        //TRACK BEAMS
        else if ((vcount_in >= T_B_1 && vcount_in <= T_B_2)&&((hcount_in >= T_B_3 && hcount_in <= T_B_4)||(hcount_in >= T_B_5 && hcount_in <= T_B_6)||(hcount_in >= T_B_7 && hcount_in <= T_B_8)|| 
        (hcount_in >= T_B_9 && hcount_in <= T_B_10)||(hcount_in >= T_B_11 && hcount_in <= T_B_12)||(hcount_in >= T_B_13 && hcount_in <= T_B_14)||(hcount_in >= T_B_15 && hcount_in <= T_B_16)|| 
        (hcount_in >= T_B_17 && hcount_in <= T_B_18)||(hcount_in >= T_B_19 && hcount_in <= T_B_20)||(hcount_in >= T_B_21 && hcount_in <= T_B_22)||(hcount_in >= T_B_23 && hcount_in <= T_B_24)||
        (hcount_in >= T_B_25 && hcount_in <= T_B_26)||(hcount_in >= T_B_27 && hcount_in <= T_B_28)||(hcount_in >= T_B_29 && hcount_in <= T_B_30)||(hcount_in >= T_B_31 && hcount_in <= T_B_32)||
        (hcount_in >= T_B_33 && hcount_in <= T_B_34)||(hcount_in >= T_B_35 && hcount_in <= T_B_36)||(hcount_in >= T_B_37 && hcount_in <= T_B_38)||(hcount_in >= T_B_39 && hcount_in <= T_B_40)|| 
        (hcount_in >= T_B_41 && hcount_in <= T_B_42))) {rgb_out_nxt} = BROWN;
        
        //TRACKS
        else if (((vcount_in >= T_1 && vcount_in <= T_2)||(vcount_in >= T_3 && vcount_in <= T_4))&&(hcount_in >= T_5 && hcount_in <= T_6)) {rgb_out_nxt} = DARK_BROWN;
        
        //WALLS
        else if (((vcount_in >= W_1 && vcount_in <= W_2)&&(hcount_in >= W_3 && hcount_in <= W_4))||((vcount_in >= W_5 && vcount_in <= W_6)&&(hcount_in >= W_7 && hcount_in <= W_8))||
        ((vcount_in >= W_9 && vcount_in <= W_10)&&(hcount_in >= W_10 && hcount_in <= W_11))) {rgb_out_nxt} = DARK_YELLOW;
        
        //STONES
        else if(((vcount_in >= S_1 && vcount_in <= S_2)&&(hcount_in >= S_3 && hcount_in <= S_4))||((vcount_in >= S_2 && vcount_in <= S_5)&&(hcount_in >= S_6 && hcount_in <= S_7))|| 
        ((vcount_in >= S_8 && vcount_in <= S_9)&&(hcount_in >= S_10 && hcount_in <= S_11))||((vcount_in >= S_12 && vcount_in <= S_13) && (hcount_in >= S_14 && hcount_in <= S_15))|| 
         ((vcount_in >= S_16 && vcount_in <= S_17)&&(hcount_in >= S_18 && hcount_in <= S_19))||((vcount_in >= S_20 && vcount_in <= S_21) && (hcount_in >= S_22 && hcount_in <= S_23))) {rgb_out_nxt} = LIGHT_GRAY;
        
        //CATERPILLARS
        else if (((vcount_in >= CP_1 && vcount_in <= CP_2)&&(hcount_in >= CP_3 && hcount_in <= CP_4))||((vcount_in >= CP_5 && vcount_in <= CP_6)&&(hcount_in >= CP_3 && hcount_in <= CP_4))) {rgb_out_nxt} = DARK_GRAY;
        
        //TANK TURRET
        else if (((vcount_in >= TR_1 && vcount_in <= TR_2)&&(hcount_in >= TR_3 && hcount_in <= TR_4))||((hcount_in-TR_5)*(hcount_in-TR_5)+(vcount_in-TR_6)*(vcount_in-TR_6) < TR_7*TR_7)) {rgb_out_nxt} = DARK_GREEN;
        
        //VEHICLES
        else if (((vcount_in >= V_1 && vcount_in <= V_2)&&(hcount_in >= V_3 && hcount_in <= V_4))||((vcount_in >= V_5 && vcount_in <= V_6)&&(hcount_in >= V_7 && hcount_in <= V_8))) {rgb_out_nxt} = GREEN;
        
        //BACKROUND
        else if ((vcount_in >= BG_1 && vcount_in <= BG_2)&&(hcount_in >= BG_1 && hcount_in <= BG_3)) {rgb_out_nxt} = YELLOW;
        
        //BUTTON
        else if ((vcount_in >= EB_1 && vcount_in <= EB_2)&&(hcount_in >= EB_3 && hcount_in <= EB_4)) {rgb_out_nxt} = RED;
        else {rgb_out_nxt} = GRAY_BACK;    
    end
end
    
endmodule
