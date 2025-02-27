module inverse_round(
    input [127:0] data_input,key,
    input [3:0]round_no,
    output [127:0] data_output
    );
    wire [127:0]d1,d2,d3;
    
    
    
     Inverse_shift_rows  s1(data_input,d1);
     Inverse_sub_byte  sr1(d1,d2);
     add_round_key r1(d2,key,round_no,d3);
     inverse_mix_column m1(d3,data_output);
   
endmodule
