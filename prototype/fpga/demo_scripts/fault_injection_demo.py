#!/usr/bin/env python3
"""
Fault Injection Demo for Safety Subsystem via UART/FTDI
Requires: pyserial
"""

import serial
import time
import struct

def inject_ecc_error(ser, data: int, bit_pos: int) -> dict:
    """Inject single-bit error and read response"""
    corrupted = data ^ (1 << bit_pos)
    ser.write(struct.pack('<II', corrupted, 0xFFFFFFFF))  # data + mask
    resp = ser.read(8)
    return {
        'corrected': bool(resp[0]),
        'panic': bool(resp[1]),
        'data_out': struct.unpack('<I', resp[2:6])[0]
    }

def test_watchdog(ser):
    """Stop feeding watchdog and measure reset time"""
    print("Stopping WDI feed...")
    t0 = time.time()
    ser.write(b'STOP_WDI')
    # Wait for reset assertion (detected via UART disconnect/reconnect)
    time.sleep(1.0)
    t1 = time.time()
    print(f"Reset detected after {(t1-t0)*1000:.1f} ms")

def main():
    ser = serial.Serial('/dev/ttyUSB1', 115200, timeout=1)
    
    print("=== ECC Single-Bit Correction Test ===")
    for bit in [0, 5, 12, 31]:
        result = inject_ecc_error(ser, 0xA5A5A5A5, bit)
        print(f"  Bit {bit}: corrected={result['corrected']}, panic={result['panic']}")
    
    print("\n=== ECC Double-Bit Detection Test ===")
    data = 0x5A5A5A5A
    corrupted = data ^ 0x00000005  # Flip bits 0 and 2
    result = inject_ecc_error(ser, corrupted, 0)  # Already corrupted
    print(f"  2-bit error: panic={result['panic']} (expected=True)")
    
    print("\n=== Watchdog Timeout Test ===")
    test_watchdog(ser)
    
    ser.close()

if __name__ == '__main__':
    main()
