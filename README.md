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

Both the structural and behavioral versions can be simulated with **Icarus Verilog (`iverilog`) / Quartz/QuestaSim**:

```bash
#follwing commands will generate file that can be run in terminal 
# Structural ALU
iverilog alu8bitS.v Alutest.v -o alu_struct

# Behavioral ALU
iverilog alu8bitB.v Alutest.v -o alu_behav
```

Running the TestBench
```bash
#Also similar for alu_behav(vvp alu_behav). By running it will show output results and will generate a waveform VCD file which can be viewed with gtk wave
vvp alu_struct
```
Waveform viewer
```bash
gtkwave voter_tb.vcd

# RTL Diagram 
yosys -p "read_verilog alu8bitS.v; hierarchy -check; proc; opt; show -format svg -prefix rtl"

# Gate-level Synthesis
yosys -p "read_verilog alu8bitS.v; synth; show -format svg -prefix synth"
# The RTL and Synth will generate a svg file format can be opened with image viewer
```


