//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input Clk, //frame_clk, Reset is added 11/29
							  input [9:0] BallX, BallY, DrawX, DrawY, Ball_size,                      
							  input [13:0][9:0] Stair_X, Stair_Y, // pos of stair
							  input [9:0] MonsterX, MonsterY, // added for monster position
							  input [13:0][9:0] toolX, toolY, toolS,//added 11/29
							  input [9:0] BulletX, BulletY, BulletS, //added 12/1
							  input [9:0] SBX, SBY, STX, STY, SNX, SNY, //added 11/29 start page
							  input [13:0] find,  // check if to draw stair 
							  input [2:0] is_doodler,
							  input logic is_monster, 
							  input [13:0] is_tool,
							  input logic is_bullet, //added 12/1
							  input logic is_sb, is_st, is_sn, //added 11/29 for start page
							  input [1:0] doodler_state,
							  input logic monster_state, //added for left and right monster
							  input appear, //dead, //drop,//added 11/27
							  input [2:0] show, // 0:play, 1:start, 2:game over, added 11/27
							  input [7:0] keycode, //addeed 11/27
							  input [7:0] keycode_ext,
                       output logic [7:0]  Red, Green, Blue );
    
//////////// local parameter ////////////
    logic ball_on;
	 
	 // address
	 logic [9:0]  stair_addr;
	 logic [10:0] left_doodler_addr, right_doodler_addr, shooting_doodler_addr;
	 logic [10:0] left_monster_addr, right_monster_addr;
	 logic [10:0] start_button_addr;
	 logic [15:0] start_title_addr;
	 logic [12:0] start_name_addr;
	 logic [7:0]  spring_addr;
	 logic [5:0]  bullet_addr;
	 
	 
	 // palette
	 logic [1:0] stair_plt;
	 logic [1:0] left_doodler_plt, right_doodler_plt, shooting_doodler_plt;
	 logic [2:0] left_monster_plt, right_monster_plt;
	 logic [1:0] start_button_plt;
	 logic       start_title_plt;
	 logic       start_name_plt;
	 logic       spring_plt;
	 logic [1:0] bullet_plt;
	 
	 // RGB
	 logic [23:0] stair_RGB;
	 logic [23:0] left_doodler_RGB, right_doodler_RGB, shooting_doodler_RGB;
	 logic [23:0] left_monster_RGB, right_monster_RGB;
	 logic [23:0] start_button_RGB, start_title_RGB, start_name_RGB;
	 logic [23:0] spring_RGB;
	 logic [23:0] bullet_RGB;



	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	 /* 
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
    */
//////////////////////// ASSIGN OBJECT ////////////////////////

// stair addr computation
parameter stair_w = 40;
parameter stair_h = 10;

int stair_hf_w, stair_hf_h, stair_mid_addr;
logic [13:0][9:0] stair_per_addr;

always_comb
	begin
		stair_hf_w = stair_w/2;
		stair_hf_h = stair_h/2;
		stair_mid_addr = (stair_hf_h-1) * stair_w + stair_hf_w;
		
		for (int i = 0; i < 14; i++)
			begin
				stair_per_addr[i] = stair_mid_addr - 1 + int'(DrawY-Stair_Y[i]) * stair_w 
				                                   + int'(DrawX-Stair_X[i]);
			end

		if (find[0])
					begin
						stair_addr = stair_per_addr[0];			
					end
		else if (find[1])
					begin
						stair_addr = stair_per_addr[1];			
					end
		else if (find[2])
					begin
						stair_addr = stair_per_addr[2];			
					end
		else if (find[3])
					begin
						stair_addr = stair_per_addr[3];			
					end
		else if (find[4])
					begin
						stair_addr = stair_per_addr[4];			
					end
		else if (find[5])
					begin
						stair_addr = stair_per_addr[5];			
					end
		else if (find[6])
					begin
						stair_addr = stair_per_addr[6];			
					end
		else if (find[7])
					begin
						stair_addr = stair_per_addr[7];			
					end
		else if (find[8])
					begin
						stair_addr = stair_per_addr[8];			
					end
		else if (find[9])
					begin
						stair_addr = stair_per_addr[9];			
					end
		else if (find[10])
					begin
						stair_addr = stair_per_addr[10];	
					end
		else if (find[11])
					begin
						stair_addr = stair_per_addr[11];				
					end
		else if (find[12])
					begin
						stair_addr = stair_per_addr[12];	
					end
		else if (find[13])
					begin
						stair_addr = stair_per_addr[13];	
					end
		else
					begin
						stair_addr = 0;
					end

	end

// doodler addr computation	

parameter doodler_w = 35;
parameter doodler_h = 35;
parameter s_doodler_w = 35;
parameter s_doodler_h = 39;

int hf_d_w, hf_d_h, s_hf_d_w, s_hf_d_h;
int dx, dy, s_dx, s_dy;
int mid_addr, s_mid_addr;

	always_comb
		begin
		
		   // left and right addr
			hf_d_w = (doodler_w-1)/2;
			hf_d_h = (doodler_h-1)/2;			
			dx = DrawX-BallX;
			dy = DrawY-BallY;
			mid_addr = hf_d_h * doodler_w + hf_d_w;
			right_doodler_addr = mid_addr + dy * doodler_w + dx;
			left_doodler_addr = mid_addr + dy * doodler_w + dx;
			
			// shooting addr
			s_hf_d_w = (s_doodler_w-1)/2;
			s_hf_d_h = (s_doodler_h-1)/2;
			s_dx = DrawX-BallX;
			s_dy = DrawY-BallY;
			s_mid_addr = s_hf_d_h * s_doodler_w + s_hf_d_w;
			shooting_doodler_addr = s_mid_addr + s_dy * s_doodler_w + s_dx;
		
		end
	
// monster addr computation
// added 22/11/24

parameter monster_w = 39;
parameter monster_h = 39;

int mdx, mdy;
int m_mid_addr;
int hf_m_w, hf_m_h;

	always_comb
		begin
			//hf_m_w = (monster_w-1)/2;
			//hf_m_h = (monster_h-1)/2;
			
			mdx = DrawX-MonsterX;
			mdy = DrawY-MonsterY;
			//m_mid_addr = hf_m_h * monster_w + hf_m_w;
			right_monster_addr = mdy * monster_w + mdx;
			left_monster_addr = mdy * monster_w + mdx; 
		end

		
		
		
		
// spring addr computation
// added 22/11/27
// spring addr computation
// added 22/11/27

parameter hf_tool_size = 7;
parameter tool_size = 15;
int tooldx, tooldy, tool_addr_min,temp;
logic [9:0] mid_tool_addr, mid_tool_min; 
logic [13:0][9:0] tool_addr;

	always_comb
		begin
			mid_tool_addr = hf_tool_size * tool_size + hf_tool_size;
			
			for (int j = 0; j < 14; j++)
				begin
					//if (toolS[j] != 0)
						tool_addr[j] = mid_tool_addr + (int' (DrawY-toolY[j]))* tool_size 
						                            + (int' (DrawX-toolX[j]));
				   // else
						//tool_addr[j] = 600;
				end
			//tool_addr[0] < (tool_size*tool_size) && tool_addr[0] >= 0
			if (is_tool[0])
				spring_addr = tool_addr[0];
			else if (is_tool[1])
				spring_addr = tool_addr[1];
			else if (is_tool[2])
				spring_addr = tool_addr[2];
			else if (is_tool[3])
				spring_addr = tool_addr[3];
			else if (is_tool[4])
				spring_addr = tool_addr[4];
			else if (is_tool[5])
				spring_addr = tool_addr[5];
			else if (is_tool[6])
				spring_addr = tool_addr[6];
			else if (is_tool[7])
				spring_addr = tool_addr[7];
			else if (is_tool[8])
				spring_addr = tool_addr[8];
			else if (is_tool[9])
				spring_addr = tool_addr[9];
			else if (is_tool[10])
				spring_addr = tool_addr[10];
			else if (is_tool[11])
				spring_addr = tool_addr[11];
			else if (is_tool[12])
				spring_addr = tool_addr[12];
			else if (is_tool[13])
				spring_addr = tool_addr[13];
			else
				spring_addr = 0;
			
		end
		

// bullet addr computation
// added 12/1

parameter bullet_s = 7;
parameter hf_bullet_size = 3;
int btdx, btdy;
int bt_mid_addr;

	always_comb
		begin
			btdx = DrawX - BulletX;
			btdy = DrawY - BulletY;
			bt_mid_addr = hf_bullet_size * bullet_s + hf_bullet_size;
			bullet_addr = bt_mid_addr + btdy * bullet_s + btdx;
		end
	
	

		
// start addr computation
// added 11/29

parameter start_button_s = 45;
parameter start_title_s = 201;
parameter start_name_s = 79;

int sbdx, sbdy, stdx, stdy, sndx, sndy;
int sb_mid_addr, st_mid_addr, sn_mid_addr;
int hf_sb_s, hf_st_s, hf_sn_s;

	always_comb
		begin
			hf_sb_s = (start_button_s-1)/2;
			hf_st_s = (start_title_s-1)/2;
			hf_sn_s = (start_name_s-1)/2;
			
			sbdx = DrawX-SBX;
			sbdy = DrawY-SBY;
			stdx = DrawX-STX;
			stdy = DrawY-STY;
			sndx = DrawX-SNX;
			sndy = DrawY-SNY;
			
			sb_mid_addr = hf_sb_s * start_button_s + hf_sb_s;
			start_button_addr = sb_mid_addr + sbdy * start_button_s + sbdx;
			
			st_mid_addr = hf_st_s * start_title_s + hf_st_s;
			start_title_addr = st_mid_addr + stdy * start_title_s + stdx;
			
			sn_mid_addr = hf_sn_s * start_name_s + hf_sn_s;
			start_name_addr = sn_mid_addr + sndy * start_name_s + sndx;
			

		end



//////////////////////// RGB DISPLAY /////////////////////////  
    always_comb
    begin:RGB_Display
	 
	     // outside color
		  if ( DrawX<170 || DrawX>469) // set outside black
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  
		  
		  // start page color
		  // 0:play, 1:start, 2:game over
		  // added 11/29
		  else if (show != 3'b0)
		  begin
			case (show)
			
			3'd1:
		   begin
			     if (is_sb)
						begin
							if (start_button_plt != 2'b11)
							begin
								Red = start_button_RGB[23:16];
								Green = start_button_RGB[15:8];
								Blue = start_button_RGB[7:0];
							end
							else
							begin
								Red = 8'h65; 
								Green = 8'h8e;
								Blue = 8'ha2;
							end
						end
						
					else if (is_st)
					   begin
							if (start_title_plt != 1'b1)
							begin
								Red = start_title_RGB[23:16];
								Green = start_title_RGB[15:8];
								Blue = start_title_RGB[7:0];
							end
							else
							begin
								Red = 8'h65; 
								Green = 8'h8e;
								Blue = 8'ha2;
							end
						end
						
					else if (is_sn)
						begin
							if (start_name_plt != 1'b1)
							begin
								Red = start_name_RGB[23:16];
								Green = start_name_RGB[15:8];
								Blue = start_name_RGB[7:0];
							end
							else
							begin
								Red = 8'h65; 
                        Green = 8'h8e;
                        Blue = 8'ha2;
							end
						end
						
					else
						begin
					      Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
						end
		  end
		  
		  3'd2:
						begin
					      Red = 8'hFF; 
                     Green = 8'hFF;
                     Blue = 8'hFF;
						end
			
			default:
						begin
							Red = 8'hFF;
							Green = 8'h00;
							Blue = 8'h00;
						end
		  endcase 
		  end
		  
		  // bullet color
		  // added 12/1
		  else if (is_bullet != 1'b0 && bullet_plt != 2'b10)
						begin
							Red = bullet_RGB[23:16]; 
							Green = bullet_RGB[15:8];
							Blue = bullet_RGB[7:0];
						end
		  
	  
		  
		  // doodler color
		  else if (is_doodler!= 3'b000)
		  
				case(doodler_state)
				
				2'b00: //right
					if (right_doodler_plt != 2'b11)
						begin
							Red = right_doodler_RGB[23:16];
							Green = right_doodler_RGB[15:8];
							Blue = right_doodler_RGB[7:0];
						end
					
					// added 12/3 for opt
					else if (is_monster != 1'b0 && appear)
					case (monster_state)
					
			      1'b0: //right monster
					if (right_monster_plt != 3'b110 && right_monster_plt != 3'b111) // not the bg color
						begin
							Red = right_monster_RGB[23:16];
							Green = right_monster_RGB[15:8];
							Blue = right_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end
						
					1'b1: //left monster
					if (left_monster_plt != 3'b110 && left_monster_plt != 3'b111) // not the bg color
						begin
							Red = left_monster_RGB[23:16];
							Green = left_monster_RGB[15:8];
							Blue = left_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
				
				   default: 
					begin 
						Red = 8'h65; 
						Green = 8'h8e;
						Blue = 8'ha2; 
					end 
			      endcase
						
					// end opt 12/3
						
					
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
					 
				2'b01: //left
					if (left_doodler_plt != 2'b11)
						begin
							Red = left_doodler_RGB[23:16];
							Green = left_doodler_RGB[15:8];
							Blue = left_doodler_RGB[7:0];
						end
						
							// added 12/3 for opt
					else if (is_monster != 1'b0 && appear)
					case (monster_state)
					
			      1'b0: //right monster
					if (right_monster_plt != 3'b110 && right_monster_plt != 3'b111) // not the bg color
						begin
							Red = right_monster_RGB[23:16];
							Green = right_monster_RGB[15:8];
							Blue = right_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end
						
					1'b1: //left monster
					if (left_monster_plt != 3'b110 && left_monster_plt != 3'b111) // not the bg color
						begin
							Red = left_monster_RGB[23:16];
							Green = left_monster_RGB[15:8];
							Blue = left_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
				
				   default: 
					begin 
						Red = 8'h65; 
						Green = 8'h8e;
						Blue = 8'ha2; 
					end 
			      endcase
						
					// end opt 12/3
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
				
				
				2'b10: //shooting
					if (shooting_doodler_plt != 2'b11)
						begin
							Red = shooting_doodler_RGB[23:16];
							Green = shooting_doodler_RGB[15:8];
							Blue = shooting_doodler_RGB[7:0];
						end
						
						
							// added 12/3 for opt
					else if (is_monster != 1'b0 && appear)
					case (monster_state)
					
			      1'b0: //right monster
					if (right_monster_plt != 3'b110 && right_monster_plt != 3'b111) // not the bg color
						begin
							Red = right_monster_RGB[23:16];
							Green = right_monster_RGB[15:8];
							Blue = right_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end
						
					1'b1: //left monster
					if (left_monster_plt != 3'b110 && left_monster_plt != 3'b111) // not the bg color
						begin
							Red = left_monster_RGB[23:16];
							Green = left_monster_RGB[15:8];
							Blue = left_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
				
				   default: 
					begin 
						Red = 8'h65; 
						Green = 8'h8e;
						Blue = 8'ha2; 
					end 
			      endcase
						
					// end opt 12/3
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end
						
				default: 
					begin 
						Red = 8'h65; 
						Green = 8'h8e;
						Blue = 8'ha2; 
					end   

				endcase
				
			
		  // monster color
		  // added 22/11/24
		  
		  else if (is_monster != 1'b0 && appear)
				case (monster_state)
					
			   1'b0: //right monster
					if (right_monster_plt != 3'b110 && right_monster_plt != 3'b111) // not the bg color
						begin
							Red = right_monster_RGB[23:16];
							Green = right_monster_RGB[15:8];
							Blue = right_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end
						
				1'b1: //left monster
					if (left_monster_plt != 3'b110 && left_monster_plt != 3'b111) // not the bg color
						begin
							Red = left_monster_RGB[23:16];
							Green = left_monster_RGB[15:8];
							Blue = left_monster_RGB[7:0];
						end
					else if (is_tool != 14'b0 && spring_plt != 1'b1)
					   begin
					      Red = spring_RGB[23:16];
					      Green = spring_RGB[15:8];
					      Blue = spring_RGB[7:0];
				      end
					else if (find != 14'b0 && stair_plt != 0)
						begin
							Red = stair_RGB[23:16];
							Green = stair_RGB[15:8];
							Blue = stair_RGB[7:0];
						end
					else
				      begin
							Red = 8'h65; 
                     Green = 8'h8e;
                     Blue = 8'ha2;
					   end	
				
				default: 
					begin 
						Red = 8'h65; 
						Green = 8'h8e;
						Blue = 8'ha2; 
					end 
			   endcase
				
		  // spring color
		  else if (is_tool != 14'b0 && spring_plt != 1'b1)
		  begin
			  Red = spring_RGB[23:16];
			  Green = spring_RGB[15:8];
			  Blue = spring_RGB[7:0];
		  end

		  
		  //stair color
		  else if (find != 14'b0 && stair_plt != 0)
		  begin
				Red = stair_RGB[23:16];
				Green = stair_RGB[15:8];
				Blue = stair_RGB[7:0];
		  end
		  
		  // background color 
        else 
        begin 
            Red = 8'h65; 
            Green = 8'h8e;
            Blue = 8'ha2; 
        end      
    end 
    


//////////////// PALETTE ////////////////////

// common stair
// ['0xFFFFFF', '0x000000','0xFFF143']
common_stair_RAM stair_palette(.read_address(stair_addr), .Clk(Clk), .data_out(stair_plt));

always_comb
	begin
		case(stair_plt)
			2'b00: stair_RGB = 24'h658EA2;
			2'b01: stair_RGB = 24'h000000;
			2'b10: stair_RGB = 24'hFFF143;
			default: stair_RGB = 24'hFFFFFF;
		endcase	
	end

	
// doodler
// ['0x000000', '0xFFFFFF', '0xE8DD35', '0xFF0000']

// ram
left_doodler_RAM left_doodler_palette(.read_address(left_doodler_addr), 
                                      .Clk(Clk), .data_out(left_doodler_plt));
												 
right_doodler_RAM right_doodler_palette(.read_address(right_doodler_addr), 
                                      .Clk(Clk), .data_out(right_doodler_plt));
												  
shooting_doodler_RAM shooting_doodler_palette(.read_address(shooting_doodler_addr), 
                                      .Clk(Clk), .data_out(shooting_doodler_plt));												

// left doodler
always_comb
	begin
		case(left_doodler_plt)
			2'b00: left_doodler_RGB = 24'h000000;
			2'b01: left_doodler_RGB = 24'hFFFFFF;
			2'b10: left_doodler_RGB = 24'hE8DD35;
			2'b11: left_doodler_RGB = 24'hFF0000;
		endcase	
	end


// right doodler
always_comb
	begin
		case(right_doodler_plt)
			2'b00: right_doodler_RGB = 24'h000000;
			2'b01: right_doodler_RGB = 24'hFFFFFF;
			2'b10: right_doodler_RGB = 24'hE8DD35;
			2'b11: right_doodler_RGB = 24'hFF0000;
		endcase	
	end
	
	
// shooting doodler
always_comb
	begin
		case(shooting_doodler_plt)
			2'b00: shooting_doodler_RGB = 24'h000000;
			2'b01: shooting_doodler_RGB = 24'hFFFFFF;
			2'b10: shooting_doodler_RGB = 24'hE8DD35;
			2'b11: shooting_doodler_RGB = 24'hFF0000;
		endcase	
	end

// monster 
// ['0x000000', '0xF0E5DD', '0xD1A167', '0x30955E', '0xF8AD1E', '0xB11E31', '0x65C8D3'] 
// # BLK, WHITE, EYE, GREEN, YELLOW, RED, BG

// ram
left_monster_RAM left_monster_palette(.read_address(left_monster_addr), 
                                      .Clk(Clk), .data_out(left_monster_plt));
												 
right_monster_RAM right_monster_palette(.read_address(right_monster_addr), 
                                      .Clk(Clk), .data_out(right_monster_plt));


// left_monster
always_comb
	begin
		case(left_monster_plt)
			3'b000: left_monster_RGB = 24'h000000;
			3'b001: left_monster_RGB = 24'hF0E5DD;
			3'b010: left_monster_RGB = 24'hD1A167;
			3'b011: left_monster_RGB = 24'h30955E;
			3'b100: left_monster_RGB = 24'hF8AD1E;
			3'b101: left_monster_RGB = 24'hB11E31;
			3'b110: left_monster_RGB = 24'h65C8D3;
			default: left_monster_RGB = 24'hFFFFFF;
		endcase
	end

// right_monster
always_comb
	begin
		case(right_monster_plt)
			3'b000: right_monster_RGB = 24'h000000;
			3'b001: right_monster_RGB = 24'hF0E5DD;
			3'b010: right_monster_RGB = 24'hD1A167;
			3'b011: right_monster_RGB = 24'h30955E;
			3'b100: right_monster_RGB = 24'hF8AD1E;
			3'b101: right_monster_RGB = 24'hB11E31;
			3'b110: right_monster_RGB = 24'h65C8D3;
			default: right_monster_RGB = 24'hFFFFFF;
		endcase
	end
	

// start page

//ram

start_button_RAM start_button_palette(.read_address(start_button_addr), 
                                      .Clk(Clk), .data_out(start_button_plt));
												 
start_title_RAM start_title_palette(.read_address(start_title_addr), 
                                      .Clk(Clk), .data_out(start_title_plt));
												  												  
start_name_RAM start_name_palette(.read_address(start_name_addr), 
                                      .Clk(Clk), .data_out(start_name_plt));

// start_button
// ['0x000000', '0x66D336', '0xF3F272', '0xFF0000'] 
// BLK, GREEN, YELLOW, RED
always_comb
	begin
		case(start_button_plt)
			2'b00: start_button_RGB = 24'h000000;
			2'b01: start_button_RGB = 24'h66D336;
			2'b10: start_button_RGB = 24'hF3F272;
			default: start_button_RGB = 24'hFF0000;
		endcase
	end
	
// start_title
// ['0xA00000', '0x06A000'] # RED, GREEN
always_comb
	begin
		case(start_title_plt)
			1'b0: start_title_RGB = 24'hA00000;
			1'b1: start_title_RGB = 24'h06A000;
			default: start_title_RGB = 24'hFFFFFF;
		endcase
	end
	
// start_name
// ['0x000000', '0xFF0000'] # BLK, RED
always_comb
	begin
		case(start_name_plt)
		   1'b0: start_name_RGB = 24'h000000;
			1'b1: start_name_RGB = 24'hFF0000;
			default: start_name_RGB = 24'hFFFFFF;	
		endcase
	end
	
	
// spring
// ['0x000000', '0xFF0000'] # BLK, RED

// ram
spring_RAM spring_palette (.read_address(spring_addr), 
                                      .Clk(Clk), .data_out(spring_plt));
always_comb
	begin
		case(spring_plt)
		   1'b0: spring_RGB = 24'h000000;
			1'b1: spring_RGB = 24'hFF0000;
			default: spring_RGB = 24'hFFFFFF;	
		endcase
	end


// bullet
// ['0x000000', '0xFFDA7F', '0xFF0000'] # BLK, BULLET, RED

// ram
bullet_RAM bullet_palette (.read_address(bullet_addr), 
                                      .Clk(Clk), .data_out(bullet_plt));
always_comb
	begin
		case(bullet_plt)
		   2'b00: bullet_RGB = 24'h000000;
			2'b01: bullet_RGB = 24'hFFDA7F;
			2'b10: bullet_RGB = 24'hFF0000;
			default: bullet_RGB = 24'h00FF00;	
		endcase
	end
	

///////////////END PALETTE //////////////////
endmodule










