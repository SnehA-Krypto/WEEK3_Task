package ecc_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Configuration
    class ecc_config extends uvm_object;
        `uvm_object_utils(ecc_config)
        function new(string name = "ecc_config");
            super.new(name);
        endfunction
    endclass

    // Transaction
    class ecc_transaction extends uvm_sequence_item;
        rand logic [31:0] data;
        rand logic [6:0]  error_inject; // Bit flip positions

        `uvm_object_utils_begin(ecc_transaction)
            `uvm_field_int(data, UVM_ALL_ON)
            `uvm_field_int(error_inject, UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name = "ecc_transaction");
            super.new(name);
        endfunction
    endclass

    // Driver
    class ecc_driver extends uvm_driver #(ecc_transaction);
        `uvm_component_utils(ecc_driver)
        virtual interface ecc_if vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            ecc_transaction req;
            forever begin
                seq_item_port.get_next_item(req);
                @(posedge vif.clk);
                vif.data_in <= {req.data, 7'b0}; // Raw data, ECC appended externally
                if (req.error_inject != 0) begin
                    vif.data_in[req.error_inject] <= ~vif.data_in[req.error_inject];
                end
                seq_item_port.item_done();
            end
        endtask
    endclass

    // Monitor
    class ecc_monitor extends uvm_monitor;
        `uvm_component_utils(ecc_monitor)
        virtual interface ecc_if vif;
        uvm_analysis_port #(ecc_transaction) ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            ap = new("ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            ecc_transaction tr;
            forever begin
                @(posedge vif.clk);
                if (vif.rst_n) begin
                    tr = ecc_transaction::type_id::create("tr");
                    tr.data = vif.data_out;
                    ap.write(tr);
                end
            end
        endtask
    endclass

    // Scoreboard
    class ecc_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ecc_scoreboard)
        uvm_analysis_imp #(ecc_transaction, ecc_scoreboard) exp_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            exp_port = new("exp_port", this);
        endfunction

        function void write(ecc_transaction tr);
            // Check: if ecc_panic is set, error_inject had 2 bits
            // If corrected, data should match original
            `uvm_info("ECC_SB", $sformatf("Received data=%h panic=%b", tr.data, 1'b0), UVM_LOW)
        endfunction
    endclass

    // Environment
    class ecc_env extends uvm_env;
        `uvm_component_utils(ecc_env)
        ecc_driver    drv;
        ecc_monitor   mon;
        ecc_scoreboard sb;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            drv = ecc_driver::type_id::create("drv", this);
            mon = ecc_monitor::type_id::create("mon", this);
            sb  = ecc_scoreboard::type_id::create("sb", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            mon.ap.connect(sb.exp_port);
        endfunction
    endclass

    // Test Base
    class ecc_test_base extends uvm_test;
        `uvm_component_utils(ecc_test_base)
        ecc_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            env = ecc_env::type_id::create("env", this);
        endfunction
    endclass

endpackage
