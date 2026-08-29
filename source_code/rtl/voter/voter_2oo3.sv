//-----------------------------------------------------------------------------
// Module: voter_2oo3
// Description: 2-out-of-3 voter for safety-critical outputs
//-----------------------------------------------------------------------------
module voter_2oo3 (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        a,          // Channel A
    input  logic        b,          // Channel B
    input  logic        c,          // Channel C
    output logic        voted_out,
    output logic        diagnostic_error
);

    logic ab, bc, ac;
    logic mismatch;

    assign ab = a & b;
    assign bc = b & c;
    assign ac = a & c;

    // 2oo3 voting: output is 1 if at least 2 inputs are 1
    assign voted_out = ab | bc | ac;

    // Diagnostic: detect if any channel disagrees with voted output
    assign mismatch = (a != voted_out) | (b != voted_out) | (c != voted_out);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            diagnostic_error <= 1'b0;
        else
            diagnostic_error <= mismatch;
    end

endmodule
