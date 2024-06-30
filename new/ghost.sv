module  ghost_red
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [9:0]  ballX, 
    input  logic [9:0]  ballY, 
    output logic [9:0]  ghostX, 
    output logic [9:0]  ghostY, 
    output logic [9:0]  ghostS,
    input logic [7:0] ghost_survival_timer,
    output logic [9:0] ghost_X_Motion, ghost_Y_Motion,
    output logic [9:0] ghost_X_Motion_next, ghost_Y_Motion_next,
    output logic [9:0] ghost_X_prev, ghost_Y_prev,
    output logic slow_ghost_intercept,
    output logic ghost_intercept
);

    logic [27:0] pellet_data [29:0];
    parameter [0:29][27:0] map_data = {
            28'b1111111111111111111111111111,
            28'b1000000000000110000000000001,
            28'b1011110111110110111110111101,
            28'b1011110111110110111110111101,
            28'b1011110111110110111110111101,
            28'b1000000000000000000000000001,
            28'b1011110110111111110110111101,
            28'b1011110110111111110110111101,
            28'b1000000110000110000110000001,
            28'b1111110111110110111110111111,
            28'b0000010111110110111110100000,
            28'b0000010110000000000110100000,
            28'b0000010110111111110110100000,
            28'b1111110110100000010110111111,
            28'b0000010000100000010000100000,
            28'b1111110110100000010110111111,
            28'b0000010110111111110110100000,
            28'b0000010110000000000110100000,
            28'b0000010110111111110110100000,
            28'b1111110110111111110110111111,
            28'b1000000000000110000000000001,
            28'b1011110111110110111110111101,
            28'b1011110111110110111110111101,
            28'b1000110000000000000000110001,
            28'b1110110110111111110110110111,
            28'b1110110110111111110110110111,
            28'b1000000110000110000110000001,
            28'b1011111111110110111111111101,
            28'b1000000000000000000000000001,
            28'b1111111111111111111111111111
    };
	 
    parameter [9:0] ghost_X_Center=320;
    parameter [9:0] ghost_Y_Center=240-3*16-8;
    parameter [9:0] ghost_X_Min=96;       // Leftmost point on the X axis
    parameter [9:0] ghost_X_Max=544;     // Rightmost point on the X axis
    parameter [9:0] ghost_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] ghost_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] ghost_X_Step=1;      // Step size on the X axis
    parameter [9:0] ghost_Y_Step=1;      // Step size on the Y axis

    logic [11:0] x_disp, y_disp, x_dist, y_dist;

    logic [9:0] ghost_X_next;
    logic [9:0] ghost_Y_next;
    
    logic [9:0] ghost_X_prev_temporary;
    logic [9:0] ghost_Y_prev_temporary;
    
    logic [9:0] center_X_dist;
    logic [9:0] center_Y_dist; 
    
    logic [4:0] ghost_mapX, ghost_mapY;
    logic [4:0] seed;
    logic [1:0] next_prev_direction;
    logic [2:0] prev_direction;
    logic [1:0] close_dir_reg;
    logic [1:0] close_dir;
    logic [3:0] offsetX, offsetY;
    
    logic slow_bit;
    logic slow_ghost_intercept_temp;
    logic ghost_intercept_temp;
    
    assign ghost_mapX = ghostX/16 - 6;
    assign ghost_mapY = ghostY/16;
    assign offsetX = ghostX%16;
    assign offsetY = ghostY%16;

    always_comb 
    begin
        
        if (ghost_survival_timer != 250)
        begin
            ghost_Y_Motion_next = ghost_Y_Motion; // set default motion to be same as prev clock cycle 
            ghost_X_Motion_next = ghost_X_Motion;
        end
        else
        begin
            ghost_Y_Motion_next = 0; // set default motion to be same as prev clock cycle 
            ghost_X_Motion_next = 0;
        end

        next_prev_direction = prev_direction;
        if (ghost_Y_Motion_next == 10'd1 && ghost_X_Motion_next == 10'd0)        
            next_prev_direction = 0; // previous movement was down
        else if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == 10'd1)   
            next_prev_direction = 1; // previous movement was right
        else if (ghost_Y_Motion_next == -10'd1 && ghost_X_Motion_next == 10'd0)      
            next_prev_direction = 2; // previous movement was up
        else if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == -10'd1)
            next_prev_direction = 3; // previous movement was left
    
        ghost_X_prev_temporary = ghost_X_prev;
        ghost_Y_prev_temporary = ghost_Y_prev;
        slow_ghost_intercept_temp = 0;
        ghost_intercept_temp = 0;

        if (ghost_Y_Motion_next == -10'd1 && ghost_X_Motion_next == 10'd0)
        begin
            // if wall is above
            if (1 == map_data[ghost_mapY - 1][ghost_mapX] && offsetY <= 8)
            begin
                ghost_X_prev_temporary = ghost_X_Motion_next;
                ghost_Y_prev_temporary = ghost_Y_Motion_next;
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
        end

        if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == -10'd1)
        begin
            // if wall is to the left
            if (1 == map_data[ghost_mapY][ghost_mapX - 1] && offsetX <= 8)
            begin
                ghost_X_prev_temporary = ghost_X_Motion_next;
                ghost_Y_prev_temporary = ghost_Y_Motion_next;
                ghost_X_Motion_next = 10'd0;
                ghost_Y_Motion_next = 10'd0;
            end
        end

        if (ghost_Y_Motion_next == 10'd1 && ghost_X_Motion_next == 10'd0)
        begin
            // if wall is below
            if (1 == map_data[ghost_mapY + 1][ghost_mapX] && offsetY >= 8)
            begin
                ghost_X_prev_temporary = ghost_X_Motion_next;
                ghost_Y_prev_temporary = ghost_Y_Motion_next;
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
        end
        if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == 10'd1)
        begin
            // if wall is right
            if (1 == map_data[ghost_mapY][ghost_mapX + 1] && offsetX >= 8)
            begin
                ghost_X_prev_temporary = ghost_X_Motion_next;
                ghost_Y_prev_temporary = ghost_Y_Motion_next;
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
        end
                
        // ghost chases
        if (ghost_survival_timer == 0)
        begin           
            // check if you intercepted the pacman
            if ((ballX + 8 > ghostX - 8 && ballX <= ghostX) && (ballY + 8 > ghostY - 8 && ballY <= ghostY))
            begin  
                ghost_intercept_temp = 1;
            end
            else if ((ballX + 8 > ghostX - 8 && ballX <= ghostX) && (ballY - 8 < ghostY + 8 && ballY >= ghostY))
            begin
                ghost_intercept_temp = 1; 
            end
            else if ((ballX - 8 < ghostX + 8  && ballX >= ghostX) && (ballY + 8 > ghostY - 8 && ballY <= ghostY))
            begin
                ghost_intercept_temp = 1;
            end
            else if ((ballX - 8 < ghostX + 8  && ballX >= ghostX) && (ballY - 8 < ghostY + 8 && ballY >= ghostY))
            begin
                ghost_intercept_temp = 1;
            end        
    
            // check if you wanted to move up and you can
            if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1 && seed == 0 && prev_direction != 0)
            begin
                ghost_Y_Motion_next = -10'd1;
                ghost_X_Motion_next = 10'd0;
            end
    
            // check if you wanted to move left and you can
            else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1 && seed == 1 && prev_direction != 1)
            begin
                ghost_X_Motion_next = -10'd1;
                ghost_Y_Motion_next = 10'd0;
            end
            
            // check if you want to move down and you can
            else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1 && seed == 2 && prev_direction != 2)
            begin
                ghost_Y_Motion_next = 10'd1;
                ghost_X_Motion_next = 10'd0; 
            end
    
            // check if you want to move right and you can
            else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1 && seed == 3 && prev_direction != 3)
            begin
                ghost_X_Motion_next = 10'd1;
                ghost_Y_Motion_next = 10'd0;
            end
            
            // check the direction to the pacman and try going in that direction
            else 
            begin               
                if (ballX < ghostX && ballY < ghostY)
                begin
                    close_dir = 0;
                    // try going up and left
                    if (x_dist >= y_dist)
                    begin
                        // try going left
                        if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = -10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                        // cannot go left, so tries to go up
                        else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = -10'd1;
                            ghost_X_Motion_next = 10'd0;
                        end
                        // cannot go up, so goes down
                    end
                    else if (y_dist > x_dist)
                    begin
                        // try going up
                        if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = -10'd1;
                            ghost_X_Motion_next = 10'd0;
                        end
                        // cannot go up, so tries to go left
                        else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = -10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                        // cannot go left, so goes right
                    end
                end
                
                else if (ballX >= ghostX && ballY >= ghostY)
                begin
                    close_dir = 2;
                    // try going down and right
                    if (x_dist >= y_dist)
                    begin
                        // try going right
                        if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = 10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                        // cannot go right, so tries to go down
                        else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = 10'd1;
                            ghost_X_Motion_next = 10'd0; 
                        end
                        // cannot go down, so goes up
                    end
                    else if (y_dist > x_dist)
                    begin
                        // try going down
                        if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = 10'd1;
                            ghost_X_Motion_next = 10'd0; 
                        end
                        // cannot go down, so tries to go right
                        else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = 10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                    end
                end
                
                else if (ballX >= ghostX && ballY < ghostY)
                begin
                    close_dir = 0;
                    // try going up and right
                    if (x_dist >= y_dist)
                    begin
                        // try going right
                        if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = 10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                        // cannot go right, so tries to go up
                        else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = -10'd1;
                            ghost_X_Motion_next = 10'd0;
                        end
                        // cannot go up so goes down
                    end
                    else if (y_dist > x_dist)
                    begin
                        // try going up
                        if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = -10'd1;
                            ghost_X_Motion_next = 10'd0;
                        end
                        // cannot go up so tries to go right
                        else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = 10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                    end
                end
                
                else 
                begin
                    close_dir = 1;
                    // try going down and left
                    if (x_dist >= y_dist)
                    begin
                        // try going left
                        if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = -10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                        // cannot go left so tries to go down
                        else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = 10'd1;
                            ghost_X_Motion_next = 10'd0; 
                        end
                    end
                    else if (y_dist > x_dist)
                    begin
                        // try going down
                        if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                        begin
                            ghost_Y_Motion_next = 10'd1;
                            ghost_X_Motion_next = 10'd0; 
                        end
                        // cannot go down so try to go left
                        else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                        begin
                            ghost_X_Motion_next = -10'd1;
                            ghost_Y_Motion_next = 10'd0;
                        end
                    end
                end
            end
        end
        // ghost runs away
        else
        begin
            if ((ballX + 8 > ghostX - 8 && ballX <= ghostX) && (ballY + 8 > ghostY - 8 && ballY <= ghostY) && ghost_survival_timer != 0)
            begin
                ghost_X_Motion_next = ghost_X_Center - ghostX;  
                ghost_Y_Motion_next = ghost_Y_Center - ghostY;  
                slow_ghost_intercept_temp = 1;
            end
            else if ((ballX + 8 > ghostX - 8 && ballX <= ghostX) && (ballY - 8 < ghostY + 8 && ballY >= ghostY) && ghost_survival_timer != 0)
            begin
                ghost_X_Motion_next = ghost_X_Center - ghostX;  
                ghost_Y_Motion_next = ghost_Y_Center - ghostY;
                slow_ghost_intercept_temp = 1; 
            end
            else if ((ballX - 8 < ghostX + 8  && ballX >= ghostX) && (ballY + 8 > ghostY - 8 && ballY <= ghostY) && ghost_survival_timer != 0)
            begin
                ghost_X_Motion_next = ghost_X_Center - ghostX;  
                ghost_Y_Motion_next = ghost_Y_Center - ghostY; 
                slow_ghost_intercept_temp = 1;
            end
            else if ((ballX - 8 < ghostX + 8  && ballX >= ghostX) && (ballY - 8 < ghostY + 8 && ballY >= ghostY) && ghost_survival_timer != 0)
            begin
                ghost_X_Motion_next = ghost_X_Center - ghostX;  
                ghost_Y_Motion_next = ghost_Y_Center - ghostY; 
                slow_ghost_intercept_temp = 1;
            end         
            else if (ballX < ghostX && ballY < ghostY)
            begin
                if (x_dist >= y_dist)
                begin
                    // try going down
                    if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = 10'd1;
                        ghost_X_Motion_next = 10'd0; 
                    end
                    // try going right
                    else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = 10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                end
                else
                begin
                    // try going right
                    if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = 10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                    // try going down
                    else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = 10'd1;
                        ghost_X_Motion_next = 10'd0; 
                    end
                end
            end
            else if (ballX < ghostX && ballY > ghostY)
            begin
                if (x_dist >= y_dist)
                begin
                    // try going up
                    if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = -10'd1;
                        ghost_X_Motion_next = 10'd0;
                    end
                    // try going right
                    else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = 10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                end
                else
                begin
                    // try going right
                    if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = 10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                    // try going up
                    else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = -10'd1;
                        ghost_X_Motion_next = 10'd0;
                    end
                end
            end
            else if (ballX > ghostX && ballY < ghostY)
            begin
                if (x_dist >= y_dist)
                begin
                    // try going down
                    if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = 10'd1;
                        ghost_X_Motion_next = 10'd0; 
                    end
                    // try going left
                    else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = -10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                end
                else
                begin
                    // try going left
                    if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = -10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                    // try going down
                    else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = 10'd1;
                        ghost_X_Motion_next = 10'd0; 
                    end
                end
            end
            else if (ballX > ghostX && ballY > ghostY)
            begin
                if (x_dist >= y_dist)
                begin
                    // try going up
                    if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = -10'd1;
                        ghost_X_Motion_next = 10'd0;
                    end
                    // try going left
                    else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = -10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                end
                else
                begin
                    // try going left
                    if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                    begin
                        ghost_X_Motion_next = -10'd1;
                        ghost_Y_Motion_next = 10'd0;
                    end
                    // try going up
                    else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                    begin
                        ghost_Y_Motion_next = -10'd1;
                        ghost_X_Motion_next = 10'd0;
                    end
                end
            end
            else if (ballX == ghostX && ballY > ghostY)
            begin
                // make ghost go up, left, or right
                // up case
                if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = -10'd1;
                    ghost_X_Motion_next = 10'd0;
                end
                // left case
                else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = -10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end
                // right case
                else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = 10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end
            end
            else if (ballX == ghostX && ballY < ghostY)
            begin
                // make ghost go down, left, or right
                // down case
                if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = 10'd1;
                    ghost_X_Motion_next = 10'd0; 
                end
                // right case
                else if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = 10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end
                // left case
                else if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = -10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end     
            end
            else if (ballX > ghostX && ballY == ghostY)
            begin
                // make ghost go left, up, or down
                // left case
                if (0 == map_data[ghost_mapY][ghost_mapX - 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = -10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end    
                // up case
                else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = -10'd1;
                    ghost_X_Motion_next = 10'd0;
                end
                // down case
                else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = 10'd1;
                    ghost_X_Motion_next = 10'd0; 
                end
            end
            else if (ballX < ghostX && ballY == ghostY)
            begin
                // make ghost go right, up, or down
                // right case
                if (0 == map_data[ghost_mapY][ghost_mapX + 1] && offsetY == 8 && ghost_X_Motion_next != 10'd1 && ghost_X_Motion_next != -10'd1)
                begin
                    ghost_X_Motion_next = 10'd1;
                    ghost_Y_Motion_next = 10'd0;
                end
                // down case
                else if (0 == map_data[ghost_mapY + 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = 10'd1;
                    ghost_X_Motion_next = 10'd0; 
                end
                // up case
                else if (0 == map_data[ghost_mapY - 1][ghost_mapX] && offsetX == 8 && ghost_Y_Motion_next != 10'd1 && ghost_Y_Motion_next != -10'd1)
                begin
                    ghost_Y_Motion_next = -10'd1;
                    ghost_X_Motion_next = 10'd0;
                end
            end
            else
            begin
                ghost_X_Motion_next = 10'd0;
                ghost_Y_Motion_next = 10'd0;
            end
        end
    end

    always_comb
    begin
        ghostS = 8;  // default ghost size
        ghost_X_next = (ghostX + ghost_X_Motion_next);
        ghost_Y_next = (ghostY + ghost_Y_Motion_next); 
    end
    
    logic [14:0] counter;
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_ghost
        if (Reset)
        begin 
            ghost_Y_Motion <= 10'd0; //ghost_Y_Step;
			ghost_X_Motion <= 10'd0; //ghost_X_Step;
            
            prev_direction <= -1;
            
            slow_ghost_intercept <= 0;
            ghost_intercept <= 0;
            
            counter <= 0;
            slow_bit <= 0;
            
            ghost_X_prev <= 1;
            ghost_Y_prev <= 1;
            
			ghostY <= ghost_Y_Center;
			ghostX <= ghost_X_Center;
            
        end
        else 
        begin 
            if (counter <= 250)
            begin
                counter <= counter + 1'b1;
                ghost_intercept <= 0;
            end
            else if (ghost_intercept == 1)
            begin
                ghost_intercept <= 1;
            end
            else
            begin
                if (ghost_survival_timer == 0)
                begin
                    ghost_Y_Motion <= ghost_Y_Motion_next; 
                    ghost_X_Motion <= ghost_X_Motion_next; 
                    
                    prev_direction <= next_prev_direction;
                    ghost_X_prev <= ghost_X_prev_temporary;
                    ghost_Y_prev <= ghost_Y_prev_temporary;
                    ghostY <= ghost_Y_next;  // Update ghost position
                    ghostX <= ghost_X_next;
                    slow_ghost_intercept <= 0;
                    ghost_intercept <= ghost_intercept_temp;
                    
                    close_dir_reg <= close_dir;
                    
                    x_disp <= ballX - ghostX;
                    y_disp <= ballY - ghostY;
                    
                    if (ballX >= ghostX)
                        x_dist <= ballX - ghostX;
                    else
                        x_dist <= ghostX - ballX;
                        
                    if (ballY >= ghostY)
                        y_dist <= ballY - ghostY;
                    else
                        y_dist <= ghostY - ballY;
               end
               else
               begin
                    if (slow_bit == 0)
                    begin
                        ghost_Y_Motion <= ghost_Y_Motion_next; 
                        ghost_X_Motion <= ghost_X_Motion_next; 
                        
                        prev_direction <= next_prev_direction;
                        slow_ghost_intercept <= slow_ghost_intercept_temp;
                        ghost_intercept <= 0;
            
                        ghostY <= ghost_Y_next;  // Update ghost position
                        ghostX <= ghost_X_next;
                        close_dir_reg <= close_dir;
                        
                        x_disp <= ballX - ghostX;
                        y_disp <= ballY - ghostY;
                        
                        if (ballX >= ghostX)
                            x_dist <= ballX - ghostX;
                        else
                            x_dist <= ghostX - ballX;
                            
                        if (ballY >= ghostY)
                            y_dist <= ballY - ghostY;
                        else
                            y_dist <= ghostY - ballY;
                            
                        slow_bit <= 1;
                    end
                    else
                    begin
                        slow_bit <= 0;
                    end
               end
           end
		end  
    end

    always_ff @(posedge frame_clk) 
    begin
        if (Reset)
            seed <= 0;
        else
        begin
            // depending on the distance, I will choose a number between 0-n where 0-3 represents random direction, and 3-n represents direction to pacman
            
            if ((ballX - ghostX)**2 + (ballY - ghostY)**2 > 240**2)
                seed <= (seed + 1) % 5;  
            else if ((ballX - ghostX)**2 + (ballY - ghostY)**2 > 120**2)   
                seed <= (seed + 1) % 7; 
            else if ((ballX - ghostX)**2 + (ballY - ghostY)**2 > 60**2)    
                seed <= (seed + 1) % 10;  
            else            
                seed <= 5;
            
        end
    end
     
endmodule