//Listing 8.3
//It is code from our lab, but edited to our needs
/*
Edit authors:
Orze³ £ukasz
Œwiebocki Jakub
*/
module uart_tx
   (
    input wire clk, reset,
    input wire tx_start, s_tick,
    input wire [7:0] din,
    output reg tx_done_tick,
    output wire tx
   );

   // symbolic state declaration
   localparam [1:0]
      IDLE  = 2'b00,
      START = 2'b01,
      DATA  = 2'b10,
      STOP  = 2'b11;

   // signal declaration
   reg [1:0] state_reg, state_next;
   reg [3:0] counter, counter_nxt;
   reg [2:0] bit_counter, bit_counter_nxt;
   reg [7:0] data_temp, data_temp_nxt;
   reg tx_reg, tx_next;

   // body
   // FSMD state & DATA registers
   always @(posedge clk)
      if (reset)
         begin
            state_reg <= IDLE;
            counter <= 0;
            bit_counter <= 0;
            data_temp <= 0;
            tx_reg <= 1'b1;
         end
      else
         begin
            state_reg <= state_next;
            counter <= counter_nxt;
            bit_counter <= bit_counter_nxt;
            data_temp <= data_temp_nxt;
            tx_reg <= tx_next;
         end

   // FSMD next-state logic & functional units
   always @*
   begin
      state_next = state_reg;
      tx_done_tick = 1'b0;
      counter_nxt = counter;
      bit_counter_nxt = bit_counter;
      data_temp_nxt = data_temp;
      tx_next = tx_reg ;
      case (state_reg)
         IDLE:
            begin
               tx_next = 1'b1;
               if (tx_start)
                  begin
                     state_next = START;
                     counter_nxt = 0;
                     data_temp_nxt = din;
                  end
            end
         START:
            begin
               tx_next = 1'b0;
               if (s_tick)
                  if (counter == 15)
                     begin
                        state_next = DATA;
                        counter_nxt = 0;
                        bit_counter_nxt = 0;
                     end
                  else
                     counter_nxt = counter + 1;
            end
         DATA:
            begin
               tx_next = data_temp[0];
               if (s_tick)
                  if (counter == 15)
                     begin
                        counter_nxt = 0;
                        data_temp_nxt = data_temp >> 1;
                        if (bit_counter == 7)
                           state_next = STOP ;
                        else
                           bit_counter_nxt = bit_counter + 1;
                     end
                  else
                     counter_nxt = counter + 1;
            end
         STOP:
            begin
               tx_next = 1'b1;
               if (s_tick)
                  if (counter == 15)
                     begin
                        state_next = IDLE;
                        tx_done_tick = 1'b1;
                     end
                  else
                     counter_nxt = counter + 1;
            end
      endcase
   end
   // output
   assign tx = tx_reg;

endmodule