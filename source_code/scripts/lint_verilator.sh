#!/bin/bash
set -e

RTL_DIRS="source_code/rtl/ecc source_code/rtl/watchdog source_code/rtl/lockstep source_code/rtl/voter source_code/rtl/bist source_code/rtl/common source_code/rtl/top"

for dir in $RTL_DIRS; do
    for file in $dir/*.sv; do
        echo "Linting: $file"
        verilator --lint-only -Wall -Wpedantic -Wstyle -Wwarn-lint -Wwarn-style $file
    done
done

echo "Lint complete."
