module AES_decryption_top(
    input [127:0] encrypt_data,
    input [127:0] key,
    output [127:0] decrypt_data
    );
    wire [127:0]a[1:10];
   

        add_round_key r0(encrypt_data,key,10,a[1]);
  
        inverse_round r1(a[1],key,9,a[2]);
        inverse_round r2(a[2],key,8,a[3]);
        inverse_round r3(a[3],key,7,a[4]);
        inverse_round r4(a[4],key,6,a[5]);
        inverse_round r5(a[5],key,5,a[6]);
        inverse_round r6(a[6],key,4,a[7]);
        inverse_round r7(a[7],key,3,a[8]);
        inverse_round r8(a[8],key,2,a[9]); 
        inverse_round r9(a[9],key,1,a[10]);
        
        inverse_last_round r10(a[10],key,0,decrypt_data);
endmodule
