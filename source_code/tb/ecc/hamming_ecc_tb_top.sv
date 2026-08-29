`timescale 1ns/1ps

interface ecc_if;
    logic        clk;
    logic        rst_n;
    logic [38:0] data_in;
    logic [31:0] data_out;
    logic        corrected;
    logic        ecc_panic;
endinterface

module hamming_ecc_tb_top;
    import uvm_pkg::*;
    import ecc_env_pkg::*;

    ecc_if vif();

    // DUT
    hamming_ecc_decoder u_dut (
        .clk       (vif.clk),
        .rst_n     (vif.rst_n),
        .data_in   (vif.data_in),
        .data_out  (vif.data_out),
        .corrected (vif.corrected),
        .ecc_panic (vif.ecc_panic)
    );

    // Clock
    initial begin
        vif.clk = 0;
        forever #5 vif.clk = ~vif.clk; // 100 MHz
    end

    // Reset
    initial begin
        vif.rst_n = 0;
        #100 vif.rst_n = 1;
    end

    // UVM start
    initial begin
        uvm_config_db#(virtual ecc_if)::set(null, "*", "vif", vif);
        run_test("ecc_test_base");
    end

    // Waveform dump
    initial begin
        $dumpfile("ecc_tb.vcd");
        $dumpvars(0, hamming_ecc_tb_top);
    end

endmodule/
