//-----------------------------------------------------------------------------
// Module: independent_watchdog
// Description: Independent Watchdog Timer (IWDG)
//              32 kHz RC oscillator, 500 ms timeout, 100 ms reset pulse
//-----------------------------------------------------------------------------
module independent_watchdog (
    input  logic iwdg_clk,      // 32 kHz independent clock
    input  logic rst_n,
    input  logic wdi,           // Watchdog feed input
    input  logic enable,        // Write-once enable from boot
    output logic reset_n,       // Active-low system reset
    output logic error_n        // Safety fault output
);

    // 32 kHz * 0.5s = 16000 counts
    localparam TIMEOUT_COUNT = 16'd16000;
    localparam RESET_PULSE_COUNT = 16'd3200; // 100 ms

    logic [15:0] counter;
    logic [15:0] reset_pulse_counter;
    logic        wdi_sync, wdi_prev;
    logic        enabled_reg;
    logic        timeout_occurred;
    logic        in_reset_pulse;

    // Synchronize WDI to iwdg_clk domain
    always_ff @(posedge iwdg_clk or negedge rst_n) begin
        if (!rst_n) begin
            wdi_sync <= 1'b0;
            wdi_prev <= 1'b0;
        end else begin
            wdi_sync <= wdi;
            wdi_prev <= wdi_sync;
        end
    end

    // Enable latch (write-once)
    always_ff @(posedge iwdg_clk or negedge rst_n) begin
        if (!rst_n)
            enabled_reg <= 1'b0;
        else if (!enabled_reg)
            enabled_reg <= enable; // Latch on first assertion
    end

    // Timeout counter
    always_ff @(posedge iwdg_clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 16'd0;
            timeout_occurred <= 1'b0;
        end else if (!enabled_reg) begin
            counter <= 16'd0;
            timeout_occurred <= 1'b0;
        end else if (wdi_sync && !wdi_prev) begin // Rising edge of WDI
            counter <= 16'd0;
            timeout_occurred <= 1'b0;
        end else if (counter >= TIMEOUT_COUNT) begin
            timeout_occurred <= 1'b1;
            counter <= counter;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    // Reset pulse generator
    always_ff @(posedge iwdg_clk or negedge rst_n) begin
        if (!rst_n) begin
            in_reset_pulse <= 1'b0;
            reset_pulse_counter <= 16'd0;
        end else if (timeout_occurred && !in_reset_pulse) begin
            in_reset_pulse <= 1'b1;
            reset_pulse_counter <= 16'd0;
        end else if (in_reset_pulse) begin
            if (reset_pulse_counter >= RESET_PULSE_COUNT) begin
                in_reset_pulse <= 1'b0;
                reset_pulse_counter <= 16'd0;
            end else begin
                reset_pulse_counter <= reset_pulse_counter + 1'b1;
            end
        end
    end

    assign reset_n = in_reset_pulse ? 1'b0 : 1'bz; // Open-drain behavior
    assign error_n = timeout_occurred ? 1'b0 : 1'b1;

endmodule
