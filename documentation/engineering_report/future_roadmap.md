# Future Roadmap (0–24 Months)

## Phase 0: Architecture (Months 1–3)
- [x] System specification freeze
- [x] SysML model
- [x] 11-parameter interface matrix
- [x] Subsystem specs

## Phase 1: RTL Design (Months 4–9)
- [x] SystemVerilog RTL
- [x] UVM testbenches
- [x] 100% functional coverage
- [x] Formal proofs for AXI/deadlock

## Phase 2: FPGA Prototype (Months 10–12)
- [x] Nexys A7 bitstream
- [x] Zephyr integration
- [x] HIL validation

## Phase 3: Tape-out Prep (Months 13–15)
- [ ] DRC/LVS clean (SCL 180nm / Dholera 28nm)
- [ ] STA closure
- [ ] BIST/scan insertion
- [ ] MPW submission

## Phase 4: Silicon Bring-up (Months 16–18)
- [ ] JTAG chain functional
- [ ] CPU boots Zephyr
- [ ] Memory tests pass
- [ ] NPU executes MAC

## Phase 5: Integration (Months 19–21)
- [ ] End-to-end interfaces
- [ ] OTA update
- [ ] Secure boot lock
- [ ] Matter commissioning

## Phase 6: Certification (Months 22–24)
- [ ] Matter/Thread PTS pass
- [ ] ISO 26262 ASIL-D pre-audit
- [ ] AIS-140 type approval
- [ ] PSA Certified Level 2

## Stretch Goals
- [ ] Triple-modular redundancy (TMR) for voter
- [ ] Adaptive ECC (switch between SEC-DED and SEC-DAEC)
- [ ] Machine-learning-based fault prediction
- [ ] RISC-V PMP + IOPMP integration
