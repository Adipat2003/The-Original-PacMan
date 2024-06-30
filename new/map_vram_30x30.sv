module map_vram_30x30(
    output logic [29:0] q,
    input [29:0] d,
    input [4:0] write_address, read_address,
    input we, clk
);
    
    // 32-bit data : 1 bit color     
    logic [79:0] mem [29:0];
    
    always_ff @ (posedge clk) begin
        if (we)
        mem[write_address] <= d;
        q <= mem[read_address]; 
    end

endmodule
