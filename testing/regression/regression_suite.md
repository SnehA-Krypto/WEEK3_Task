# Regression Suite Configuration

## Nightly Build
```yaml
# nightly_build_config.yml
schedule: "0 2 * * *"  # 2 AM daily

stages:
  - lint
  - unit_sim
  - formal
  - synthesis
  - coverage_report

lint:
  tool: verilator
  args: "--lint-only -Wall"
  fail_on_warning: true

unit_sim:
  tool: vcs
  tests:
    - ecc_uvm_test
    - watchdog_test
    - lockstep_fault_inject_test
    - voter_test
    - bist_test
  timeout: 3600s

formal:
  tool: sby
  properties:
    - axi_protocol_assertions
    - deadlock_freedom
    - secure_boot_fsm
  timeout: 7200s

synthesis:
  tool: yosys
  target: safety_subsystem_top
  check:
    - max_freq: 100MHz
    - area: &lt;500 LUTs

coverage:
  targets:
    line: 100%
    branch: 100%
    fsm: 100%
    toggle: 95%
