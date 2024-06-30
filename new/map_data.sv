module map_data( 
    input logic [9:0] drawX, drawY,
    output logic [4:0] R, G, B
);
    
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
            28'b0000000000100000010000000000,
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

    logic [4:0] mapX, mapY;
    logic offset;
    logic [4:0] addr;
    logic [15:0] data; 
    
    always_comb
    begin:GET_MAP_RGB
        mapX = (drawX - 96) / 16;             // X coordinate in game
        mapY = drawY / 16;                    // Y coordinate in game
        offset = map_data[mapY][mapX];        // 0 or 1 from map_data
       
        if (drawX < 96 || drawX >= 544)
        begin
            R = 4'h0;
            G = 4'h0;
            B = 4'h0;  
        end
        else
        begin
            if (offset == 1'b1)
            begin
                R = 4'h0;
                G = 4'h0;
                B = 4'hA;
            end
            else
            begin
                R = 4'h0;
                G = 4'h0;
                B = 4'h0;  
            end
        end
    end
    
endmodule