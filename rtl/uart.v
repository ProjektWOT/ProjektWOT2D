//Listing 8.4
//Code from lab, edited to our needs
/*
Edit authors:
Orze³ £ukasz
Œwiebocki Jakub
*/
module uart #(          // Default setting: 38,400 baud, 8 data bits, 1 stop bit
parameter DVSR = 106,   // baud rate divisor DVSR = CLK/(16*baud rate)
          DVSR_BIT = 8  // bits of DVSR
)
(
    input wire clk,
    input wire reset,
    input wire rx,
    input wire [9:0] xpos_tank_uart_in,
    input wire [9:0] ypos_tank_uart_in,
    input wire [9:0] xpos_bullet_our_uart_in,
    input wire [9:0] ypos_bullet_our_uart_in,
    input wire [2:0] direction_for_enemy_uart_in,
    input wire tank_our_hit_uart_in,
    input wire obstacle_hit_uart_in,
    input wire [1:0] direction_tank_uart_in,
    input wire [7:0] hp_enemy_uart_in,
    
    output wire tx,
    output wire [15:0] xpos_tank_uart_out,
    output wire [15:0] ypos_tank_uart_out,
    output wire [9:0] xpos_bullet_our_uart_out,
    output wire [9:0] ypos_bullet_our_uart_out,
    output wire [2:0] direction_for_enemy_uart_out,
    output wire tank_our_hit_uart_out,
    output wire obstacle_hit_uart_out,
    output wire [1:0] direction_tank_uart_out,
    output wire [7:0] hp_our_uart_out
);
wire tick, rx_done_tick, tx_done_tick, tx_start;
wire [7:0] rx_data_out, data_out;

//Modules
//****************************************************************************************************************//
//BaudRateGen
mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) BaudRate_Gen(
    .clk(clk), 
    .reset(reset),
     
    .max_tick(tick)
    );

//RXD Modules
uart_rx uart_rx(
    .clk(clk),
    .reset(reset), 
    .rx(rx), 
    .s_tick(tick),
    
    .rx_done_tick(rx_done_tick), 
    .dout(rx_data_out)
);

register_rxd register_rxd(
    .clk(clk), 
    .rst(reset), 
    .rx_done(rx_done_tick),
    .current_rx(rx_data_out),
            
    .xpos_tank_uart_out(xpos_tank_uart_out),
    .ypos_tank_uart_out(ypos_tank_uart_out),
    .xpos_bullet_our_uart_out(xpos_bullet_our_uart_out),
    .ypos_bullet_our_uart_out(ypos_bullet_our_uart_out),
    .direction_for_enemy_uart_out(direction_for_enemy_uart_out),
    .tank_our_hit_uart_out(tank_our_hit_uart_out),
    .obstacle_hit_uart_out(obstacle_hit_uart_out),
    .direction_tank_uart_out(direction_tank_uart_out),
    .hp_our_uart_out(hp_our_uart_out)
);

//TXD Modules
uart_tx uart_tx(
    .clk(clk), 
    .reset(reset), 
    .tx_start(tx_start),
    .s_tick(tick), 
    .din(data_out),
    
    .tx_done_tick(tx_done_tick), 
    .tx(tx)
); 

register_txd register_txd(
    .clk(clk),
    .rst(reset),
    .xpos_tank_uart_in(xpos_tank_uart_in),
    .ypos_tank_uart_in(ypos_tank_uart_in),
    .xpos_bullet_our_uart_in(xpos_bullet_our_uart_in),
    .ypos_bullet_our_uart_in(ypos_bullet_our_uart_in),
    .direction_for_enemy_uart_in(direction_for_enemy_uart_in),
    .tank_our_hit_uart_in(tank_our_hit_uart_in),
    .obstacle_hit_uart_in(obstacle_hit_uart_in),
    .direction_tank_uart_in(direction_tank_uart_in),
    .hp_enemy_uart_in(hp_enemy_uart_in),
    
    .data_out(data_out),
    .tx_start(tx_start)
);

endmodule