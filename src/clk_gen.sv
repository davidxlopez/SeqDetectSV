`timescale 1ns/1ps

module clk_gen (output reg clk);

  parameter ClockPeriod = 10;

  initial
    begin
	  clk = 0;
	  forever
	    #(ClockPeriod / 2) clk = ~clk;
    end

endmodule // clk_gen