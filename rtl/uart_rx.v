//Listing 8.1
//It is code from our lab, but edited to our needs
/*
Edit authors:
Orze³ £ukasz
Œwiebocki Jakub
*/
module uart_rx
   (
    input wire clk, reset,
    input wire rx, s_tick,
    output reg rx_done_tick,
    output wire [7:0] dout
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

   // body
   // FSMD state & DATA registers
   always @(posedge clk)
      if (reset)
         begin
            state_reg <= IDLE;
            counter <= 0;
            bit_counter <= 0;
            data_temp <= 0;
         end
      else
         begin
            state_reg <= state_next;
            counter <= counter_nxt;
            bit_counter <= bit_counter_nxt;
            data_temp <= data_temp_nxt;
         end

   // FSMD next-state logic
   always @*
   begin
      state_next = state_reg;
      rx_done_tick = 1'b0;
      counter_nxt = counter;
      bit_counter_nxt = bit_counter;
      data_temp_nxt = data_temp;
      case (state_reg)
         IDLE:
            if (~rx)
               begin
                  state_next = START;
                  counter_nxt = 0;
               end
         START:
            if (s_tick)
               if (counter == 7)
                  begin
                     state_next = DATA;
                     counter_nxt = 0;
                     bit_counter_nxt = 0;
                  end
               else
                  counter_nxt = counter + 1;
         DATA:
            if (s_tick)
               if (counter == 15)
                  begin
                     counter_nxt = 0;
                     data_temp_nxt = {rx, data_temp[7:1]};
                     if (bit_counter == 7)
                        state_next = STOP ;
                      else
                        bit_counter_nxt = bit_counter + 1;
                   end
               else
                  counter_nxt = counter + 1;
         STOP:
            if (s_tick)
               if (counter == 15)
                  begin
                     state_next = IDLE;
                     rx_done_tick =1'b1;
                  end
               else
                  counter_nxt = counter + 1;
      endcase
   end
   // output
   assign dout = data_temp;

endmodule