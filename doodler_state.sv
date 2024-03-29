// doodler_state.sv
// created 22/11/16

module doodler_state ( input Reset, frame_clk,
                       input [7:0] keycode,
							  input [7:0] keycode_ext,
 							  output [1:0] state								
							 );
							 
////////// local parameter //////////
logic [4:0] delay, next_delay;
//////// end local parameter ////////							 
	
// always_ff @ (posedge Reset or posedge frame_clk)
				
enum logic [1:0] {right, left, shooting} current_state, next_state;

assign state = current_state;

always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if (Reset)
			begin
				current_state <= right;
				delay <= 5'd0;
				//next_delay <= 5'd0;//added
			end
		else
			begin
				current_state <= next_state;
				delay <= next_delay;
			end		
	end

always_comb
	begin
		next_state = current_state;
		next_delay = 5'd0;
		
		case(current_state)
		
		right:
			if ((keycode[7:0] == 8'h04) || (keycode_ext[7:0] == 8'h04))
				next_state = left;
			else if ((keycode[7:0] == 8'd82) || (keycode_ext[7:0] == 8'd82) ||
						(keycode[7:0] == 8'd80) || (keycode_ext[7:0] == 8'd80) ||
						(keycode[7:0] == 8'd79) || (keycode_ext[7:0] == 8'd79))
				next_state = shooting;
			else
				next_state = right;
				
		left:
			if ((keycode[7:0] == 8'h07) || (keycode_ext[7:0] == 8'h07))
				next_state = right;
			else if ((keycode[7:0] == 8'd82) || (keycode_ext[7:0] == 8'd82) ||
						(keycode[7:0] == 8'd80) || (keycode_ext[7:0] == 8'd80) ||
						(keycode[7:0] == 8'd79) || (keycode_ext[7:0] == 8'd79))
				next_state = shooting;
			else
				next_state = left;
			
		shooting:
		begin
			next_delay = delay + 1;
			if (delay == 5'd20)
			begin
				next_state = right;
				next_delay = 5'd0;
			end
			else
				next_state = shooting;
		end
		
		default: next_state = right;
		
		endcase
		
	end
	
	
	
endmodule	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	