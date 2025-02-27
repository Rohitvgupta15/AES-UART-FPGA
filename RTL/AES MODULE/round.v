module round(
    input [127:0] data_input,key,
    input [3:0]round_no,
    output [127:0] data_output
    );
    wire [127:0]d1,d2,d3;
    
    
    
    sub_byte      s1(data_input,d1);
    Shift_rows   sr1(d1,d2);
    mixing_column m1(d2,d3);
    add_round_key r1(d3,key,round_no,data_output);
endmodule
