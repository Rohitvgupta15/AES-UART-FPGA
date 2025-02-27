module inverse_matrix_mul(
    input [31:0] word,
    output [31:0] new_word
    );
    
    wire [7:0] byte1, byte2, byte3, byte4;
    wire [7:0] m1, m2, m3, m4;
    
    assign byte1 = word[31:24];
    assign byte2 = word[23:16];
    assign byte3 = word[15:8];
    assign byte4 = word[7:0];
    
    function [7:0] xor_for_2;
        input [7:0] x;
        input [3:0] n;
        reg [7:0] result;
        integer i;
        begin
            result = x;
            for (i = 0; i < n; i = i + 1) begin
                if (result[7] == 1)
                    result = (result << 1) ^ 8'h1B; 
                else
                    result = result << 1;
            end
            xor_for_2 = result;
        end
    endfunction
    
    function [7:0] gf_mul_0E;
        input [7:0] x;
        begin
            gf_mul_0E = xor_for_2(x, 3) ^ xor_for_2(x, 2) ^ xor_for_2(x, 1);
        end
    endfunction
    
    function [7:0] gf_mul_0D;
        input [7:0] x;
        begin
            gf_mul_0D = xor_for_2(x, 3) ^ xor_for_2(x, 2) ^ x;
        end
    endfunction
    
    function [7:0] gf_mul_0B;
        input [7:0] x;
        begin
            gf_mul_0B = xor_for_2(x, 3) ^ xor_for_2(x, 1) ^ x;
        end
    endfunction
    
    function [7:0] gf_mul_09;
        input [7:0] x;
        begin
            gf_mul_09 = xor_for_2(x, 3) ^ x;
        end
    endfunction
    
    assign m1 = gf_mul_0E(byte1) ^ gf_mul_0B(byte2) ^ gf_mul_0D(byte3) ^ gf_mul_09(byte4);
    assign m2 = gf_mul_09(byte1) ^ gf_mul_0E(byte2) ^ gf_mul_0B(byte3) ^ gf_mul_0D(byte4);
    assign m3 = gf_mul_0D(byte1) ^ gf_mul_09(byte2) ^ gf_mul_0E(byte3) ^ gf_mul_0B(byte4);
    assign m4 = gf_mul_0B(byte1) ^ gf_mul_0D(byte2) ^ gf_mul_09(byte3) ^ gf_mul_0E(byte4);
     
    assign new_word = {m1, m2, m3, m4};   
   
endmodule
