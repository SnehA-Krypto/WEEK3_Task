# Architecture Specification: Safety & Reliability Subsystem

## 1. Scope
This document defines the architecture of the safety subsystem integrated into a RISC-V SoC targeting ASIL-D / SIL 3.

## 2. Top-Level Block Diagram

+-------------------+        +-------------------+
|   Primary Core    |        |   Secondary Core  |
|   (RISC-V RV32)   |        |   (Lockstep Copy) |
+--------+----------+        +--------+----------+
|                            |
v                            v
+--------+----------+        +--------+----------+
|  Pipeline Output  |        |  Pipeline Output  |
|    (delayed 1c)   |        |                   |
+--------+----------+        +--------+----------+
|                            |
+------------+----------------+
|
v
+----------+----------+
|  Core Comparator    |
|  (cycle-by-cycle)   |
+----------+----------+
|
v
+----------+----------+
|   Safety Controller  |
|  (safe state logic)  |
+----------+----------+
|
+------------+------------+
|            |            |
v            v            v
+---------+  +---------+  +---------+
|  ECC    |  | Watchdog|  |  2oo3   |
|Decoder  |  | (IWDG)  |  | Voter   |
+---------+  +---------+  +---------+


## 3. Clocking
| Clock | Frequency | Source | Purpose |
|-------|-----------|--------|---------|
| sys_clk | 100 MHz | External crystal | Main system clock |
| iwdg_clk | 32 kHz | Internal RC oscillator | Watchdog timer |
| bist_clk | 100 MHz | Multiplexed from sys_clk | BIST scan clock |

## 4. Reset Strategy
- **Power-on Reset (POR)**: External RC holds RESET_N low for 10 ms
- **Watchdog Reset**: IWDG asserts RESET_N for 100 ms if not fed within 500 ms
- **Software Reset**: Write-once register in safety_ctrl; locked after boot
- **Safe State Reset**: Triggered by 2-bit ECC error, lockstep mismatch, or voter diagnostic failure

## 5. Safe State Definition
On any safety fault:
1. Assert RESET_N for 100 ms
2. Assert ERROR_N to external PLC/ECU
3. De-energize all outputs (VOTER_OUT = 0)
4. Apply brake (if connected to voter output)
5. Log fault type to 8-bit fault register



9/.
