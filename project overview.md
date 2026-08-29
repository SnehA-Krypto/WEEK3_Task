## 1. Introduction

### 1.1 Project Overview

The **SHIELD6** is a hardware-based safety IP designed for integration into RISC-V SoCs targeting automotive (**ASIL-D**) and industrial (**SIL 3**) deployments.

The subsystem provides autonomous fault detection and recovery without CPU intervention, ensuring deterministic safe-state transitions under all single-point fault conditions.

### 1.2 Objectives

| ID | Objective | Target |
|---|---|---|
| OBJ-01 | Detect and recover from software deadlock | < 500 ms |
| OBJ-02 | Correct single-bit SRAM errors without CPU intervention | SEC-DED Hamming (39,32) |
| OBJ-03 | Provide 2-out-of-3 voter logic for safety-critical outputs | Brake, e-stop |
| OBJ-04 | Achieve > 99% single-point fault diagnostic coverage | ISO 26262 |
| OBJ-05 | FIT rate for safety-critical functions | < 10 FIT |

### 1.3 Scope

This report covers the complete design lifecycle from architecture specification through RTL implementation, FPGA prototyping, and verification.

The subsystem comprises five core modules:

1. Hamming ECC encoder/decoder
2. Independent watchdog timer
3. Dual-core lockstep comparator
4. 2-out-of-3 voter with diagnostics
5. STUMPS-based LBIST controller

---

# 2. Executive Summary

## 2.1 Architecture at a Glance

The safety subsystem operates as an autonomous hardware monitor parallel to the main CPU pipeline. All safety-critical decisions execute in dedicated hardware to eliminate software single-points-of-failure.

```text
                    +------------------+
    Primary Core -->|  Delay Latch     |--+
                    +------------------+  |
                                          v
    Secondary Core -----------------> [Core Comparator] --> Mismatch Detect
                                          |
                    +------------------+  |
    SRAM/TCM -----> | ECC Decoder      |  |
    (39-bit word)   | (SEC-DED)        |  |
                    +------------------+  |
                          |              |
                    +-----+--------------+-----+
                    |           |             |
                    v           v             v
               [Watchdog]  [2oo3 Voter]  [LBIST]
               (32 kHz)    (Brake/E-stop) (MISR)
