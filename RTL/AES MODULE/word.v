module word(
    input [31:0]word_in,
    input [3:0]round_no,
    output  [31:0]word_out
    );
    wire [31:0]left_shift;
    wire [31:0]after_sbox;
    wire [31:0]rcon;
   
    
    assign left_shift = {word_in[23:0],word_in[31:24]};
    
    S_box s1(left_shift[31:24],after_sbox[31:24]);
    S_box s2(left_shift[23:16],after_sbox[23:16]);
    S_box s3(left_shift[15:8],after_sbox[15:8]);
    S_box s4(left_shift[7:0],after_sbox[7:0]);
    
    Rcon r1(round_no,rcon);
    
    assign word_out = after_sbox ^ rcon;
    
    

endmodule
