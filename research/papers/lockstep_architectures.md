# Survey: Dual-Core Lockstep for ASIL-D

## Summary
Lockstep execution compares the outputs of two identical processor cores cycle-by-cycle. Any mismatch triggers a safety exception.

## Architectures Compared
| Architecture | Delay | Area Overhead | Diagnostic Coverage |
|--------------|-------|---------------|---------------------|
| CoreCompare (ARM) | &lt;1 cycle | 85-100% | &gt;99% |
| Delay Latch (Infineon) | 1-2 cycles | 80-90% | &gt;99% |
| Diverse Dual-Core (NASA) | N/A | 150-200% | &gt;99.9% |

## Key Insight
Physical separation &gt;50 µm between core copies mitigates common-cause SEU. Diverse layout (mirrored floorplan) recommended.

## References
- Infineon AURIX TC3xx User Manual, "Lockstep CPU Comparison"
- ISO 26262-5:2018, Annex D — Digital Components Hardware Architectures
