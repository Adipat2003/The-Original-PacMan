module pacman_data(
    input logic [11:0] addr,
    output logic [16:0] data
);
    parameter [0:80][16:0] pacman_rom = {
        // closed pacman
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000011111100000,
        16'b0001111111111000,
        16'b0011111111111100,
        16'b0011111111111100,
        16'b0011111111111100,
        16'b0011111111111100,
        16'b0011111111111100,
        16'b0001111111111000,
        16'b0000011111100000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        //UP
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        //DOWN
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        //LEFT
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        //RIGHT  
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000      
    };
    
    assign data = pacman_rom[addr];
    
endmodule
