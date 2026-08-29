//-----------------------------------------------------------------------------
// Module: hamming_ecc_encoder
// Description: Hamming (39,32) SEC-DED encoder
//              Generates 7 check bits + 1 overall parity for 32 data bits
//-----------------------------------------------------------------------------
module hamming_ecc_encoder (
    input  logic [31:0] data_in,
    output logic [38:0] ecc_out  // {data[31:0], check[6:0]}
);

    logic [6:0] check_bits;
    logic       overall_parity;

    // Check bit generation (standard Hamming positions mapped linearly)
    // c0 covers bits where bit index has bit0 set (1,2,4,5,7,9,11,12,14,16,18,20,22,24,26,28,30,32,35,37)
    // Simplified: using XOR reduction over selected data bits
    assign check_bits[0] = ^{data_in[0], data_in[1], data_in[3], data_in[4], data_in[6],
                             data_in[8], data_in[10], data_in[11], data_in[13], data_in[15],
                             data_in[17], data_in[19], data_in[21], data_in[23], data_in[25],
                             data_in[27], data_in[29], data_in[31]};
    
    assign check_bits[1] = ^{data_in[0], data_in[2], data_in[3], data_in[5], data_in[6],
                             data_in[9], data_in[10], data_in[12], data_in[13], data_in[16],
                             data_in[17], data_in[20], data_in[21], data_in[24], data_in[25],
                             data_in[28], data_in[29]};
    
    assign check_bits[2] = ^{data_in[1], data_in[2], data_in[3], data_in[7], data_in[8],
                             data_in[9], data_in[10], data_in[14], data_in[15], data_in[16],
                             data_in[17], data_in[22], data_in[23], data_in[24], data_in[25],
                             data_in[30], data_in[31]};
    
    assign check_bits[3] = ^{data_in[4], data_in[5], data_in[6], data_in[7], data_in[8],
                             data_in[9], data_in[10], data_in[18], data_in[19], data_in[20],
                             data_in[21], data_in[22], data_in[23], data_in[24], data_in[25]};
    
    assign check_bits[4] = ^{data_in[11], data_in[12], data_in[13], data_in[14], data_in[15],
                             data_in[16], data_in[17], data_in[18], data_in[19], data_in[20],
                             data_in[21], data_in[22], data_in[23], data_in[24], data_in[25]};
    
    assign check_bits[5] = ^{data_in[26], data_in[27], data_in[28], data_in[29], data_in[30],
                             data_in[31]};
    
    assign check_bits[6] = ^{data_in[0], data_in[1], data_in[2], data_in[3], data_in[4],
                             data_in[5], data_in[6], data_in[7], data_in[8], data_in[9],
                             data_in[10], data_in[11], data_in[12], data_in[13], data_in[14],
                             data_in[15], data_in[16], data_in[17], data_in[18], data_in[19],
                             data_in[20], data_in[21], data_in[22], data_in[23], data_in[24],
                             data_in[25], data_in[26], data_in[27], data_in[28], data_in[29],
                             data_in[30], data_in[31], check_bits[0], check_bits[1], check_bits[2],
                             check_bits[3], check_bits[4], check_bits[5]};

    assign ecc_out = {data_in, check_bits};

endmodule
