//-----------------------------------------------------------------------------
// Module: core_comparator
// Description: Cycle-by-cycle comparison of dual-core pipeline outputs
//-----------------------------------------------------------------------------
module core_comparator (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] primary_data,
    input  logic [31:0] secondary_data,
    input  logic        primary_valid,
    input  logic        secondary_valid,
    output logic        mismatch,
    output logic        error_n
);

    logic [31:0] secondary_delayed;
    logic        valid_delayed;
    logic        compare_en;

    // Delay latch for secondary core (1-cycle delay for lockstep alignment)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            secondary_delayed <= 32'h0;
            valid_delayed     <= 1'b0;
        end else begin
            secondary_delayed <= secondary_data;
            valid_delayed     <= secondary_valid;
        end
    end

    assign compare_en = primary_valid & valid_delayed;

    // Comparison logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mismatch <= 1'b0;
            error_n  <= 1'b1;
        end else begin
            if (compare_en) begin
                mismatch <= (primary_data != secondary_delayed);
                error_n  <= (primary_data == secondary_delayed) ? 1'b1 : 1'b0;
            end else begin
                mismatch <= 1'b0;
                error_n  <= 1'b1;
            end
        end
    end

endmodule
