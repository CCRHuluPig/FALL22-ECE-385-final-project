//-------------------------------------------------------------------------
//    monster.sv                                                            
//    based on the ball.sv provided in lab6
//    edited by JS
//    used for ECE 385fFA22 final project
//    2022/11/24
//-------------------------------------------------------------------------
module monster (  input Clk, Reset, frame_clk,
				      input gene, hit, beat_monster,//added to check if monster should disappear. 12/1
                  input [9:0] DrawX, DrawY,
						input logic monster_state, // added to check the state
						input [9:0] distance, //added 12/3
						output logic is_monster,
						output [1:0] turn, //added to change the state
                  output [9:0]  Monster_X, Monster_Y, Monster_S,
				      output logic  appear  // if monster should appear. 12/1
				  ); 
						
////////// parameter and local val ////////////
	parameter [9:0] x_min = 10'd170;  // left edge 
	parameter [9:0] x_max = 10'd469;  // right edge
	parameter [9:0] monster_size = 10'd39; //half length of monster, modified previous19
	parameter [9:0] StartX = 10'd200;
	parameter [9:0] StartY = 10'd10;
	
	logic[9:0] speedx, speedy;
	logic check;
	logic [9:0] MonsterX, MonsterY, MonsterS;

	
	
/////////// add clk for monster appear /////////
// added 22/11/26
/*
   logic frame_delay_clk, frame_clk_rising;
	//logic monster_clk, monster_clk_rising;
	
	always_ff @ (posedge Clk)
		begin
			frame_clk_delay <= frame_clk;
			frame_clk_rising <= (frame_clk == 1'b1 && frmae_clk_delay == 1'b0);			
		end
*/

	
///////// the movement of the monster //////////
// only move left or right
	always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese	
				begin
					appear <= 1'b1; // change from 0 to 1
					speedx <= -1;
					speedy <= 0;
					turn <= 2'b00;
					MonsterX <= StartX;
					MonsterY <= StartY;
				end
			else
			begin
			
			//if (gene)
			    //begin
				   //appear <= 1'b1;
				 //end
				
			if (appear)
			begin
				if (hit || beat_monster)
					appear <= 1'b0;
				
				else if (MonsterY > 10'd479 || (MonsterY+10'd39) < 10'd0) //differnt from gyh  DOUBLE CHECK!
					appear <= 1'b0;
					
				
				else if (MonsterX + monster_size -1 >= x_max) // touch the right edge
					begin
						speedx <= -1;
						speedy <= 0;
						turn <= 2'b01;
					end
				else if (MonsterX <= x_min) // touch the left edge
					begin
						speedx <= 1;
						speedy <= 0;
						turn <= 2'b10;
					end
				else 
					begin
						speedx <= speedx;
						speedy <= speedy;
						turn <= turn;
					end
					// UPDATE
					MonsterX <= MonsterX + speedx;
					MonsterY <= MonsterY + speedy - distance;
					
			end
			end
			
		end


///////// check whether monster should appear or not ///////////
/*
	always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese	
				appear <= 1'b0;

*/


		
//////// check whether the pixel is monster ////////
	always_comb
		begin
			check = (DrawX <= (MonsterX + monster_size -1) &&
						DrawX >= (MonsterX) &&
						DrawY <= (MonsterY + monster_size -1) &&
						DrawY >= (MonsterY)
						);
			if (check && appear)
				is_monster = 1'b1;
			else
				is_monster = 1'b0;
					
		end
		
		
		
		
		
/////////// output ///////////
	assign Monster_S = (monster_size-1)/2;	
   assign Monster_X = MonsterX;
	assign Monster_Y = MonsterY;
	
		
		
endmodule	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		