# Watchdog Timer Design Patterns

## Pattern 1: Simple Timeout Watchdog
- Counter increments on independent clock
- Software must clear before threshold
- **Risk**: Errant software can accidentally clear

## Pattern 2: Windowed Watchdog
- Clear only allowed within a time window (not too early, not too late)
- **Advantage**: Detects runaway code that hits the clear point by chance

## Pattern 3: Challenge-Response Watchdog
- Software must compute a response to a random challenge
- **Advantage**: High diagnostic coverage; **Disadvantage**: CPU overhead

## This Project: Independent Watchdog (IWDG)
- Separate 32 kHz RC oscillator (10% accuracy)
- Write-once enable register (locked after boot)
- 500 ms timeout → 100 ms reset pulse
- Safe state on reset: all outputs de-energized
