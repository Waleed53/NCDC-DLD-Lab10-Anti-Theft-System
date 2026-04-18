# NCDC DLD Module — Lab 10: Anti-Theft System

## Course
**NCDC Cohort 02/2025 — Design Verification (DV)**
NUST Chip Design Centre (NCDC), NUST

## Module
**Digital Logic Design (DLD) Module** — Lab 10

---

## Overview

This lab implements a complete **Anti-Theft System** for a vehicle in **SystemVerilog**, modelled as a hierarchical Finite State Machine (FSM). The design integrates multiple sub-modules — a clock divider, a debounce filter, a timer, and a fuel pump control unit — all coordinated by a top-level anti-theft FSM that responds to sensor inputs and enforces security logic.

---

## System Architecture

```
Anti-Theft System (Top Level)
├── antiTheftFSM.sv       ← Main FSM: controls alarm, ignition, and fuel pump states
├── fuelPumpLogic.sv      ← Controls fuel pump enable/disable based on FSM state
├── timer.sv              ← Countdown timer for alarm and timeout logic
├── timeParameters.sv     ← Parameterised time constants for the timer
├── clkDiv.sv             ← Clock divider: scales system clock for human-timescale events
└── debounce.sv           ← Debounce filter: eliminates mechanical switch bounce
```

---

## Module Descriptions

### antiTheftFSM.sv
The central FSM with states including IDLE, ARMED, TRIGGERED, ALARM, and DISARMED. Transitions are triggered by input signals such as motion detection, door sensor, and PIN entry. Outputs control the alarm siren, fuel pump, and indicator LEDs.

### fuelPumpLogic.sv
Combinational logic that disables the vehicle's fuel pump when the system is in an alarmed or lockout state, preventing the engine from starting even if the ignition is turned on.

### timer.sv / timeParameters.sv
A parameterised countdown timer used for alarm duration, re-arm delay, and lockout timeouts. `timeParameters.sv` centralises all timing constants, making the design easily reconfigurable.

### clkDiv.sv
Divides the high-frequency system clock (e.g. 50 MHz FPGA clock) down to a 1 Hz or 1 kHz clock suitable for human-observable state transitions and debounce windows.

### debounce.sv
A synchroniser and debounce filter for mechanical input signals (buttons, switches). Uses a shift-register pattern to validate stable signal levels over multiple clock cycles before passing the signal to the FSM.

---

## Repository Structure

```
newLab10/
├── antiTheftFSM.sv                          # Top-level FSM
├── antiTheftFSM TB.sv                       # Testbench for FSM
├── fuelPumpLogic.sv                         # Fuel pump controller
├── fuelPumpTestBench.sv                     # Testbench for fuel pump
├── timer.sv                                 # Timer module
├── timerTB.sv                               # Testbench for timer
├── timeParameters.sv                        # Timing constants package
├── timerParametersTestbench.sv              # Testbench for time parameters
├── clkDiv.sv                                # Clock divider
├── clkDiv testbench.sv                      # Testbench for clock divider
├── debounce.sv                              # Debounce filter
├── debounce testbench.sv                    # Testbench for debounce
├── waveform for testbench of antiTheftFSM.png
├── Waveform for testbench of fuelPumpLogic.png
├── Waveform for testbench of timeParameters.png
├── Waveform for testbench of timer.png
├── Waveform for testbench of toplevel module.png
├── waveform of testbench clkDiv.png
└── waveform of testbench debounce.png
NCDC_lab10_report.pdf                        # Full lab report with waveforms and analysis
```

---

## Simulation

```bash
# Using QuestaSim / ModelSim
vlog *.sv
vsim -t 1ns "antiTheftFSM TB" -do "run -all"
vsim -t 1ns "fuelPumpTestBench" -do "run -all"
vsim -t 1ns timerTB -do "run -all"
```

---

## Concepts Demonstrated
- Finite State Machine (FSM) design in SystemVerilog (Moore/Mealy)
- Hierarchical RTL design with parameterised sub-modules
- Clock domain management with clock dividers
- Mechanical switch debouncing using shift-register filtering
- Countdown timer design with configurable time constants
- Waveform-based functional verification using testbenches
