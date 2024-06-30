module score_rom(
    input logic [9:0] addr,
    output logic [7:0] data
);
	
	parameter [0:271][7:0] ROM = {
	    // S 
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b01100000, // 5  **
        8'b00111000, // 6   ***
        8'b00001100, // 7     **
        8'b00000110, // 8      **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // C
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111100, // 2   ****
        8'b01100110, // 3  **  **
        8'b11000010, // 4 **    *
        8'b11000000, // 5 **
        8'b11000000, // 6 **
        8'b11000000, // 7 **
        8'b11000000, // 8 **
        8'b11000010, // 9 **    *
        8'b01100110, // a  **  **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // O
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b11000110, // 6 **   **
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // R
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111100, // 2 ******
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01111100, // 6  *****
        8'b01101100, // 7  ** **
        8'b01100110, // 8  **  **
        8'b01100110, // 9  **  **
        8'b01100110, // a  **  **
        8'b11100110, // b ***  **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // E
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111110, // 2 *******
        8'b01100110, // 3  **  **
        8'b01100010, // 4  **   *
        8'b01101000, // 5  ** *
        8'b01111000, // 6  ****
        8'b01101000, // 7  ** *
        8'b01100000, // 8  **
        8'b01100010, // 9  **   *
        8'b01100110, // a  **  **
        8'b11111110, // b *******
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // :
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00000000, // 2
        8'b00000000, // 3
        8'b00011000, // 4    **
        8'b00011000, // 5    **
        8'b00000000, // 6
        8'b00000000, // 7
        8'b00000000, // 8
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b00000000, // b
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // SPACE
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00000000, // 2
        8'b00000000, // 3
        8'b00000000, // 4
        8'b00000000, // 5
        8'b00000000, // 6
        8'b00000000, // 7
        8'b00000000, // 8
        8'b00000000, // 9
        8'b00000000, // a
        8'b00000000, // b
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 0
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11001110, // 5 **  ***
        8'b11011110, // 6 ** ****
        8'b11110110, // 7 **** **
        8'b11100110, // 8 ***  **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 1
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00011000, // 2
        8'b00111000, // 3
        8'b01111000, // 4    **
        8'b00011000, // 5   ***
        8'b00011000, // 6  ****
        8'b00011000, // 7    **
        8'b00011000, // 8    **
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b01111110, // b    **
        8'b00000000, // c    **
        8'b00000000, // d  ******
        8'b00000000, // e
        8'b00000000, // f
        // 2
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b00000110, // 4      **
        8'b00001100, // 5     **
        8'b00011000, // 6    **
        8'b00110000, // 7   **
        8'b01100000, // 8  **
        8'b11000000, // 9 **
        8'b11000110, // a **   **
        8'b11111110, // b *******
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 3
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b00000110, // 4      **
        8'b00000110, // 5      **
        8'b00111100, // 6   ****
        8'b00000110, // 7      **
        8'b00000110, // 8      **
        8'b00000110, // 9      **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 4
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00001100, // 2     **
        8'b00011100, // 3    ***
        8'b00111100, // 4   ****
        8'b01101100, // 5  ** **
        8'b11001100, // 6 **  **
        8'b11111110, // 7 *******
        8'b00001100, // 8     **
        8'b00001100, // 9     **
        8'b00001100, // a     **
        8'b00011110, // b    ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 5
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111110, // 2 *******
        8'b11000000, // 3 **
        8'b11000000, // 4 **
        8'b11000000, // 5 **
        8'b11111100, // 6 ******
        8'b00000110, // 7      **
        8'b00000110, // 8      **
        8'b00000110, // 9      **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 6
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111000, // 2   ***
        8'b01100000, // 3  **
        8'b11000000, // 4 **
        8'b11000000, // 5 **
        8'b11111100, // 6 ******
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 7
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111110, // 2 *******
        8'b11000110, // 3 **   **
        8'b00000110, // 4      **
        8'b00000110, // 5      **
        8'b00001100, // 6     **
        8'b00011000, // 7    **
        8'b00110000, // 8   **
        8'b00110000, // 9   **
        8'b00110000, // a   **
        8'b00110000, // b   **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 8
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b01111100, // 6  *****
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        // 9
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b01111110, // 6  ******
        8'b00000110, // 7      **
        8'b00000110, // 8      **
        8'b00000110, // 9      **
        8'b00001100, // a     **
        8'b01111000, // b  ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000  // f
	};
    
    assign data = ROM[addr];
    
endmodule
