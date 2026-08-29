# Test Plan: Safety & Reliability Subsystem

## 1. Unit Tests

### ECC Unit Tests
| Test ID | Description | Expected Result | Status |
|---------|-------------|-----------------|--------|
| ECC-UT-01 | Encode random data, decode without error | data_out == data_in | PASS |
| ECC-UT-02 | Inject 1-bit error in each of 39 positions | corrected=1, data_out=original | PASS |
| ECC-UT-03 | Inject 2-bit error in adjacent positions | ecc_panic=1 | PASS |
| ECC-UT-04 | Inject 3-bit error | ecc_panic=1 (uncorrectable) | PASS |
| ECC-UT-05 | All-zeros input | consistent encoding/decoding | PASS |
| ECC-UT-06 | All-ones input | consistent encoding/decoding | PASS |

### Watchdog Unit Tests
| Test ID | Description | Expected Result | Status |
|---------|-------------|-----------------|--------|
| WDG-UT-01 | Feed within 500ms | No reset | PASS |
| WDG-UT-02 | Stop feeding | reset_n asserted in &lt;600ms | PASS |
| WDG-UT-03 | Enable lock after boot | Write to enable ignored | PASS |
| WDG-UT-04 | Reset pulse width | 100ms +/- 10% | PASS |

### Lockstep Unit Tests
| Test ID | Description | Expected Result | Status |
|---------|-------------|-----------------|--------|
| LST-UT-01 | Identical inputs | mismatch=0, error_n=1 | PASS |
| LST-UT-02 | 1-bit difference | mismatch=1, error_n=0 | PASS |
| LST-UT-03 | Stuck-at-0 fault injection | mismatch=1 | PASS |
| LST-UT-04 | Stuck-at-1 fault injection | mismatch=1 | PASS |

## 2. Integration Tests
| Test ID | Description | Expected Result | Status |
|---------|-------------|-----------------|--------|
| INT-01 | ECC panic triggers safe state | reset_n asserted, error_n=0 | PASS |
| INT-02 | Lockstep mismatch triggers safe state | reset_n asserted, error_n=0 | PASS |
| INT-03 | Voter diagnostic triggers safe state | reset_n asserted | PASS |
| INT-04 | BIST fail triggers safe state | reset_n asserted | PASS |

## 3. Formal Verification
| Property | Tool | Status |
|----------|------|--------|
| AXI protocol compliance | SymbiYosys | PASS |
| Deadlock freedom | SymbiYosys | PASS |
| Secure boot FSM coverage | SymbiYosys | PASS |
| ECC decoder: panic implies | SymbiYosys | PASS |
|   syndrome != 0 && !parity_ok | | |

## 4. Regression
- Nightly build runs all UVM tests
- Coverage target: 100% functional, 100% toggle, 100% FSM state
