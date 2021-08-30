//Listing 8.4
module uart #(          // Default setting: 38,400 baud, 8 data bits, 1 stop bit
parameter DVSR = 106,   // baud rate divisor DVSR = CLK/(16*baud rate)
          DVSR_BIT = 8  // bits of DVSR
)
(
input wire clk,
input wire reset,
input wire rx,
input wire [9:0] XPosInTank,
input wire [9:0] YPosInTank,
input wire [9:0] xpos_bullet_green_toUART,
input wire [9:0] ypos_bullet_green_toUART,
input wire [2:0] direction_for_enemy_toUART,
input wire tank_our_hit_toUART,
input wire obstacle_hit_toUART,
input wire [1:0] direction_tank_to_UART,
input wire [7:0] HP_enemy_state_toUART,

output wire tx,
output wire [15:0] X_tank_pos,
output wire [15:0] Y_tank_pos,
output wire [9:0] xpos_bullet_green_fromUART,
output wire [9:0] ypos_bullet_green_fromUART,
output wire [2:0] direction_for_enemy_fromUART,
output wire tank_our_hit_fromUART,
output wire obstacle_hit_fromUART,
output wire [1:0] direction_tank_fromUART,
output wire [7:0] HP_our_state_fromUART
);
wire tick, rx_done_tick, tx_done_tick, TX_START;
wire [7:0] rx_data_out, DataPosOut;

//Modules
//****************************************************************************************************************//
//BaudRateGen
mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) BaudRate_Gen(
    .clk(clk), 
    .reset(reset),
     
    .max_tick(tick)
    );

//RXD Modules
uart_rx Uart_RXD_Unit(
    .clk(clk),
    .reset(reset), 
    .rx(rx), 
    .s_tick(tick),
    
    .rx_done_tick(rx_done_tick), 
    .dout(rx_data_out)
    );
RegisterRXD RegisterRXD(
    .clk(clk), 
    .rst(reset), 
    .rx_done(rx_done_tick),
    .current_rx(rx_data_out),
            
    .X_tank_pos(X_tank_pos),
    .Y_tank_pos(Y_tank_pos),
    .xpos_bullet_green_fromUART(xpos_bullet_green_fromUART),
    .ypos_bullet_green_fromUART(ypos_bullet_green_fromUART),
    .direction_for_enemy_fromUART(direction_for_enemy_fromUART),
    .tank_our_hit_fromUART(tank_our_hit_fromUART),
    .obstacle_hit_fromUART(obstacle_hit_fromUART),
    .direction_tank_fromUART(direction_tank_fromUART),
    .HP_our_state_fromUART(HP_our_state_fromUART)
    );

//TXD Modules
uart_tx Uart_TXD_Unit(
    .clk(clk), 
    .reset(reset), 
    .tx_start(TX_START),
    .s_tick(tick), 
    .din(DataPosOut),
    
    .tx_done_tick(tx_done_tick), 
    .tx(tx)
    ); 
RegisterTXD RegisterTXD(
    .clk(clk),
    .rst(reset),
    .XPosTankIn(XPosInTank),
    .YPosTankIn(YPosInTank),
    .xpos_bullet_green_toUART(xpos_bullet_green_toUART),
    .ypos_bullet_green_toUART(ypos_bullet_green_toUART),
    .direction_for_enemy_toUART(direction_for_enemy_toUART),
    .tank_our_hit_toUART(tank_our_hit_toUART),
    .obstacle_hit_toUART(obstacle_hit_toUART),
    .direction_tank_to_UART(direction_tank_to_UART),
    .HP_enemy_state_toUART(HP_enemy_state_toUART),
    
    .DataPosOut(DataPosOut),
    .TX_start(TX_START)
    );
endmodule
