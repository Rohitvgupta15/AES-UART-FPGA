module sub_byte(
    input [127:0] result_state,
    output [127:0] new_sub_byte
    );
    genvar i;
    generate
       for(i = 0; i <= 15; i = i + 1)
           begin 
                 S_box s1(result_state[ (i*8)+7 : i*8 ], new_sub_byte[ (i*8)+7 : i*8 ]);
           end 
    endgenerate
endmodule
