# 8-bit ALU Design in Verilog HDL

## Overview
This project presents the design and implementation of an **8-bit Arithmetic Logic Unit (ALU)** using **Verilog HDL**.  
The ALU is a fundamental component in digital processors and is responsible for performing arithmetic and logical operations on binary data.

The ALU in this project is implemented using two modeling techniques:

- **Structural Modeling** – The ALU is constructed by interconnecting lower-level hardware modules such as logic gates, adders, and multiplexers.
- **Behavioral Modeling** – The ALU functionality is described using high-level behavioral constructs in Verilog.

The design is verified using a **testbench**, and further analyzed through **RTL visualization, synthesis, and timing/power analysis**.

---

## Usage

### Compile and Run Simulation (Icarus Verilog)

Both the structural and behavioral versions can be simulated with **Icarus Verilog (`iverilog`)**:

```bash
# Structural ALU
iverilog alu8bitS.v Alutest.v -o alu_struct
vvp alu_struct

# Behavioral ALU
iverilog alu8bitB.v Alutest.v -o alu_behav
vvp alu_behav
