module matrix_mul(
    input [31:0] word,
    output [31:0] new_word
    );
    
    wire [7:0]byte1,byte2,byte3,byte4;
    wire [7:0]m1,m2,m3,m4,a1,a2;
    
    assign byte1= word[31:24];
    assign byte2= word[23:16];
    assign byte3= word[15:8];
    assign byte4= word[7:0];
    
    function [7:0] xor_for_2;
        input [7:0] x;
        reg [7:0] left_shift;
        begin
            left_shift = x << 1;
            if(x[7] == 1)
            xor_for_2 = left_shift ^ 8'b00011011;
            else
            xor_for_2 = left_shift ^ 8'b00000000;

        end
    endfunction
    
    function [7:0] xor_for_3;
        input [7:0] x;
        begin
            xor_for_3 = xor_for_2(x) ^ x;
        end
    endfunction
   assign a1=xor_for_2(byte1);
   assign a2=xor_for_3(byte2);
   assign m1= xor_for_2(byte1)  ^ xor_for_3(byte2) ^  byte3            ^  byte4 ;
   assign m2= byte1             ^ xor_for_2(byte2) ^ xor_for_3(byte3)  ^  byte4 ;
   assign m3= byte1             ^ byte2            ^ xor_for_2( byte3) ^ xor_for_3(byte4) ;
   assign m4= xor_for_3( byte1) ^ byte2            ^ byte3             ^ xor_for_2( byte4) ;
     
   assign new_word = {m1 , m2 , m3 , m4};         
endmodule
