module segment(
    input clk,                // Clock input
    input [3:0] in,           // Input control to select which part of data to display
    input [127:0] data,       // 128-bit data input
    output reg [6:0] seg,     // 7-segment display control
    output reg [3:0] an       // Anode control for 4 7-segment displays
);

    reg [3:0] out1, out2, out3, out4;  // To store 4 nibbles (4-bit outputs)
    reg [17:0] counter = 0;            // Counter for clock division
    reg [1:0] toggle_display = 0;      // Toggle signal to switch between displays
   // reg [127:0]data = 128'h0123456789abcdef0123456789abcdef;

    // Clock division to create a slower clock (adjust divisor as needed)
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 50000) begin  // Adjust this value based on your FPGA clock speed
            toggle_display <= toggle_display + 1; // Toggle between digits
            counter <= 0;
        end
    end

    // Extract 4 nibbles (hex digits) from 128-bit data based on input 'in'
    always @* begin
        case(in)
            4'h0: begin 
                out4 = data[127:124]; out3 = data[123:120]; out2 = data[119:116]; out1 = data[115:112]; 
            end
            4'h1: begin 
                out4 = data[111:108]; out3 = data[107:104]; out2 = data[103:100]; out1 = data[99:96]; 
            end
            4'h2: begin 
                out4 = data[95:92];  out3 = data[91:88];  out2 = data[87:84];  out1 = data[83:80]; 
            end
            4'h3: begin 
                out4 = data[79:76];  out3 = data[75:72];  out2 = data[71:68];  out1 = data[67:64]; 
            end
            4'h4: begin 
                out4 = data[63:60];  out3 = data[59:56];  out2 = data[55:52];  out1 = data[51:48]; 
            end
            4'h5: begin 
                out4 = data[47:44];  out3 = data[43:40];  out2 = data[39:36];  out1 = data[35:32]; 
            end
            4'h6: begin 
                out4 = data[31:28];  out3 = data[27:24];  out2 = data[23:20];  out1 = data[19:16]; 
            end
            4'h7: begin 
                out4 = data[15:12];  out3 = data[11:8];   out2 = data[7:4];    out1 = data[3:0];   
            end
            default: begin 
                out1 = 4'b0000; out2 = 4'b0000; out3 = 4'b0000; out4 = 4'b0000; 
            end
        endcase
    end

    // Multiplexing the 7-segment display
    always @* begin
        case(toggle_display)
            2'b00: begin
                // Display 'out1' on the first digit
                an = 4'b1110; // Enable first anode (an0)
                case(out1)
                    4'h0: seg = 7'b1000000;   // 0
                    4'h1: seg = 7'b1111001;   // 1
                    4'h2: seg = 7'b0100100;   // 2
                    4'h3: seg = 7'b0110000;   // 3
                    4'h4: seg = 7'b0011001;   // 4
                    4'h5: seg = 7'b0010010;   // 5
                    4'h6: seg = 7'b0000010;   // 6
                    4'h7: seg = 7'b1111000;   // 7
                    4'h8: seg = 7'b0000000;   // 8
                    4'h9: seg = 7'b0010000;   // 9
                    4'hA: seg = 7'b0001000;   // A
                    4'hB: seg = 7'b0000011;   // B
                    4'hC: seg = 7'b1000110;   // C
                    4'hD: seg = 7'b0100001;   // D
                    4'hE: seg = 7'b0000110;   // E
                    4'hF: seg = 7'b0001110;   // F
                    default: seg = 7'b1111111; // Blank display
                endcase
            end
            2'b01: begin
                // Display 'out2' on the second digit
                an = 4'b1101; // Enable second anode (an1)
                case(out2)
                    4'h0: seg = 7'b1000000;   // 0
                    4'h1: seg = 7'b1111001;   // 1
                    4'h2: seg = 7'b0100100;   // 2
                    4'h3: seg = 7'b0110000;   // 3
                    4'h4: seg = 7'b0011001;   // 4
                    4'h5: seg = 7'b0010010;   // 5
                    4'h6: seg = 7'b0000010;   // 6
                    4'h7: seg = 7'b1111000;   // 7
                    4'h8: seg = 7'b0000000;   // 8
                    4'h9: seg = 7'b0010000;   // 9
                    4'hA: seg = 7'b0001000;   // A
                    4'hB: seg = 7'b0000011;   // B
                    4'hC: seg = 7'b1000110;   // C
                    4'hD: seg = 7'b0100001;   // D
                    4'hE: seg = 7'b0000110;   // E
                    4'hF: seg = 7'b0001110;   // F
                    default: seg = 7'b1111111; // Blank display
                endcase
            end
            2'b10: begin
                // Display 'out3' on the third digit
                an = 4'b1011; // Enable third anode (an2)
                case(out3)
                    4'h0: seg = 7'b1000000;   // 0
                    4'h1: seg = 7'b1111001;   // 1
                    4'h2: seg = 7'b0100100;   // 2
                    4'h3: seg = 7'b0110000;   // 3
                    4'h4: seg = 7'b0011001;   // 4
                    4'h5: seg = 7'b0010010;   // 5
                    4'h6: seg = 7'b0000010;   // 6
                    4'h7: seg = 7'b1111000;   // 7
                    4'h8: seg = 7'b0000000;   // 8
                    4'h9: seg = 7'b0010000;   // 9
                    4'hA: seg = 7'b0001000;   // A
                    4'hB: seg = 7'b0000011;   // B
                    4'hC: seg = 7'b1000110;   // C
                    4'hD: seg = 7'b0100001;   // D
                    4'hE: seg = 7'b0000110;   // E
                    4'hF: seg = 7'b0001110;   // F
                    default: seg = 7'b1111111; // Blank display
                endcase
            end
            2'b11: begin
                // Display 'out4' on the fourth digit
                an = 4'b0111; // Enable fourth anode (an3)
                case(out4)
                    4'h0: seg = 7'b1000000;   // 0
                    4'h1: seg = 7'b1111001;   // 1
                    4'h2: seg = 7'b0100100;   // 2
                    4'h3: seg = 7'b0110000;   // 3
                    4'h4: seg = 7'b0011001;   // 4
                    4'h5: seg = 7'b0010010;   // 5
                    4'h6: seg = 7'b0000010;   // 6
                    4'h7: seg = 7'b1111000;   // 7
                    4'h8: seg = 7'b0000000;   // 8
                    4'h9: seg = 7'b0010000;   // 9
                    4'hA: seg = 7'b0001000;   // A
                    4'hB: seg = 7'b0000011;   // B
                    4'hC: seg = 7'b1000110;   // C
                    4'hD: seg = 7'b0100001;   // D
                    4'hE: seg = 7'b0000110;   // E
                    4'hF: seg = 7'b0001110;   // F
                    default: seg = 7'b1111111; // Blank display
                endcase
            end
        endcase
    end

endmodule
