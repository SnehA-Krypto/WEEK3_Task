# Safety Requirements Matrix

## Functional Requirements
| ID | Requirement | Verification Method | ASIL |
|----|-------------|---------------------|------|
| SAFE-F-01 | IWDG resets system if not fed within 500 ms | Stop feeding; verify RESET_N in &lt;600 ms | D |
| SAFE-F-02 | ECC corrects 1-bit and detects 2-bit error per 32-bit word | Fault injection: flip bits 0,1,2; verify | D |
| SAFE-F-03 | Dual-core lockstep compares pipeline outputs every cycle | Inject clock glitch; voter asserts error | D |
| SAFE-F-04 | Safe state on any fault: outputs de-energized, brake applied | FMEA: 10 fault types; verify 100% safe state | D |
| SAFE-F-05 | BIST runs on power-up; reports pass/fail within 50 ms | BIST controller simulation; signature match | B |

## Non-Functional Requirements
| ID | Requirement | Target |
|----|-------------|--------|
| SAFE-NF-01 | Watchdog clock independence | Separate RC oscillator; 10% accuracy |
| SAFE-NF-02 | ECC coverage | 100% of SRAM + cache + TCM |
| SAFE-NF-03 | Lockstep delay | &lt;1 cycle between primary and secondary |
| SAFE-NF-04 | Diagnostic coverage (ISO 26262) | &gt;99% single-point fault coverage |
| SAFE-NF-05 | FIT rate | &lt;10 FIT for safety-critical functions |
