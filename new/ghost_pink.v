module  ghost_pink
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    input  logic [9:0]  ballX, 
    input  logic [9:0]  ballY, 
    output logic [9:0]  ghostX, 
    output logic [9:0]  ghostY, 
    output logic [9:0]  ghostS
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
    logic [9:0] ghost_X_Motion;
    logic [9:0] ghost_Y_Motion;
    logic [9:0] ghost_X_Motion_next, ghost_Y_Motion_next;

    logic [9:0] ghost_X_next;
    logic [9:0] ghost_Y_next;
    
    logic [4:0] ghost_mapX, ghost_mapY;
    logic [4:0] seed;
    logic [1:0] next_prev_direction;
    logic [1:0] prev_direction;
    logic [1:0] close_dir_reg;
    logic [1:0] close_dir;
    logic [3:0] offsetX, offsetY;
    
    assign ghost_mapX = ghostX/16 - 6;
    assign ghost_mapY = ghostY/16;
    assign offsetX = ghostX%16;
    assign offsetY = ghostY%16;

    always_comb begin

        ghost_Y_Motion_next = ghost_Y_Motion; // set default motion to be same as prev clock cycle 
        ghost_X_Motion_next = ghost_X_Motion;

        next_prev_direction = prev_direction;
        

        if (ghost_Y_Motion_next == 10'd1 && ghost_X_Motion_next == 10'd0)        
            next_prev_direction = 0; // previous movement was down
        else if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == 10'd1)   
            next_prev_direction = 1; // previous movement was right
        else if (ghost_Y_Motion_next == -10'd1 && ghost_X_Motion_next == 10'd0)      
            next_prev_direction = 2; // previous movement was up
        else if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == -10'd1)
            next_prev_direction = 3; // previous movement was left

        if (ghost_Y_Motion_next == -10'd1 && ghost_X_Motion_next == 10'd0)
        begin
            // if wall is above
            if (1 == map_data[ghost_mapY - 1][ghost_mapX] && offsetY <= 8)
            begin
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
        end

        if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == -10'd1)
        begin
            // if wall is to the left
            if (1 == map_data[ghost_mapY][ghost_mapX - 1] && offsetX <= 8)
            begin
                ghost_X_Motion_next = 10'd0;
                ghost_Y_Motion_next = 10'd0;
            end
        end

        if (ghost_Y_Motion_next == 10'd1 && ghost_X_Motion_next == 10'd0)
        begin
            // if wall is below
            if (1 == map_data[ghost_mapY + 1][ghost_mapX] && offsetY >= 8)
            begin
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
        end

        if (ghost_Y_Motion_next == 10'd0 && ghost_X_Motion_next == 10'd1)
        begin
            // if wall is right
            if (1 == map_data[ghost_mapY][ghost_mapX + 1] && offsetX >= 8)
            begin
                ghost_Y_Motion_next = 10'd0;
                ghost_X_Motion_next = 10'd0;
            end
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

    assign ghostS = 8;  // default ghost size
    assign ghost_X_next = (ghostX + ghost_X_Motion_next);
    assign ghost_Y_next = (ghostY + ghost_Y_Motion_next);
   
   logic [5:0] counter;
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_ghost
        if (Reset)
        begin 
            ghost_Y_Motion <= 10'd0; //ghost_Y_Step;
			ghost_X_Motion <= 10'd0; //ghost_X_Step;
            
            prev_direction <= 10'd0;
            counter = 0;
            
			ghostY <= ghost_Y_Center;
			ghostX <= ghost_X_Center;
            
        end
        else 
        begin 
            if (counter <= 7)
            begin
                counter <= counter + 1'b1;
            end
            else
            begin
            	ghost_Y_Motion <= ghost_Y_Motion_next; 
                ghost_X_Motion <= ghost_X_Motion_next; 
                
                prev_direction <= next_prev_direction;
    
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