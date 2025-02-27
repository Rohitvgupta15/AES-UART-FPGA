module zero_round(
    input [127:0] data_in,
    input [127:0]key,
    output [127:0] data_out
    );
    
     add_round_key r0(data_in,key,0,data_out);
     
endmodule
