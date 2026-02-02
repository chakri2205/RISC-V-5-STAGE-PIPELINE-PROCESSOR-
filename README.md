# RISC-V 5-Stage Pipelined Processor

This repository contains a Verilog HDL implementation of a **5-stage pipelined RISC-V processor** based on the **RV32I instruction set architecture**.  
The design follows the classic RISC-V pipeline stages and is implemented using modular RTL blocks.

---

## 📌 Overview

The processor implements the following five pipeline stages:

1. **Instruction Fetch (IF)**  
2. **Instruction Decode (ID)**  
3. **Execute (EX)**  
4. **Memory Access (MEM)**  
5. **Write Back (WB)**  

Pipeline registers are inserted between stages to enable parallel instruction execution and improve throughput.

---

## 🧠 Architecture Details

- **ISA**: RISC-V RV32I  
- **Data Width**: 32-bit  
- **Pipeline Depth**: 5 stages  
- **Design Style**: Synchronous RTL  
- **HDL Used**: Verilog  

A synthesized schematic of the complete processor datapath and pipeline registers is provided for reference.

---

## 📁 Project Structure

riscv-5stage-pipeline/
│
├── rtl/
│ ├── top_module.v
│ ├── instruction_fetch_unit.v
│ ├── instruction_memory_unit.v
│ ├── register_file_unit.v
│ ├── control_unit.v
│ └── arithmetic_logic_unit.v
│
├── docs/
│ └── schematic.pdf
│
└── README.md


---

## 🧩 Module Description

### 🔹 Top Module
- Integrates all pipeline stages and pipeline registers
- Handles global clock and reset
- Connects datapath and control signals across stages

### 🔹 Instruction Fetch Unit (IF)
- Maintains the Program Counter (PC)
- Fetches instructions from instruction memory
- Outputs instruction and PC to IF/ID pipeline register

### 🔹 Instruction Memory Unit
- Stores program instructions
- Provides 32-bit instruction output based on PC

### 🔹 Register File Unit
- Implements 32 general-purpose 32-bit registers
- Supports two read ports and one write port
- Write-back controlled during WB stage

### 🔹 Control Unit
- Decodes RISC-V instructions
- Generates control signals for datapath operations
- Controls register write, ALU operation, and memory access

### 🔹 Arithmetic Logic Unit (ALU)
- Performs arithmetic and logical operations
- Supports operations required by RV32I instructions
- Outputs 32-bit result to EX/MEM pipeline register

---

## 🧪 Verification & Simulation

- Individual RTL modules are designed for modular verification  
- Pipeline behavior can be verified using waveform analysis  
- End-to-end instruction flow validated through simulation  

---

## 📘 Documentation

- **Schematic Diagram**:  
  The synthesized schematic illustrates pipeline registers, datapath flow, and inter-module connectivity  
  (see `docs/schematic.pdf`) :contentReference[oaicite:0]{index=0}

---

## 🎓 Project Context

This project is developed as part of a **BTech final year project** to demonstrate:

- Understanding of RISC-V ISA  
- Pipelined processor architecture  
- RTL design using Verilog  
- Modular and scalable processor design  

---

## 🚀 Future Scope

- Full RV32I instruction coverage  
- Data and control hazard handling  
- Forwarding and stall mechanisms  
- Memory hierarchy integration  
