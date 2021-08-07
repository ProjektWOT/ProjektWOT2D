//Listing 8.4
module uart
   #( // Default setting:    // 38,400 baud, 8 data bits, 1 stop bit, 2^2 FIFO
      parameter DBIT = 8,     // # data bits
                SB_TICK = 16, // # ticks for stop bits, 16/24/32    // for 1/1.5/2 stop bits
                DVSR = 106,   // baud rate divisor    // DVSR = 100M/(16*baud rate)
                DVSR_BIT = 8 // # bits of DVSR
   )
   (
    input wire clk, reset,
    input wire rx,
    input wire [9:0] X_POS_IN,
    input wire [9:0] Y_POS_IN,
    
    output wire tx,
    output wire [15:0] X_tank_pos,
    output wire [15:0] Y_tank_pos
   );

   // signal declaration
   wire tick, rx_done_tick, tx_done_tick, TX_START;
   wire [7:0] tx_fifo_out, rx_data_out, X_POS_OUT;

   //body
mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) BaudRate_Gen(
    .clk(clk), 
    .reset(reset),
     
    .q(), 
    .max_tick(tick)
    );

uart_rx Uart_RXD_Unit(
    .clk(clk),
    .reset(reset), 
    .rx(rx), 
    .s_tick(tick),
    
    .rx_done_tick(rx_done_tick), 
    .dout(rx_data_out)
    );

uart_tx Uart_TXD_Unit(
    .clk(clk), 
    .reset(reset), 
    .tx_start(TX_START),
    .s_tick(tick), 
    .din(X_POS_OUT),
    
    .tx_done_tick(tx_done_tick), 
    .tx(tx)
    );
       
RegisterRXD RegisterRXD(
    .clk(clk), 
    .rst(reset), 
    .rx_done(rx_done_tick),
    .current_rx(rx_data_out),
        
    .X_tank_pos(X_tank_pos),
    .Y_tank_pos(Y_tank_pos)
    );
       
RegisterTXD RegisterTXD(
    .clk(clk),
    .rst(reset),
    .XPosIn(X_POS_IN),
    .YPosIn(Y_POS_IN),
    .PosOut(X_POS_OUT),
    .TX_start(TX_START)
    );
    
endmodule