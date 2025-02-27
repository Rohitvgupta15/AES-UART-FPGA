module top_des (
    input clock,
    input reset,
    input transmit,
    input rx,
    input [3:0] in,
    
    output [6:0] seg,   // 7 segments
    output [3:0] an, 
    output tx,
    output [7:0] led,
    output heartbeat,
    output reg full
);
    // Heartbeat signal for debugging
    reg [27:0] heartbeat_counter;
    always @(posedge clock) heartbeat_counter <= heartbeat_counter + 1;
    assign heartbeat = heartbeat_counter[27];

    // UART receiver signals
    wire dv;                     // Data valid signal
    wire [7:0] rx_data;         // Received data byte
    uart_rx RX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d868),
        .i_Reset(reset),
        .i_Rx_Serial(rx),
        .o_Rx_DV(dv),
        .o_Rx_Byte(rx_data)
    );

    // Shift register and byte counter
    reg [127:0] shift_reg;      // 128-bit shift register
    reg [3:0] byte_count1;      // Byte count for received data

    // FSM State Definitions for Reception
    localparam ZERO = 2'b00, RECEIVE = 2'b01, FULL = 2'b10;
    reg [1:0] state;            // FSM state for reception

    // FSM for data reception and shifting
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state <= ZERO;
            shift_reg <= 128'd0;
            byte_count1 <= 4'd0;
            full <= 1'b0;
        end else begin
            case (state)
                ZERO: begin
                    full <= 1'b0;  // Clear full flag
                    if (dv) begin
                        shift_reg <= {shift_reg[119:0], rx_data};  // Shift in received byte
                        byte_count1 <= byte_count1 + 1; // Increment byte count
                        if (byte_count1 == 4'd15) begin
                            state <= FULL;  // Transition to FULL state
                            full <= 1'b1;   // Set full flag
                        end else begin
                            state <= RECEIVE; // Stay in RECEIVE state
                        end
                    end
                end
                RECEIVE: begin
                    if (dv) begin
                        shift_reg <= {shift_reg[119:0], rx_data};  // Shift in next byte
                        byte_count1 <= byte_count1 + 1;
                        if (byte_count1 == 4'd15) begin
                            state <= FULL;  // Transition to FULL state
                            full <= 1'b1;   // Set full flag
                        end
                    end
                end
                FULL: begin
                    // Remain in FULL state until the data is transmitted
                end
            endcase
        end
    end

    assign led = shift_reg[7:0];  // Output first byte for debugging

    // Instantiate the segment display module
   
   wire [127:0]decrypt_data;
   AES_decryption_top uut( .encrypt_data(shift_reg),
                           .key(128'h6d6120686f6f6f6f6f6e20726f686974),
                           .decrypt_data(decrypt_data)
                           );
                          
    segment s11 (
        .clk(clock),
        .in(in),
        .data(decrypt_data),
        .seg(seg),
        .an(an)
    );                        
    // UART transmitter signals
    wire active, done;               // UART transmitter status signals
    reg tx_data_valid;               // Control signal to trigger transmission
    reg [7:0] tx_byte;               // Byte to send through UART
    reg [3:0] byte_count;            // Counter for sent bytes
    reg [27:0] buffer_counter;       // Counter for buffer delay
    reg buffer_ready;                // Buffer delay status
    wire transmit_level, transmit_pulse; // Debounced transmit button signals

    // Debounce the transmit push button
    debouncer DEBOUNCE (
        .clock(clock),
        .button(transmit),
        .level(transmit_level),
        .pulse(transmit_pulse)
    );

    // UART transmitter
    uart_tx TX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d868),       // Baud rate setting
        .i_Tx_DV(tx_data_valid),      // Data valid signal
        .i_Reset(reset),
        .i_Tx_Byte(tx_byte),          // 8-bit data to transmit
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(done)
    );

    // FSM State Definitions for Transmission
    localparam IDLE1 = 2'b00, SEND_BYTE = 2'b01, WAIT_BUFFER = 2'b10;
    reg [1:0] state1;                 // FSM state for transmission
    reg [127:0] shift_reg_internal;  // Internal shift register to hold data for transmission

    // FSM for transmission with buffer delay
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            byte_count <= 0;              // Reset byte count
            shift_reg_internal <= 128'h0; // Reset shift register
            tx_data_valid <= 0;           // Data not ready for transmission
            buffer_counter <= 0;          // Reset buffer counter
            buffer_ready <= 0;            // Buffer delay is initially not ready
            state1 <= IDLE1;              // Initial state
        end else begin
            if (full && (state1 == IDLE1)) begin
                shift_reg_internal <= decrypt_data; // Load received data when full
                byte_count <= 0; // Reset byte count
            end
            
            case (state1)
                IDLE1: begin
                    if (transmit_pulse && full) begin // Ensure transmission starts only if full
                        tx_byte <= shift_reg_internal[127:120]; // Load the first byte (MSB)
                        shift_reg_internal <= {shift_reg_internal[119:0], 8'b0}; // Shift the register
                        tx_data_valid <= 1; // Start transmitting the first byte
                        state1 <= SEND_BYTE; // Move to SEND_BYTE state
                    end
                end
                SEND_BYTE: begin
                    if (done) begin
                        tx_data_valid <= 0; // Transmission done for the current byte
                        buffer_counter <= 0; // Reset buffer counter
                        buffer_ready <= 0; // Buffer not ready yet
                        state1 <= WAIT_BUFFER; // Move to WAIT_BUFFER state
                    end
                end
                WAIT_BUFFER: begin
                    if (buffer_counter == 'd100000) begin
                        buffer_ready <= 1;            // Buffer delay completed (adjust value for your system clock)
                    end else begin
                        buffer_counter <= buffer_counter + 1;  // Increment buffer counter
                    end 

                    if (buffer_ready) begin
                        if (byte_count < 15) begin // Now we're dealing with 16 bytes (128 bits / 8 bits)
                            byte_count <= byte_count + 1; // Increment byte count
                            tx_byte <= shift_reg_internal[127:120]; // Load the next byte
                            shift_reg_internal <= {shift_reg_internal[119:0], 8'b0}; // Shift the register
                            tx_data_valid <= 1; // Start transmitting the next byte
                            state1 <= SEND_BYTE; // Go back to SEND_BYTE state
                        end else begin
                            state1 <= IDLE1; // Go back to IDLE after all bytes sent
                        end
                    end
                end
            endcase
        end
    end           
endmodule
