//-----------------------------------------------------------------------------
// Module: lbist_controller
// Description: STUMPS-based LBIST controller with MISR accumulator
//-----------------------------------------------------------------------------
module lbist_controller (
    input  logic        bist_clk,
    input  logic        rst_n,
    input  logic        bist_en,
    input  logic        scan_in,
    output logic        scan_out,
    output logic        bist_done,
    output logic [31:0] bist_sig,   // MISR signature
    output logic        bist_pass
);

    localparam SCAN_LENGTH = 256;
    localparam EXPECTED_MISR = 32'hA5B6C7D8; // Pre-computed expected signature

    logic [$clog2(SCAN_LENGTH)-1:0] scan_counter;
    logic [31:0] misr_reg;
    logic        running;

    // MISR accumulator (LFSR-based)
    function automatic [31:0] misr_update(input [31:0] current, input bit new_bit);
        logic feedback;
        feedback = current[31] ^ new_bit;
        misr_update = {current[30:0], feedback};
    endfunction

    // Controller FSM
    always_ff @(posedge bist_clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= '0;
            misr_reg     <= 32'hFFFFFFFF; // Seed
            running      <= 1'b0;
            bist_done    <= 1'b0;
            bist_pass    <= 1'b0;
        end else if (bist_en && !running) begin
            running <= 1'b1;
            scan_counter <= '0;
            misr_reg <= 32'hFFFFFFFF;
            bist_done <= 1'b0;
        end else if (running) begin
            misr_reg <= misr_update(misr_reg, scan_in);
            if (scan_counter >= SCAN_LENGTH-1) begin
                running <= 1'b0;
                bist_done <= 1'b1;
                bist_pass <= (misr_reg == EXPECTED_MISR);
            end else begin
                scan_counter <= scan_counter + 1'b1;
            end
        end
    end

    assign scan_out = scan_in; // Pass-through for serial chain
    assign bist_sig = misr_reg;

endmodule
