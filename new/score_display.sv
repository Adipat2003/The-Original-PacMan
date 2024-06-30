module score_display(
    input logic [31:0] score,
    input logic [9:0] drawX, drawY,
    output logic [3:0] red, green, blue
);
    
    logic [9:0] addr;
    logic [7:0] data;
    logic [7:0] pos;   
    
    logic [31:0] score_temp;
    
    logic [3:0] digit1;
    logic [3:0] digit2;
    logic [3:0] digit3;
    logic [3:0] digit4;
    
    score_rom score_rom(.addr, .data);

    always_comb
    begin
        pos = (drawX - 552) / 8;
        if (pos >= 0 && pos <= 6)
        begin
            addr = pos * 16 + (drawY % 16);
        end
        else
        begin
            score_temp = score;
            digit4 = score_temp % 10;
            score_temp = score_temp / 10;
            digit3 = score_temp %10;
            score_temp = score_temp / 10;
            digit2 = score_temp % 10;
            score_temp = score_temp / 10;
            digit1 = score_temp % 10;
            
            if (drawX >= 608 && drawX < 616)
                addr = (16*7 + (digit1) * 16 + (drawY % 16));
            else if (drawX >= 616 && drawX < 624)
                addr = (16*7 + (digit2) * 16 + (drawY % 16));
            else if (drawX >= 624 && drawX < 632)
                addr = (16*7 + (digit3) * 16 + (drawY % 16));
            else if (drawX >= 632 && drawX < 640)
                addr = (16*7 + (digit4) * 16 + (drawY % 16));
            else
                addr = 0;
        end
    end
    
    always_comb
    begin
        // SCORE: 
        if (data[7 - (drawX % 8)] == 1'b1)
        begin
            red = 4'hF;
            blue = 4'h0;
            green = 4'hE;
        end
        else
        begin
            red = 4'h0;
            blue = 4'h0;
            green = 4'h0;
        end
    end
endmodule
