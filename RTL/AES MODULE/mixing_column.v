module mixing_column(
    input [127:0] shifted_matrix,
    output [127:0] final_matrix
    );
    
  //  wire [2:0]fixed_matrix[0:3][0:3];
    wire [31:0]w[0:3];
    
    assign w[0]=shifted_matrix[31:0];
    assign w[1]=shifted_matrix[63:32];
    assign w[2]=shifted_matrix[95:64];
    assign w[3]=shifted_matrix[127:96];
        
    matrix_mul m1(w[3],final_matrix[127:96]);
    matrix_mul m2(w[2],final_matrix[95:64]);
    matrix_mul m3(w[1],final_matrix[63:32]);
    matrix_mul m4(w[0],final_matrix[31:0]);
    
endmodule
