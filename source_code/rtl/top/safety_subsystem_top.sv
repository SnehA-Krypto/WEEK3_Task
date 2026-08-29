//-----------------------------------------------------------------------------
// Module: safety_subsystem_top
// Description: Top-level integration of all safety modules
//-----------------------------------------------------------------------------
module safety_subsystem_top (
    input  logic        sys_clk,
    input  logic        iwdg_clk,
    input  logic        rst_n,
    input  logic        wdi,
    input  logic        enable_iwdg,
    input  logic [38:0] ecc_data_in,
    input  logic [31:0] primary_core_data,
    input  logic [31:0] secondary_core_data,
    input  logic        primary_valid,
    input  logic        secondary_valid,
    input  logic        voter_a,
    input  logic        voter_b,
    input  logic        voter_c,
    input  logic        bist_en,
    input  logic        scan_in,
    output logic [31:0] ecc_data_out,
    output logic        ecc_panic,
    output logic        reset_n,
    output logic        error_n,
    output logic        voter_out,
    output logic        voter_diag_err,
    output logic        bist_done,
    output logic [31:0] bist_sig,
    output logic        bist_pass,
    output logic        scan_out,
    output logic        lockstep_mismatch
);

    // ECC instance
    hamming_ecc_decoder u_ecc (
        .clk        (sys_clk),
        .rst_n      (rst_n),
        .data_in    (ecc_data_in),
        .data_out   (ecc_data_out),
        .corrected  (),
        .ecc_panic  (ecc_panic)
    );

    // Watchdog instance
    independent_watchdog u_wdg (
        .iwdg_clk   (iwdg_clk),
        .rst_n      (rst_n),
        .wdi        (wdi),
        .enable     (enable_iwdg),
        .reset_n    (reset_n),
        .error_n    (error_n)
    );

    // Lockstep comparator instance
    core_comparator u_cmp (
        .clk             (sys_clk),
        .rst_n           (rst_n),
        .primary_data    (primary_core_data),
        .secondary_data  (secondary_core_data),
        .primary_valid   (primary_valid),
        .secondary_valid (secondary_valid),
        .mismatch        (lockstep_mismatch),
        .error_n         ()
    );

    // 2oo3 Voter instance
    voter_2oo3 u_voter (
        .clk             (sys_clk),
        .rst_n           (rst_n),
        .a               (voter_a),
        .b               (voter_b),
        .c               (voter_c),
        .voted_out       (voter_out),
        .diagnostic_error(voter_diag_err)
    );

    // LBIST instance
    lbist_controller u_bist (
        .bist_clk   (sys_clk),
        .rst_n      (rst_n),
        .bist_en    (bist_en),
        .scan_in    (scan_in),
        .scan_out   (scan_out),
        .bist_done  (bist_done),
        .bist_sig   (bist_sig),
        .bist_pass  (bist_pass)
    );

endmodule.
