# Interface Control Document (ICD)

## Signal List

| Signal | Direction | Width | Description | Timing |
|--------|-----------|-------|-------------|--------|
| wdi | Input | 1 | Watchdog feed pulse | Toggle every &lt;500 ms |
| reset_n | Output | 1 | Active-low open-drain reset | Asserted 100 ms on fault |
| error_n | Output | 1 | Active-low safety fault | Asserted until cleared |
| voter_out | Output | 1 | 2oo3 voted output | Updated every sys_clk |
| bist_sig | Internal | 32 | MISR signature | Valid after BIST done |
| data_in[31:0] | Input | 32 | Raw data to ECC encoder | Synchronous to sys_clk |
| data_out[31:0] | Output | 32 | Corrected data from ECC | 1-cycle latency |
| ecc_panic | Output | 1 | 2-bit error detected | Asserted immediately |
| sys_clk | Input | 1 | Main system clock | 100 MHz |
| iwdg_clk | Input | 1 | Watchdog clock | 32 kHz |
| bist_en | Input | 1 | BIST mode enable | Static during test |
| scan_in | Input | 1 | Scan chain input | bist_clk domain |
| scan_out | Output | 1 | Scan chain output | bist_clk domain |

## AXI4-Stream Interface (CPU &lt;-&gt; NPU)
| Parameter | Value |
|-----------|-------|
| Data width | 32-bit |
| Clock | sys_clk |
| Throughput | 800 MB/s (theoretical) |
| Integrity | Parity on WDATA |

## SPI Interface (CPU &lt;-&gt; Radio)
| Parameter | Value |
|-----------|-------|
| Clock | 8 MHz |
| Integrity | CRC-8 on SPI frame |
| Latency | &lt;10 µs |
