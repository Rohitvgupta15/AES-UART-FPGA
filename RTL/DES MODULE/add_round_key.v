module add_round_key(
    input [127:0] msg_state,
    input [127:0] key,
    input [3:0]round_no,
    output [127:0] result_state
    );
    wire [127:0]round_key;
    
    key_expansion k1(key,round_no,round_key);
    
    assign result_state = msg_state ^ round_key;

endmodule
