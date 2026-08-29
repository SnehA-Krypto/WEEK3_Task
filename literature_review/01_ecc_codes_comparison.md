# ECC Codes Comparison for 32-bit SRAM Words

| Code | Data Bits | Check Bits | Overhead % | Logic Depth (gates) | SEC | DED | Notes |
|------|-----------|------------|------------|---------------------|-----|-----|-------|
| Hamming (39,32) | 32 | 7 | 21.9 | 3 | Yes | Yes | Standard, minimal overhead |
| Hsiao (72,64) | 64 | 8 | 12.5 | 4 | Yes | Yes | Better for wide buses |
| Reed-Solomon | 32 | 16 | 50.0 | 6 | 2-bit | 3-bit | High latency, complex |
| Berger | 32 | 6 | 18.8 | 2 | No | Yes | Only detection, no correction |
| Duplication + Parity | 32 | 32 | 100.0 | 1 | Yes | No | 100% area overhead |

**Selection Rationale**: Hamming (39,32) chosen for minimal latency, proven automotive usage, and simple RTL implementation.
