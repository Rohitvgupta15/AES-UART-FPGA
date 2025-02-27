module key_expansion( 
    input [127:0] key,
    input [3:0]round_no,
    output reg [127:0]expanded_key
   );
    wire [127:0]round_key[1:10];
    wire [31:0] w[0:43];
//    w0,  w1, w2, w3, w4, w5, w6, w7, w8, w9, w10,
//                w11, w12, w13, w14, w15, w16, w17, w18, w19, w20,
//                w21, w22, w23, w24, w25, w26, w27, w28, w29, w30,
//                w31, w32, w33, w34, w35, w36, w37, w38, w39, w40,
//                w41, w42, w43, w44;
    
    wire [31:0] new_word[1:10];
   
    
    assign w[3]=key[31:0];
    assign w[2]=key[63:32];
    assign w[1]=key[95:64];
    assign w[0]=key[127:96];
    
    genvar i;
     generate 
      for (i = 1; i <= 10; i = i + 1)
      begin : key_gen
      
              word a1(w[4*i-1],i,new_word[i]);
          
              assign w[4*i + 0]    = w[4*(i-1) + 0] ^  new_word[i];
              assign w[4*i + 1]    = w[4*(i-1) + 1] ^  w[4*i + 0];
              assign w[4*i + 2]    = w[4*(i-1) + 2] ^  w[4*i + 1];
              assign w[4*i + 3]    = w[4*(i-1) + 3] ^  w[4*i + 2];
              
              assign round_key[i] = { w[4*i + 0] , w[4*i + 1] , w[4*i + 2] , w[4*i + 3] };
      end
  endgenerate
  
  
  always @(*)
  begin
       case(round_no)
         4'd0  : expanded_key = key;
         4'd1  : expanded_key = round_key[1];
         4'd2  : expanded_key = round_key[2];
         4'd3  : expanded_key = round_key[3];
         4'd4  : expanded_key = round_key[4];
         4'd5  : expanded_key = round_key[5];
         4'd6  : expanded_key = round_key[6];
         4'd7  : expanded_key = round_key[7];
         4'd8  : expanded_key = round_key[8];
         4'd9  : expanded_key = round_key[9];
         4'd10 : expanded_key = round_key[10];
         
            default : expanded_key = 127'b0;
        endcase
   end         
//  assign expanded_key = {round_key[10],round_key[9],round_key[8],round_key[7],round_key[6],
//                          round_key[5],round_key[4],round_key[3],round_key[2],round_key[1]
//                          ,key};

//   use this cases to generate the for loop condition
//   word a1(w3,1,new_word1);
    
//    assign w4= w0 ^ new_word1;
//    assign w5= w1 ^ w4;
//    assign w6= w2 ^ w5;
//    assign w7= w3 ^ w6;
   
//    assign round_1_key = {w4,w5,w6,w7};
    
//    //round2
    
//     word a2(w7,2,new_word2);
    
//    assign w8= w4 ^ new_word2;
//    assign w9= w5 ^ w8;
//    assign w10= w6 ^ w9;
//    assign w11= w7 ^ w10;
   
//    assign round_2_key = {w8,w9,w10,w11};
    
//    //round3
    
//     word a3(w11,3,new_word3);
    
//    assign w12= w4 ^ new_word3;
//    assign w13= w5 ^ w12;
//    assign w14= w6 ^ w13;
//    assign w15= w7 ^ w14;
   
//    assign round_2_key = {w12,w13,w14,w15};
    
//    //round4
    
//    word a3(w11,3,new_word3);
    
//    assign w12= w4 ^ new_word3;
//    assign w13= w5 ^ w12;
//    assign w14= w6 ^ w13;
//    assign w15= w7 ^ w14;
   
//    assign round_2_key = {w12,w13,w14,w15};
    
//    //round4
    
    

endmodule
