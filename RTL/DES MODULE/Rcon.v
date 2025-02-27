module Rcon(
        input [3:0] round_no,
        output reg [31:0] out
        );
        
        always @(*)
        begin 
        case(round_no)
           
           4'd1  : out = 32'h01000000;
           4'd2  : out = 32'h02000000;
           4'd3  : out = 32'h04000000;
           4'd4  : out = 32'h08000000;
           4'd5  : out = 32'h10000000;
           4'd6  : out = 32'h20000000;
           4'd7  : out = 32'h40000000;
           4'd8  : out = 32'h80000000;
           4'd9  : out = 32'h1b000000;
        4'd10 : out = 32'h36000000;
           
           default : out = 32'h00000000;
        endcase
        end   
    endmodule
