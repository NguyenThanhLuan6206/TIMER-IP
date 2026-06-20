# 64-bit Timer IP with APB Interface ⏱️

![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen)
![Language](https://img.shields.io/badge/Language-Verilog%20%7C%20SystemVerilog-blue)
![Simulation](https://img.shields.io/badge/Simulator-QuestaSim-orange)

## 📌 Overview
This repository contains the complete RTL design and Verification Environment for a custom 64-bit Count-Up Timer IP. Derived from industrial interrupt controller architectures, this module interfaces with the system via a 32-bit Advanced Peripheral Bus (APB) and provides precise hardware timing, programmable clock division, and threshold-based interrupts.

This project was developed to demonstrate full-cycle IP development, from microarchitecture specification to achieving 100% functional and code coverage.

## ✨ Key Features
* **Core Engine:** 64-bit count-up timer split across two 32-bit registers (TDR0/TDR1) for 32-bit bus compatibility.
* **Bus Interface:** APB Slave interface with 1-cycle wait states (`pready`) and error handling (`pslverr` for invalid/unaligned accesses).
* **Clock Scaling:** Programmable 8-bit internal frequency divider (up to 256x division).
* **Interrupt Generation:** Hardware interrupt (`tim_int`) triggered on 64-bit threshold matches (TCMP0/1), complete with mask (TIER) and clear (TISR) management.
* **Debug Support:** Hardware halt mode to freeze the timer engine during system debugging.
* **Byte Access:** Full support for partial register updates using APB write strobes (`pstrb`).

## 📂 Repository Structure
```text
├── rtl/                             # Verilog source code for the Timer IP and APB Interface
├── tb/                              # SystemVerilog testbench, interfaces, and test sequences
├── sim/                             # Simulation scripts (Makefiles, run scripts)
├── testcases/                       # Testcase design based on Vplan
├──Timer_Design_Specification.docx   # Full specification of Timer_IP
├──Timer_Vplan.xlsx                  # Full Verification specification of Timer_IP
└── README.md
