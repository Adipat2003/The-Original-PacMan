module pellet_data(
    input logic [9:0] drawX, drawY, ballX, ballY,
    input logic clk, reset,
    output logic is_pellet_location,
    output logic [3:0] R, G, B,
    output logic [31:0] score,
    output logic big_pellet_eaten,
    input logic slow_ghost_intercept,
    output logic win,
    input logic [7:0] ghost_survival_timer
);
    // Rules: if location is marked 0, there is a pellet
    // otherwise there is no pellet. If the pacman hits a 
    // pellet, we mark the pellet as 1 to say there is no 
    // pellet
    logic [1:0] pellet_data [29:0][27:0];
    logic [4:0] ball_mapX, ball_mapY, draw_mapX, draw_mapY;
    logic [3:0] draw_offsetX, draw_offsetY;
    logic ghost_eaten;
    logic [7:0] pellet_amount;
    
    assign ball_mapX = ballX/16 - 6;
    assign ball_mapY = ballY/16;
    
    always_comb
    begin
        if (drawX >= 96 && drawX < 544)
        begin
            draw_mapX = drawX/16 - 6;
            draw_mapY = drawY/16;
            draw_offsetX = drawX%16;
            draw_offsetY = drawY%16;
            if (pellet_data[draw_mapY][draw_mapX] == 0)
            begin
                is_pellet_location = 1'b1;
                if ((draw_offsetX - 8)**2 + (draw_offsetY - 8)**2 < 9)
                begin
                    R = 4'hF;
                    G = 4'hE;
                    B = 4'h0;
                end
                else
                begin
                    R = 4'h0;
                    G = 4'h0;
                    B = 4'h0;
                end
            end
            else if (pellet_data[draw_mapY][draw_mapX] == 2)
            begin
                is_pellet_location = 1'b1;
                if ((draw_offsetX - 8)**2 + (draw_offsetY - 8)**2 <= 25)
                begin
                    R = 4'hF;
                    G = 4'hE;
                    B = 4'h0;
                end
                else
                begin
                    R = 4'h0;
                    G = 4'h0;
                    B = 4'h0;
                end
            end
            else
            begin
                is_pellet_location = 1'b0;
                R = 4'h0;
                G = 4'h0;
                B = 4'h0;
            end
        end
    end
    

    always_ff @(posedge clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (reset)
        begin 
            score <= 0;
            big_pellet_eaten <= 0;
            ghost_eaten <= 1;
            pellet_amount <= 240;
            win <= 0;
            
	        pellet_data[0]  <= { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 };
            pellet_data[1]  <= { 1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1 };
            pellet_data[2]  <= { 1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,0,1 };
            pellet_data[3]  <= { 1,2,1,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,2,1 };
            pellet_data[4]  <= { 1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,0,1 };
            pellet_data[5]  <= { 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 };
            pellet_data[6]  <= { 1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1 };
            pellet_data[7]  <= { 1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1 };
            pellet_data[8]  <= { 1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1 };
            pellet_data[9]  <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[10] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[11] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[12] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[13] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[14] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[15] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[16] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[17] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[18] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[19] <= { 1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1 };
            pellet_data[20] <= { 1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1 };
            pellet_data[21] <= { 1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,0,1 };
            pellet_data[22] <= { 1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,0,1 };
            pellet_data[23] <= { 1,2,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,2,1 };
            pellet_data[24] <= { 1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,1 };
            pellet_data[25] <= { 1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,1 };
            pellet_data[26] <= { 1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1 };
            pellet_data[27] <= { 1,0,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0,1 };
            pellet_data[28] <= { 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 };
            pellet_data[29] <= { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 };
        end
        else 
        begin 
        
            if (ghost_survival_timer == 0)
                ghost_eaten <= 0;
        
            if (big_pellet_eaten == 1)
                big_pellet_eaten <= 0;
                
            if (win == 1)
            begin
                win <= 1;
            end
                
            else if (pellet_data[ball_mapY][ball_mapX] == 0 || pellet_data[ball_mapY][ball_mapX] == 2)
            begin
            
                pellet_amount <= pellet_amount - 1;
                
                if (pellet_amount - 1 == 0)
                    win = 1;
                else
                    win = 0;
                
                if (pellet_data[ball_mapY][ball_mapX] == 0)
                begin
                    if (slow_ghost_intercept == 1 && ghost_eaten == 0)
                    begin
                        score <= score + 10 + 200;
                        big_pellet_eaten <= 0;
                        ghost_eaten <= 1;
                    end
                    else
                    begin
                        score <= score + 10;
                        big_pellet_eaten <= 0;
                        ghost_eaten <= ghost_eaten;
                    end
                end
                else
                begin
                    if (slow_ghost_intercept == 1 && ghost_eaten == 0)
                    begin
                        score <= score + 50 + 200;
                        big_pellet_eaten <= 1;
                        ghost_eaten <= 1;
                    end
                    else
                    begin
                        score <= score + 50;
                        big_pellet_eaten <= 1;
                        ghost_eaten <= ghost_eaten;
                    end
                end
                pellet_data[ball_mapY][ball_mapX] <= 1;
            end
            else if (slow_ghost_intercept == 1 && ghost_eaten == 0)
            begin
                score <= score + 200;
                big_pellet_eaten <= 0;
                ghost_eaten <= 1;
            end
		end 
    end
endmodule
