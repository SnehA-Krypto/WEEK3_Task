# Survey: Hamming SEC-DED Codes for Safety-Critical SRAM

## Summary
Hamming codes are the dominant ECC scheme for on-chip SRAM in automotive SoCs. This survey covers classical Hamming (39,32), extended Hamming with SEC-DED, and comparisons with Hsiao codes.

## Key Findings
1. **Overhead**: Hamming (39,32) adds 7 check bits per 32 data bits → 21.9% overhead
2. **Latency**: Encoder = 1 XOR tree depth (~1.5 ns in 28nm); Decoder = syndrome calc + correction mux (~2.1 ns)
3. **Coverage**: 100% single-bit correction, 100% double-bit detection, 0% correction for >2 bits
4. **Alternative**: Hsiao (72,64) reduces logic depth by 15% but requires wider data path

## References
- Hamming, R.W. "Error Detecting and Error Correcting Codes." Bell System Technical Journal, 1950.
- Hsiao, M.Y. "A Class of Optimal Minimum Odd-Weight-Column SEC-DED Codes." IBM J. R&D, 1970.
- ARM Cortex-R52 TRM: "ECC Protection for Tightly-Coupled Memory."
