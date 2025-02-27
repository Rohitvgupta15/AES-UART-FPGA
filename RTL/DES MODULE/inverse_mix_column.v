module inverse_mix_column(
    input [127:0] data_in,
    output [127:0] data_out
    );
    
      wire [31:0]w[0:3];
      
       assign w[0] = data_in[31:0];
       assign w[1] = data_in[63:32];
       assign w[2] = data_in[95:64];
       assign w[3] = data_in[127:96];
       
        inverse_matrix_mul m1(w[3],data_out[127:96]);
        inverse_matrix_mul m2(w[2],data_out[95:64]);
        inverse_matrix_mul m3(w[1],data_out[63:32]);
        inverse_matrix_mul m4(w[0],data_out[31:0]);
    
endmodule
