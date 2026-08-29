# Subsystem Integration Test Plan

## Scope
Verify correct interaction between ECC, Watchdog, Lockstep, Voter, and BIST modules.

## Test Cases

### TC-INT-01: ECC Panic -&gt; Safe State
1. Configure system for normal operation
2. Inject 2-bit ECC error
3. Verify:
   - ecc_panic asserted within 1 cycle
   - error_n asserted within 2 cycles
   - reset_n asserted for 100ms
   - voter_out = 0 (de-energized)

### TC-INT-02: Lockstep Mismatch -&gt; Safe State
1. Run primary and secondary cores with identical code
2. Inject stuck-at fault on secondary core data bus
3. Verify:
   - lockstep_mismatch asserted within 1 cycle
   - Safe state entered within 3 cycles

### TC-INT-03: Power-On BIST -&gt; Normal Operation
1. Assert power-on reset
2. Release reset, BIST runs automatically
3. Verify:
   - bist_done asserted within 50ms
   - bist_pass = 1
   - System transitions to normal operation

### TC-INT-04: Cascaded Faults
1. Inject ECC error during lockstep mismatch
2. Verify:
   - First fault triggers safe state
   - Second fault does not corrupt safe state logic9
