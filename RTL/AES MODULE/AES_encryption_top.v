module AES_encryption_top(
    input [127:0] hex_input,
    input [127:0] key,
    output [127:0] encrypt_data
   // output reg done
    );
    wire [127:0]a[1:10];
    
    zero_round z1(hex_input,key,a[1]);
    
    round r1(a[1],key,1,a[2]);
    round r2(a[2],key,2,a[3]);
    round r3(a[3],key,3,a[4]);
    round r4(a[4],key,4,a[5]);
    round r5(a[5],key,5,a[6]);
    round r6(a[6],key,6,a[7]);
    round r7(a[7],key,7,a[8]);
    round r8(a[8],key,8,a[9]); //2
    round r9(a[9],key,9,a[10]);
    
    last_round L1(a[10],key,10,encrypt_data);

endmodule
