// Formal properties for AXI4 protocol compliance
module axi_protocol_assertions (
    input logic        aclk,
    input logic        aresetn,
    input logic [31:0] awaddr,
    input logic        awvalid,
    input logic        awready,
    input logic [31:0] wdata,
    input logic        wvalid,
    input logic        wready,
    input logic        bvalid,
    input logic        bready
);

    // AWVALID stability
    assert property (@(posedge aclk)
        awvalid && !awready |-> ##1 awvalid);

    // WVALID stability
    assert property (@(posedge aclk)
        wvalid && !wready |-> ##1 wvalid);

    // Response follows write
    assert property (@(posedge aclk)
        (wvalid && wready) |-> s_eventually (bvalid && bready));

endmodule
