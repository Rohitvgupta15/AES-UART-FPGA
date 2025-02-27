module Inverse_shift_rows(
    input [127:0] new_sub_byte,
    output [127:0] inverse_shifted_state
    );
    
    wire [31:0]w1,w2,w3,w4;
    wire [7:0] byte1 [0:15];
    
    

    assign byte1[15]  = new_sub_byte[7:0];
    assign byte1[14]  = new_sub_byte[15:8];
    assign byte1[13]  = new_sub_byte[23:16];
    assign byte1[12]  = new_sub_byte[31:24];
    assign byte1[11]  = new_sub_byte[39:32];
    assign byte1[10]  = new_sub_byte[47:40];
    assign byte1[9]  = new_sub_byte[55:48];
    assign byte1[8]  = new_sub_byte[63:56];
    assign byte1[7]  = new_sub_byte[71:64];
    assign byte1[6]  = new_sub_byte[79:72];
    assign byte1[5] = new_sub_byte[87:80];
    assign byte1[4] = new_sub_byte[95:88];
    assign byte1[3] = new_sub_byte[103:96];
    assign byte1[2] = new_sub_byte[111:104];
    assign byte1[1] = new_sub_byte[119:112];
    assign byte1[0] = new_sub_byte[127:120];

    
    
    assign w1 = { byte1[0] , byte1[13] , byte1[10] , byte1[7] };
    
    assign w2 = { byte1[4] , byte1[1] , byte1[14] , byte1[11] };
    
    assign w3 = { byte1[8] , byte1[5] , byte1[2] , byte1[15] };

    assign w4 = { byte1[12] , byte1[9] , byte1[6] , byte1[3] };

    assign inverse_shifted_state = { w1 , w2 , w3, w4 };

endmodule
