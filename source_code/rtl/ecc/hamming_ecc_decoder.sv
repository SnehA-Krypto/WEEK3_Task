//-----------------------------------------------------------------------------
// Module: hamming_ecc_decoder
// Description: Hamming (39,32) SEC-DED decoder
//              Corrects 1-bit errors, detects 2-bit errors
//-----------------------------------------------------------------------------
module hamming_ecc_decoder (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [38:0] data_in,      // {data[31:0], check[6:0]}
    output logic [31:0] data_out,
    output logic        corrected,
    output logic        ecc_panic     // 2-bit error detected
);

    logic [31:0] raw_data;
    logic [6:0]  raw_check;
    logic [6:0]  syndrome;
    logic [31:0] corrected_data;
    logic        parity_ok;
    logic        syndrome_zero;

    assign raw_data  = data_in[38:7];
    assign raw_check = data_in[6:0];

    // Syndrome calculation (same XOR tree as encoder)
    assign syndrome[0] = ^{raw_data[0], raw_data[1], raw_data[3], raw_data[4], raw_data[6],
                           raw_data[8], raw_data[10], raw_data[11], raw_data[13], raw_data[15],
                           raw_data[17], raw_data[19], raw_data[21], raw_data[23], raw_data[25],
                           raw_data[27], raw_data[29], raw_data[31], raw_check[0]};
    
    assign syndrome[1] = ^{raw_data[0], raw_data[2], raw_data[3], raw_data[5], raw_data[6],
                           raw_data[9], raw_data[10], raw_data[12], raw_data[13], raw_data[16],
                           raw_data[17], raw_data[20], raw_data[21], raw_data[24], raw_data[25],
                           raw_data[28], raw_data[29], raw_check[1]};
    
    assign syndrome[2] = ^{raw_data[1], raw_data[2], raw_data[3], raw_data[7], raw_data[8],
                           raw_data[9], raw_data[10], raw_data[14], raw_data[15], raw_data[16],
                           raw_data[17], raw_data[22], raw_data[23], raw_data[24], raw_data[25],
                           raw_data[30], raw_data[31], raw_check[2]};
    
    assign syndrome[3] = ^{raw_data[4], raw_data[5], raw_data[6], raw_data[7], raw_data[8],
                           raw_data[9], raw_data[10], raw_data[18], raw_data[19], raw_data[20],
                           raw_data[21], raw_data[22], raw_data[23], raw_data[24], raw_data[25],
                           raw_check[3]};
    
    assign syndrome[4] = ^{raw_data[11], raw_data[12], raw_data[13], raw_data[14], raw_data[15],
                           raw_data[16], raw_data[17], raw_data[18], raw_data[19], raw_data[20],
                           raw_data[21], raw_data[22], raw_data[23], raw_data[24], raw_data[25],
                           raw_check[4]};
    
    assign syndrome[5] = ^{raw_data[26], raw_data[27], raw_data[28], raw_data[29], raw_data[30],
                           raw_data[31], raw_check[5]};
    
    assign syndrome[6] = ^{raw_data, raw_check};  // Overall parity

    assign syndrome_zero = ~|syndrome[5:0];
    assign parity_ok = ~syndrome[6];

    // Error position decode (simplified lookup for data bits 0-31)
    always_comb begin
        corrected_data = raw_data;
        case (syndrome[5:0])
            6'd1:  corrected_data[0]  = ~raw_data[0];
            6'd2:  corrected_data[1]  = ~raw_data[1];
            6'd3:  corrected_data[2]  = ~raw_data[2];
            6'd4:  corrected_data[3]  = ~raw_data[3];
            6'd5:  corrected_data[4]  = ~raw_data[4];
            6'd6:  corrected_data[5]  = ~raw_data[5];
            6'd7:  corrected_data[6]  = ~raw_data[6];
            6'd8:  corrected_data[7]  = ~raw_data[7];
            6'd9:  corrected_data[8]  = ~raw_data[8];
            6'd10: corrected_data[9]  = ~raw_data[9];
            6'd11: corrected_data[10] = ~raw_data[10];
            6'd12: corrected_data[11] = ~raw_data[11];
            6'd13: corrected_data[12] = ~raw_data[12];
            6'd14: corrected_data[13] = ~raw_data[13];
            6'd15: corrected_data[14] = ~raw_data[14];
            6'd16: corrected_data[15] = ~raw_data[15];
            6'd17: corrected_data[16] = ~raw_data[16];
            6'd18: corrected_data[17] = ~raw_data[17];
            6'd19: corrected_data[18] = ~raw_data[18];
            6'd20: corrected_data[19] = ~raw_data[19];
            6'd21: corrected_data[20] = ~raw_data[20];
            6'd22: corrected_data[21] = ~raw_data[21];
            6'd23: corrected_data[22] = ~raw_data[22];
            6'd24: corrected_data[23] = ~raw_data[23];
            6'd25: corrected_data[24] = ~raw_data[24];
            6'd26: corrected_data[25] = ~raw_data[25];
            6'd27: corrected_data[26] = ~raw_data[26];
            6'd28: corrected_data[27] = ~raw_data[27];
            6'd29: corrected_data[28] = ~raw_data[28];
            6'd30: corrected_data[29] = ~raw_data[29];
            6'd31: corrected_data[30] = ~raw_data[30];
            6'd32: corrected_data[31] = ~raw_data[31];
            default: corrected_data = raw_data;
        endcase
    end

    // SEC-DED logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out   <= 32'h0;
            corrected  <= 1'b0;
            ecc_panic  <= 1'b0;
        end else begin
            data_out  <= corrected_data;
            corrected <= |syndrome[5:0] & parity_ok;  // 1-bit error corrected
            ecc_panic <= |syndrome[5:0] & ~parity_ok; // 2-bit error (or odd >2)
        end
    end

endmodule
