///////////////////////////////////////////////////
// Testbench for FSM to Detect Sequence "00111100"
///////////////////////////////////////////////////
`timescale 1ns/1ps

module tb_seqdetect;

  parameter ClockPeriod = 10;
  parameter Patterns = 25;
  parameter Width = 8;
  
  reg rst;
  reg din;
  reg [0:Width-1] tbdin [0:Patterns-1];  // 8-bit test vector

  wire clk;  // From clk0 of clk_gen.sv
  wire flag; // From det0 of seqdetect.sv
  wire [15:0] tb_current_state, tb_next_state;
  
  clk_gen #(ClockPeriod) clk0(.clk(clk));                        // Clock Generator
  seqdetect det0(.flag(flag), .din(din), .clk(clk), .rst(rst));  // DUT

  assign tb_current_state = det0.current_state;  // Make current_state Visible
  assign tb_next_state    = det0.next_state;     // Make next_state Visible

  initial begin
    rst = 1'b1;
    din = 1'b0;
    #ClockPeriod
    rst = 1'b0;
  end

  initial begin // Stimulus
	tbdin[0] =  8'b01010101;
	tbdin[1] =  8'b10101010;
	tbdin[2] =  8'b01100111;
	tbdin[3] =  8'b00111100; // Raise Flag
	tbdin[4] =  8'b11110000; // Raise Flag (overlap)
	tbdin[5] =  8'b11110000; // Raise Flag
	tbdin[6] =  8'b11111000;
	tbdin[7] =  8'b11111100;
	tbdin[8] =  8'b11111110;
	tbdin[9] =  8'b00111100; // Raise Flag
	tbdin[10] = 8'b10011111;
	tbdin[11] = 8'b11111100;
	tbdin[12] = 8'b00111100; // Raise Flag
	tbdin[13] = 8'b11110000; // Raise Flag (overlap)
	tbdin[14] = 8'b0;
	tbdin[15] = 8'b1;
	tbdin[16] = 8'b1;
	tbdin[17] = 8'b1;
	tbdin[18] = 8'b0;
	tbdin[19] = 8'b0;
	tbdin[20] = 8'b0;
	tbdin[21] = 8'b0;
	tbdin[22] = 8'b0;
	tbdin[23] = 8'b1;
	tbdin[24] = 8'b1;
  end
  
// Assign Stimulus
  integer i;
  integer j;
  initial begin
	#(ClockPeriod / 2)
    for (i = 0; i <= (Patterns-1); i = i + 1)
      for (j = 0; j <= (Width-1); j = j + 1) 
	    din = #ClockPeriod tbdin[i][j];
  end

endmodule // tb_seqdetect