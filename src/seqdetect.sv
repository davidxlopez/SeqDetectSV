/////////////////////////////////////
// RTL to Detect Sequence "00111100"
/////////////////////////////////////
`timescale 1ns/1ps

module seqdetect (
input   din,
input   clk,
input   rst,
output  reg flag
);

// enum int unsigned {S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8} current_state, next_state;

enum shortint unsigned {
S0 = 16'b0000000000000001,
S1 = 16'b0000000000000010,
S2 = 16'b0000000000000100,
S3 = 16'b0000000000001000,
S4 = 16'b0000000000010000,
S5 = 16'b0000000000100000,
S6 = 16'b0000000001000000,
S7 = 16'b0000000010000000,
S8 = 16'b0000000100000000
} current_state, next_state;

reg flag_rom;

/////////////////////////////////////
// FSM to Detect Sequence "00111100" 
/////////////////////////////////////
always@(current_state or din)
begin
next_state <= S0;
case (current_state)
    S0: begin  // Epsilon
          flag_rom <= 0;
	      if (din == 1'b0)
            next_state <= S1;
          else
            next_state <= S0;
        end        
    S1: begin  // "0..."
          flag_rom <= 0;
          if (din == 1'b0)
            next_state <= S2;
          else
            next_state <= S0;
        end        
    S2: begin  // "00..."
          flag_rom <= 0;
          if (din == 1'b1)
            next_state <= S3;
          else   
            next_state <= S2;
        end      
    S3: begin  // "001..."
          flag_rom <= 0;
          if (din == 1'b1)
            next_state <= S4;
          else
            next_state <= S1;
        end       
    S4: begin  // "0011..."
          flag_rom <= 0;
          if (din == 1'b1)
            next_state <= S5;
          else
            next_state <= S1;
        end        
    S5: begin  // "00111..."
          flag_rom <= 0;
          if (din == 1'b1)
            next_state <= S6;
          else
            next_state <= S1;
        end                  
    S6: begin  // "001111..."
          flag_rom <= 0;
          if (din == 1'b0)
            next_state <= S7;
          else
            next_state <= S0;
        end                   
    S7: begin  // "0011110..."
          if (din == 1'b0) begin   // pattern "00111100" detected
	        flag_rom <= 1;         // raise flag
            next_state <= S8;
          end
	      else begin
            flag_rom <= 0;
	        next_state <= S0;
	      end
        end
    S8: begin  
          flag_rom <= 1;           // keep the flag raised for 2nd cycle
	      if (din == 1'b0)         // overlap pattern "00..."
            next_state <= S2;
          else                     // overlap pattern "001..."
            next_state <= S3;
	    end
	default: next_state <= S0;
endcase
end

////////////////////////////////////////
// Next State Assigned to Current State
////////////////////////////////////////
always@(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= S0;
    flag <= 0;
  end
  else begin
    current_state <= next_state;
    flag <= flag_rom;
  end
end

endmodule

