module rgb_selector(
    input logic [9:0] drawX, drawY, ballX, ballY, ghostX, ghostY, ghostX2, ghostY2, ghostX3, ghostY3, ghostX4, ghostY4,
    input logic frame_clk, Reset, lose,
    output logic [3:0] red, green, blue,
    output logic [31:0] score,
    input logic [9:0] Ball_X_Motion_next, Ball_Y_Motion_next,
    input logic [9:0] Ball_X_Motion, Ball_Y_Motion, 
    output logic [7:0] ghost_survival_timer, ghost_survival_timer2, ghost_survival_timer3, ghost_survival_timer4,
    input logic [9:0] ghost_X_Motion, ghost_Y_Motion, ghost_X2_Motion, ghost_Y2_Motion, ghost_X3_Motion, ghost_Y3_Motion, ghost_X4_Motion, ghost_Y4_Motion,
    input logic [9:0] ghost_X_Motion_next, ghost_Y_Motion_next, ghost_X2_Motion_next, ghost_Y2_Motion_next, ghost_X3_Motion_next, ghost_Y3_Motion_next, ghost_X4_Motion_next, ghost_Y4_Motion_next,
    input logic [9:0] ghost_X_prev, ghost_Y_prev, ghost_X2_prev, ghost_Y2_prev, ghost_X3_prev, ghost_Y3_prev, ghost_X4_prev, ghost_Y4_prev,
    input logic slow_ghost_intercept, slow_ghost_intercept2, slow_ghost_intercept3, slow_ghost_intercept4,
    output logic win
);
    logic [7:0] rom_addr_pacman, rom_addr_ghost, rom_addr_ghost2, rom_addr_ghost3, rom_addr_ghost4;
    logic [3:0] rom_right1, rom_right2, rom_left1, rom_left2, rom_up1, rom_up2, rom_down1, rom_down2, rom_q1, rom_ghost1, rom_ghost2, rom_ghost3, rom_ghost4;
    logic [3:0] rom_ghost1_right, rom_ghost1_left, rom_ghost1_down, rom_ghost1_up;
	logic [3:0] rom_ghost2_right, rom_ghost2_left, rom_ghost2_down, rom_ghost2_up;
    logic [3:0] rom_ghost3_right, rom_ghost3_left, rom_ghost3_down, rom_ghost3_up;
    logic [3:0] rom_ghost4_right, rom_ghost4_left, rom_ghost4_down, rom_ghost4_up;
    

    logic [3:0] ghost1r, ghost1g, ghost1b;
	logic [3:0] ghost2r, ghost2g, ghost2b;
    logic [3:0] ghost3r, ghost3g, ghost3b;
    logic [3:0] ghost4r, ghost4g, ghost4b;

    logic [3:0] wall_red, wall_green, wall_blue;
    
    
    logic [3:0] right_1_red, right_1_green, right_1_blue;
    logic [3:0] right_2_red, right_2_green, right_2_blue;

    logic [3:0] left_1_red, left_1_green, left_1_blue;
    logic [3:0] left_2_red, left_2_green, left_2_blue;

    logic [3:0] up_1_red, up_1_green, up_1_blue;
    logic [3:0] up_2_red, up_2_green, up_2_blue;
    
    logic [3:0] end_r, end_g, end_b;

    logic [3:0] down_1_red, down_1_green, down_1_blue;
    logic [3:0] down_2_red, down_2_green, down_2_blue;

    logic [3:0] red_ghost_rightr, red_ghost_rightg, red_ghost_rightb;
    logic [3:0] red_ghost_leftr, red_ghost_leftg, red_ghost_leftb;
    logic [3:0] red_ghost_downr, red_ghost_downg, red_ghost_downb;
    logic [3:0] red_ghost_upr, red_ghost_upg, red_ghost_upb;

	logic [3:0] red_ghost2_rightr, red_ghost2_rightg, red_ghost2_rightb;
    logic [3:0] red_ghost2_leftr, red_ghost2_leftg, red_ghost2_leftb;
    logic [3:0] red_ghost2_downr, red_ghost2_downg, red_ghost2_downb;
    logic [3:0] red_ghost2_upr, red_ghost2_upg, red_ghost2_upb;

    logic [3:0] red_ghost3_rightr, red_ghost3_rightg, red_ghost3_rightb;
    logic [3:0] red_ghost3_leftr, red_ghost3_leftg, red_ghost3_leftb;
    logic [3:0] red_ghost3_downr, red_ghost3_downg, red_ghost3_downb;
    logic [3:0] red_ghost3_upr, red_ghost3_upg, red_ghost3_upb;

    logic [3:0] red_ghost4_rightr, red_ghost4_rightg, red_ghost4_rightb;
    logic [3:0] red_ghost4_leftr, red_ghost4_leftg, red_ghost4_leftb;
    logic [3:0] red_ghost4_downr, red_ghost4_downg, red_ghost4_downb;
    logic [3:0] red_ghost4_upr, red_ghost4_upg, red_ghost4_upb;
    
    logic [3:0] pacright_red, pacright_green, pacright_blue;
    logic [3:0] pellet_red, pellet_blue, pellet_green;
    logic [3:0] score_red, score_blue, score_green;
    logic is_pellet_location;
    logic big_pellet_eaten;

    logic [9:0] pacman1, pacman2, temp2, counter, ghost1, ghost2, ghost3, ghost4, ghost5, ghost6, ghost7, ghost8;
    
    assign pacman1 = ballX-7;
	assign pacman2 = ballY-7;

	assign ghost1 = ghostX-8;
	assign ghost2 = ghostY-8;

	assign ghost3 = ghostX2-8;
	assign ghost4 = ghostY2-8;

    assign ghost5 = ghostX3-8;
	assign ghost6 = ghostY3-8;

    assign ghost7 = ghostX4-8;
	assign ghost8 = ghostY4-8;

	
    always_comb
    begin
        if ((win == 1 || lose == 1) && drawX >= 96 && drawX < 544)
        begin
            red = end_r;
            green = end_g;
            blue = end_b;
        end
        // print pacman right 1
        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 19 && (Ball_X_Motion_next == 10'd1 || Ball_X_Motion == 10'd1))
        begin
            red = right_1_red;
            green = right_1_green;
            blue = right_1_blue;
        end

        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 39 && (Ball_X_Motion_next == 10'd1 || Ball_X_Motion == 10'd1))
        begin
            red = right_2_red;
            green = right_2_green;
            blue = right_2_blue;
        end
        
        // print pacman left 1
        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 19 && (Ball_X_Motion_next == -10'd1 || Ball_X_Motion == -10'd1))
        begin
            red = left_1_red;
            green = left_1_green;
            blue = left_1_blue;
        end

        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 39 &&(Ball_X_Motion_next == -10'd1 || Ball_X_Motion == -10'd1))
        begin
            red = left_2_red;
            green = left_2_green;
            blue = left_2_blue;
        end
        
        // print pacman left 1
        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 19 && (Ball_Y_Motion_next == -10'd1 || Ball_Y_Motion == -10'd1))
        begin
            red = up_1_red;
            green = up_1_green;
            blue = up_1_blue;
        end

        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 39 &&(Ball_Y_Motion_next == -10'd1 || Ball_Y_Motion == -10'd1))
        begin
            red = up_2_red;
            green = up_2_green;
            blue = up_2_blue;
        end
        
        // print pacman down 1
        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 19 && (Ball_Y_Motion_next == 10'd1 || Ball_Y_Motion == 10'd1))
        begin
            red = down_1_red;
            green = down_1_green;
            blue = down_1_blue;
        end

        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 39 &&(Ball_Y_Motion_next == 10'd1 || Ball_Y_Motion == 10'd1))
        begin
            red = down_2_red;
            green = down_2_green;
            blue = down_2_blue;
        end
        
        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter <= 39 &&(Ball_Y_Motion_next == 10'd0 || Ball_Y_Motion == 10'd0))
        begin
            red = down_1_red;
            green = down_1_green;
            blue = down_1_blue;
        end

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        else if (drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8) && ghost_survival_timer != 0)
        begin
            red = ghost1r;
            green = ghost1g;
            blue = ghost1b;
        end
        
        else if (ghost_Y_Motion == 10'd0 && ghost_X_Motion == 10'd0 && drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8))
        begin
            if (ghost_X_prev == 10'd1)
            begin
                red = red_ghost_rightr;
                green = red_ghost_rightg;
                blue = red_ghost_rightb;
            end
            
            else if (ghost_X_prev == -10'd1)
            begin
                red = red_ghost_leftr;
                green = red_ghost_leftg;
                blue = red_ghost_leftb;
            end
            
            else if (ghost_Y_prev == 10'd1)
            begin
                red = red_ghost_downr;
                green = red_ghost_downg;
                blue = red_ghost_downb;
            end
            
            else
            begin
                red = red_ghost_upr;
                green = red_ghost_upg;
                blue = red_ghost_upb;
            end
        end
        
        // red ghost down
        else if (drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8) && (ghost_Y_Motion_next == 10'd1 || ghost_Y_Motion == 10'd1))
        begin
            red = red_ghost_downr;
            green = red_ghost_downg;
            blue = red_ghost_downb;
        end

        // red ghost up
        else if (drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8) && (ghost_Y_Motion_next == -10'd1 || ghost_Y_Motion == -10'd1))
        begin
            red = red_ghost_upr;
            green = red_ghost_upg;
            blue = red_ghost_upb;
        end

        // red ghost left
        else if (drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8) && (ghost_X_Motion_next == -10'd1 || ghost_X_Motion == -10'd1))
        begin
            red = red_ghost_leftr;
            green = red_ghost_leftg;
            blue = red_ghost_leftb;
        end

        // red ghost right
        else if (drawX < (ghostX+8) && drawX > (ghostX-8) && drawY < (ghostY+8) && drawY > (ghostY-8) && (ghost_X_Motion_next == 10'd1 || ghost_X_Motion == 10'd1))
        begin
            red = red_ghost_rightr;
            green = red_ghost_rightg;
            blue = red_ghost_rightb;
        end

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		else if (drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8) && ghost_survival_timer2 != 0)
        begin
            red = ghost2r;
            green = ghost2g;
            blue = ghost2b;
        end
        
        else if (ghost_Y2_Motion == 10'd0 && ghost_X2_Motion == 10'd0 && drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8))
        begin
            if (ghost_X2_prev == 10'd1)
            begin
                red = red_ghost2_rightr;
                green = red_ghost2_rightg;
                blue = red_ghost2_rightb;
            end
            
            else if (ghost_X2_prev == -10'd1)
            begin
                red = red_ghost2_leftr;
                green = red_ghost2_leftg;
                blue = red_ghost2_leftb;
            end
            
            else if (ghost_Y2_prev == 10'd1)
            begin
                red = red_ghost2_downr;
                green = red_ghost2_downg;
                blue = red_ghost2_downb;
            end
            
            else
            begin
                red = red_ghost2_upr;
                green = red_ghost2_upg;
                blue = red_ghost2_upb;
            end
        end
        
        // red ghost down
        else if (drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8) && (ghost_Y2_Motion_next == 10'd1 || ghost_Y2_Motion == 10'd1))
        begin
            red = red_ghost2_downr;
            green = red_ghost2_downg;
            blue = red_ghost2_downb;
        end

        // red ghost up
        else if (drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8) && (ghost_Y2_Motion_next == -10'd1 || ghost_Y2_Motion == -10'd1))
        begin
            red = red_ghost2_upr;
            green = red_ghost2_upg;
            blue = red_ghost2_upb;
        end

        // red ghost left
        else if (drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8) && (ghost_X2_Motion_next == -10'd1 || ghost_X2_Motion == -10'd1))
        begin
            red = red_ghost2_leftr;
            green = red_ghost2_leftg;
            blue = red_ghost2_leftb;
        end

        // red ghost right
        else if (drawX < (ghostX2+8) && drawX > (ghostX2-8) && drawY < (ghostY2+8) && drawY > (ghostY2-8) && (ghost_X2_Motion_next == 10'd1 || ghost_X2_Motion == 10'd1))
        begin
            red = red_ghost2_rightr;
            green = red_ghost2_rightg;
            blue = red_ghost2_rightb;
        end


		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        else if (drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8) && ghost_survival_timer3 != 0)
        begin
            red = ghost3r;
            green = ghost3g;
            blue = ghost3b;
        end
        
        else if (ghost_Y3_Motion == 10'd0 && ghost_X3_Motion == 10'd0 && drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8))
        begin
            if (ghost_X3_prev == 10'd1)
            begin
                red = red_ghost3_rightr;
                green = red_ghost3_rightg;
                blue = red_ghost3_rightb;
            end
            
            else if (ghost_X3_prev == -10'd1)
            begin
                red = red_ghost3_leftr;
                green = red_ghost3_leftg;
                blue = red_ghost3_leftb;
            end
            
            else if (ghost_Y3_prev == 10'd1)
            begin
                red = red_ghost3_downr;
                green = red_ghost3_downg;
                blue = red_ghost3_downb;
            end
            
            else
            begin
                red = red_ghost3_upr;
                green = red_ghost3_upg;
                blue = red_ghost3_upb;
            end
        end
        
        // red ghost down
        else if (drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8) && (ghost_Y3_Motion_next == 10'd1 || ghost_Y3_Motion == 10'd1))
        begin
            red = red_ghost3_downr;
            green = red_ghost3_downg;
            blue = red_ghost3_downb;
        end

        // red ghost up
        else if (drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8) && (ghost_Y3_Motion_next == -10'd1 || ghost_Y3_Motion == -10'd1))
        begin
            red = red_ghost3_upr;
            green = red_ghost3_upg;
            blue = red_ghost3_upb;
        end

        // red ghost left
        else if (drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8) && (ghost_X3_Motion_next == -10'd1 || ghost_X3_Motion == -10'd1))
        begin
            red = red_ghost3_leftr;
            green = red_ghost3_leftg;
            blue = red_ghost3_leftb;
        end

        // red ghost right
        else if (drawX < (ghostX3+8) && drawX > (ghostX3-8) && drawY < (ghostY3+8) && drawY > (ghostY3-8) && (ghost_X3_Motion_next == 10'd1 || ghost_X3_Motion == 10'd1))
        begin
            red = red_ghost3_rightr;
            green = red_ghost3_rightg;
            blue = red_ghost3_rightb;
        end

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        else if (drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8) && ghost_survival_timer4 != 0)
        begin
            red = ghost4r;
            green = ghost4g;
            blue = ghost4b;
        end
        
        else if (ghost_Y4_Motion == 10'd0 && ghost_X4_Motion == 10'd0 && drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8))
        begin
            if (ghost_X4_prev == 10'd1)
            begin
                red = red_ghost4_rightr;
                green = red_ghost4_rightg;
                blue = red_ghost4_rightb;
            end
            
            else if (ghost_X4_prev == -10'd1)
            begin
                red = red_ghost4_leftr;
                green = red_ghost4_leftg;
                blue = red_ghost4_leftb;
            end
            
            else if (ghost_Y4_prev == 10'd1)
            begin
                red = red_ghost4_downr;
                green = red_ghost4_downg;
                blue = red_ghost4_downb;
            end
            
            else
            begin
                red = red_ghost4_upr;
                green = red_ghost4_upg;
                blue = red_ghost4_upb;
            end
        end
        
        // red ghost down
        else if (drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8) && (ghost_Y4_Motion_next == 10'd1 || ghost_Y4_Motion == 10'd1))
        begin
            red = red_ghost4_downr;
            green = red_ghost4_downg;
            blue = red_ghost4_downb;
        end

        // red ghost up
        else if (drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8) && (ghost_Y4_Motion_next == -10'd1 || ghost_Y4_Motion == -10'd1))
        begin
            red = red_ghost4_upr;
            green = red_ghost4_upg;
            blue = red_ghost4_upb;
        end

        // red ghost left
        else if (drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8) && (ghost_X4_Motion_next == -10'd1 || ghost_X4_Motion == -10'd1))
        begin
            red = red_ghost4_leftr;
            green = red_ghost4_leftg;
            blue = red_ghost4_leftb;
        end

        // red ghost right
        else if (drawX < (ghostX4+8) && drawX > (ghostX4-8) && drawY < (ghostY4+8) && drawY > (ghostY4-8) && (ghost_X4_Motion_next == 10'd1 || ghost_X4_Motion == 10'd1))
        begin
            red = red_ghost4_rightr;
            green = red_ghost4_rightg;
            blue = red_ghost4_rightb;
        end

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//        else if (drawX < (ballX+8) && drawX > (ballX-8) && drawY < (ballY+8) && drawY > (ballY-8) && counter >= 3)
//        begin
//            red = pacright_red;
//            green = pacright_green;
//            blue = pacright_blue;
//        end
        // print pellet
        else if (is_pellet_location)
        begin
            red = pellet_red;
            green = pellet_green;
            blue = pellet_blue;
        end
           
        // print wall    
        else if (drawX >= 96 && drawX < 544)
        begin
            red = wall_red;
            green = wall_green;
            blue = wall_blue;
        end
        
        // print score
        else if ((drawX >= 552 && drawY < 16) && win == 0 && lose == 0)
        begin
            red = score_red;
            green = score_green;
            blue = score_blue;
        end
        
        else 
        begin
            red = 4'h0;
            blue = 4'h0;
            green = 4'h0;
        end
    end
    
    always_ff @(posedge frame_clk)
    begin
        if (Reset)
        begin
            ghost_survival_timer <= 0;
        end
        else if (big_pellet_eaten == 1'b1)
        begin
            ghost_survival_timer <= 250;
        end
        else if (slow_ghost_intercept == 1)
        begin
            ghost_survival_timer <= 0;
        end
        else
        begin
            if (ghost_survival_timer != 0)
                ghost_survival_timer <= ghost_survival_timer - 1;
        end
    end

    always_ff @(posedge frame_clk)
    begin
        if (Reset)
        begin
            ghost_survival_timer2 <= 0;
        end
        else if (big_pellet_eaten == 1'b1)
        begin
            ghost_survival_timer2 <= 250;
        end
        else if (slow_ghost_intercept2 == 1)
        begin
            ghost_survival_timer2 <= 0;
        end
        else
        begin
            if (ghost_survival_timer2 != 0)
                ghost_survival_timer2 <= ghost_survival_timer2 - 1;
        end
    end
    
    always_ff @(posedge frame_clk)
    begin
        if (Reset)
        begin
            ghost_survival_timer3 <= 0;
        end
        else if (big_pellet_eaten == 1'b1)
        begin
            ghost_survival_timer3 <= 250;
        end
        else if (slow_ghost_intercept3 == 1)
        begin
            ghost_survival_timer3 <= 0;
        end
        else
        begin
            if (ghost_survival_timer3 != 0)
                ghost_survival_timer3 <= ghost_survival_timer3 - 1;
        end
    end

    always_ff @(posedge frame_clk)
    begin
        if (Reset)
        begin
            ghost_survival_timer4 <= 0;
        end
        else if (big_pellet_eaten == 1'b1)
        begin
            ghost_survival_timer4 <= 250;
        end
        else if (slow_ghost_intercept4 == 1)
        begin
            ghost_survival_timer4 <= 0;
        end
        else
        begin
            if (ghost_survival_timer4 != 0)
                ghost_survival_timer4 <= ghost_survival_timer4 - 1;
        end
    end
    
    always_ff @(posedge frame_clk)
    begin
        if (Reset)
        begin
            
            counter <= 0;
        end
        else
        begin            
            if (counter < 39)
            begin
                counter <= counter + 1;
            end
            else
            begin
                counter <= 0;
            end
        end
    end
     
    assign rom_addr_pacman = (drawX - pacman1) + (drawY - pacman2)*15;
    assign rom_addr_ghost = (drawX - ghost1) + (drawY - ghost2)*16;
	assign rom_addr_ghost2 = (drawX - ghost3) + (drawY - ghost4)*16;
    assign rom_addr_ghost3 = (drawX - ghost5) + (drawY - ghost6)*16;
    assign rom_addr_ghost4 = (drawX - ghost7) + (drawY - ghost8)*16;
    
    pellet_data pellet_test(
        .drawX,
        .drawY,
        .ballX,
        .ballY,
        .clk(frame_clk),
        .reset(Reset),
        .is_pellet_location,
        .R(pellet_red),
        .G(pellet_green),
        .B(pellet_blue),
        .score,
        .big_pellet_eaten,
        .slow_ghost_intercept,
        .ghost_survival_timer,
        .win
    );
    
    endgame endgame(
        .drawX(drawX),
        .drawY(drawY),
        .endgame_red(end_r),
        .endgame_green(end_g),
        .endgame_blue(end_b),
        .lose(lose),
        .clk(frame_clk),
        .reset(Reset),
        .win,
        .score
    );
    
    map_data wall_test(
        .drawX(drawX),
        .drawY(drawY),
        .R(wall_red),
        .G(wall_green),
        .B(wall_blue)
    );
    
    right_1_rom right1 (
	.address (rom_addr_pacman),
	.q       (rom_right1)
    );

    right_1_palette right1pal (
        .index (rom_right1),
        .red   (right_1_red),
        .green (right_1_green),
        .blue  (right_1_blue)
    ); 

    right_2_rom right2 (
	.address (rom_addr_pacman),
	.q       (rom_right2)
    );

    right_2_palette right2pal (
        .index (rom_right2),
        .red   (right_2_red),
        .green (right_2_green),
        .blue  (right_2_blue)
    ); 
    
    left_1_rom left1 (
	.address (rom_addr_pacman),
	.q       (rom_left1)
    );

    left_1_palette left1pal (
        .index (rom_left1),
        .red   (left_1_red),
        .green (left_1_green),
        .blue  (left_1_blue)
    ); 
    
    left_2_rom left2 (
	.address (rom_addr_pacman),
	.q       (rom_left2)
    );

    left_2_palette left2pal (
        .index (rom_left2),
        .red   (left_2_red),
        .green (left_2_green),
        .blue  (left_2_blue)
    ); 
    
    up_1_rom up1 (
	.address (rom_addr_pacman),
	.q       (rom_up1)
    );

    up_1_palette up1pal (
        .index (rom_up1),
        .red   (up_1_red),
        .green (up_1_green),
        .blue  (up_1_blue)
    ); 
    
    up_2_rom up2 (
	.address (rom_addr_pacman),
	.q       (rom_up2)
    );

    up_2_palette up2pal (
        .index (rom_up2),
        .red   (up_2_red),
        .green (up_2_green),
        .blue  (up_2_blue)
    ); 
    
    down_1_rom down1 (
	.address (rom_addr_pacman),
	.q       (rom_down1)
    );

    down_1_palette down1pal (
        .index (rom_down1),
        .red   (down_1_red),
        .green (down_1_green),
        .blue  (down_1_blue)
    ); 
    
    down_2_rom updown2 (
	.address (rom_addr_pacman),
	.q       (rom_down2)
    );

    down_2_palette down2pal (
        .index (rom_down2),
        .red   (down_2_red),
        .green (down_2_green),
        .blue  (down_2_blue)
    ); 
    
    red_down redghostdown (
	.address (rom_addr_ghost),
	.q       (rom_ghost1_down)
    );

    red_down_pal redghostdownpal (
        .index (rom_ghost1_down),
        .red   (red_ghost_downr),
        .green (red_ghost_downg),
        .blue  (red_ghost_downb)
    ); 

    red_up redghostup (
	.address (rom_addr_ghost),
	.q       (rom_ghost1_up)
    );

    red_up_pal redghostuppal (
        .index (rom_ghost1_up),
        .red   (red_ghost_upr),
        .green (red_ghost_upg),
        .blue  (red_ghost_upb)
    ); 

    red_left redghostleft (
	.address (rom_addr_ghost),
	.q       (rom_ghost1_left)
    );

    red_left_pal redghostleftpal (
        .index (rom_ghost1_left),
        .red   (red_ghost_leftr),
        .green (red_ghost_leftg),
        .blue  (red_ghost_leftb)
    ); 

    red_right redghostright (
	.address (rom_addr_ghost),
	.q       (rom_ghost1_right)
    );

    red_right_pal redghostrightpal (
        .index (rom_ghost1_right),
        .red   (red_ghost_rightr),
        .green (red_ghost_rightg),
        .blue  (red_ghost_rightb)
    ); 
    
    scared_ghost firstghostscared (
	.address (rom_addr_ghost),
	.q       (rom_ghost1)
    );

    scared_ghost_pal firstghostscaredpal (
        .index (rom_ghost1),
        .red   (ghost1r),
        .green (ghost1g),
        .blue  (ghost1b)
    ); 

    //////////////////////////////////////////////////////////////////////////////////////////////////

	red_down2 redghost2down (
	.address (rom_addr_ghost2),
	.q       (rom_ghost2_down)
    );

    red_down_pal2 redghost2downpal (
        .index (rom_ghost2_down),
        .red   (red_ghost2_downr),
        .green (red_ghost2_downg),
        .blue  (red_ghost2_downb)
    ); 

    red_up2 redghost2up (
	.address (rom_addr_ghost2),
	.q       (rom_ghost2_up)
    );

    red_up_pal2 redghost2uppal (
        .index (rom_ghost2_up),
        .red   (red_ghost2_upr),
        .green (red_ghost2_upg),
        .blue  (red_ghost2_upb)
    ); 

    red_left2 redghost2left (
	.address (rom_addr_ghost2),
	.q       (rom_ghost2_left)
    );

    red_left_pal2 redghost2leftpal (
        .index (rom_ghost2_left),
        .red   (red_ghost2_leftr),
        .green (red_ghost2_leftg),
        .blue  (red_ghost2_leftb)
    ); 

    red_right2 redghost2right (
	.address (rom_addr_ghost2),
	.q       (rom_ghost2_right)
    );

    red_right_pal2 redghost2rightpal (
        .index (rom_ghost2_right),
        .red   (red_ghost2_rightr),
        .green (red_ghost2_rightg),
        .blue  (red_ghost2_rightb)
    ); 
    
    scared_ghost2 firstghost2scared (
	.address (rom_addr_ghost2),
	.q       (rom_ghost2)
    );

    scared_ghost_pal2 firstghost2scaredpal (
        .index (rom_ghost2),
        .red   (ghost2r),
        .green (ghost2g),
        .blue  (ghost2b)
    ); 


    /////////////////////////////////////////////////////////////////////////////////////////////

    red_down3 redghost3down (
	.address (rom_addr_ghost3),
	.q       (rom_ghost3_down)
    );

    red_down_pal3 redghost3downpal (
        .index (rom_ghost3_down),
        .red   (red_ghost3_downr),
        .green (red_ghost3_downg),
        .blue  (red_ghost3_downb)
    ); 

    red_up3 redghost3up (
	.address (rom_addr_ghost3),
	.q       (rom_ghost3_up)
    );

    red_up_pal3 redghost3uppal (
        .index (rom_ghost3_up),
        .red   (red_ghost3_upr),
        .green (red_ghost3_upg),
        .blue  (red_ghost3_upb)
    ); 

    red_left3 redghost3left (
	.address (rom_addr_ghost3),
	.q       (rom_ghost3_left)
    );

    red_left_pal3 redghost3leftpal (
        .index (rom_ghost3_left),
        .red   (red_ghost3_leftr),
        .green (red_ghost3_leftg),
        .blue  (red_ghost3_leftb)
    ); 

    red_right3 redghost3right (
	.address (rom_addr_ghost3),
	.q       (rom_ghost3_right)
    );

    red_right_pal3 redghost3rightpal (
        .index (rom_ghost3_right),
        .red   (red_ghost3_rightr),
        .green (red_ghost3_rightg),
        .blue  (red_ghost3_rightb)
    ); 
    
    scared_ghost3 firstghost3scared (
	.address (rom_addr_ghost3),
	.q       (rom_ghost3)
    );

    scared_ghost_pal3 firstghost3scaredpal (
        .index (rom_ghost3),
        .red   (ghost3r),
        .green (ghost3g),
        .blue  (ghost3b)
    ); 

    /////////////////////////////////////////////////////////////////////////////////////////////////

    red_down4 redghost4down (
	.address (rom_addr_ghost4),
	.q       (rom_ghost4_down)
    );

    red_down_pal4 redghost4downpal (
        .index (rom_ghost4_down),
        .red   (red_ghost4_downr),
        .green (red_ghost4_downg),
        .blue  (red_ghost4_downb)
    ); 

    red_up4 redghost4up (
	.address (rom_addr_ghost4),
	.q       (rom_ghost4_up)
    );

    red_up_pal4 redghost4uppal (
        .index (rom_ghost4_up),
        .red   (red_ghost4_upr),
        .green (red_ghost4_upg),
        .blue  (red_ghost4_upb)
    ); 

    red_left4 redghost4left (
	.address (rom_addr_ghost4),
	.q       (rom_ghost4_left)
    );

    red_left_pal4 redghost4leftpal (
        .index (rom_ghost4_left),
        .red   (red_ghost4_leftr),
        .green (red_ghost4_leftg),
        .blue  (red_ghost4_leftb)
    ); 

    red_right4 redghost4right (
	.address (rom_addr_ghost4),
	.q       (rom_ghost4_right)
    );

    red_right_pal4 redghost4rightpal (
        .index (rom_ghost4_right),
        .red   (red_ghost4_rightr),
        .green (red_ghost4_rightg),
        .blue  (red_ghost4_rightb)
    ); 
    
    scared_ghost4 firstghost4scared (
	.address (rom_addr_ghost4),
	.q       (rom_ghost4)
    );

    scared_ghost_pal4 firstghost4scaredpal (
        .index (rom_ghost4),
        .red   (ghost4r),
        .green (ghost4g),
        .blue  (ghost4b)
    ); 
        
    score_display score_rgb (
        .score,
        .red(score_red),
        .green(score_green),
        .blue(score_blue),
        .drawX,
        .drawY
    );


endmodule