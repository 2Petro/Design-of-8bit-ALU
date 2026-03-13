# 8-bit ALU Design in Verilog HDL

## Overview
This project presents the design and implementation of an **8-bit Arithmetic Logic Unit (ALU)** using **Verilog HDL**.  
The ALU is a fundamental component in digital processors and is responsible for performing arithmetic and logical operations on binary data.

The ALU in this project is implemented using two modeling techniques:

- **Structural Modeling** – The ALU is constructed by interconnecting lower-level hardware modules such as logic gates, adders, and multiplexers.
- **Behavioral Modeling** – The ALU functionality is described using high-level behavioral constructs in Verilog.
  
- The 8-bit ALU consists of **five main blocks**:

1. **8-bit Arithmetic Unit** – Performs arithmetic operations and acts as a signed comparator.  
2. **8-bit Logic Unit** – Executes logical operations such as AND, OR, XOR, and NOT.  
3. **8-bit Shifter Unit** – Performs shift operations (logical/arithmetic left/right shifts).  
4. **8-bit Register** – Stores intermediate results and operands.  
5. **Two 8-bit 2-to-1 Multiplexers** – Select between different inputs for the ALU operations.

The design is verified using a **testbench**, and further analyzed through **RTL visualization, synthesis, and timing/power analysis**.

---
## Operations 

| S0 | S1 | S2 | S3 | F | Description |
|:---:|:---:|:---:|:---:|:---:|:---|
| 0 | 0 | 0 | 0 | A+B | Add |
| 0 | 0 | 0 | 1 | A-B | Subtract |
| 0 | 0 | 1 | 1 | B'+1 | 2's complement |
| 1 | 0 | 0 | 0 | A and B | And |
| 1 | 0 | 1 | 0 | A xor B | Xor |
| 1 | 0 | 0 | 1 | A or B | Or |
| 1 | 0 | 1 | 1 | B' | 1's complement |
| 1 | 1 | 0 | 0 | A>> | Right rotate |
| 1 | 1 | 1 | 0 | <<A | Left rotate |
| 1 | 1 | 0 | 1 | A> | Right shift |
| 1 | 1 | 1 | 1 | <B | Left shift |

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
## Simulation, RTL Visualization, and Synthesis using QuestaSim

The project can also be verified and analyzed using **QuestaSim** through its graphical interface.

### Simulation Workflow

1. **Create a new project** in the simulator environment.
2. **Add the Verilog source files** to the project:
   - `alu8bitS.v` (Structural implementation)
   - `alu8bitB.v` (Behavioral implementation)
   - `Alutest.v` (Testbench)
3. **Compile the design files** within the project.
4. **Start simulation** using the testbench module (`Alutest`).
5. Open the **Waveform Viewer**.
6. **Add signals** such as operands, control signals, and ALU outputs to the waveform window.
7. Run the simulation to observe signal transitions and verify correct ALU functionality.

The waveform viewer allows interactive inspection of signal behavior during simulation.

### RTL

QuestaSim provides the ability to inspect the **Register Transfer Level (RTL)** representation of the design.

1. After compiling the project, open the **design hierarchy viewer**.
2. Select the ALU module from the hierarchy.
3. Use the **RTL schematic viewer** to display the structural representation of the design.
4. The viewer shows how different components such as logic blocks and interconnections form the ALU architecture.

This graphical representation helps in understanding the internal structure of the design and verifying the connectivity between modules.

### Synthesis

A synthesized representation of the ALU can also be inspected graphically.

1. Load the synthesized version of the design in the project environment.
2. Open the **synthesis or netlist viewer**.
3. The tool displays the **gate-level implementation** generated from the RTL design.
4. This schematic shows the logic gates and connections used to implement the ALU operations.

Viewing the synthesized schematic helps analyze the final hardware structure produced from the Verilog design.

---

## Results

### Testbench

The functionality of the 8-bit ALU is verified using a dedicated **Verilog testbench**.  
Different input vectors are applied to the operands and control signals in order to exercise the supported ALU operations. The expected results are compared with the simulation outputs to verify the correctness of the design.

The waveform viewer is used to observe signal transitions and confirm that the ALU produces the correct results for each operation.

![Testbench Waveform](Testbench/img1.png)

### RTL

![RTL Diagram](RTL/img1.png)
![RTL Diagram](RTL/img2.png)

### Synthesis

![Synthesis Result](synth/img1.png)
![Synthesis Result](synth/img2.png)

### Power & Timing Analysis

Power and timing analysis are performed using **Quartus** after the design is synthesized.

The general workflow includes:

1. Creating a project in Quartus and adding the Verilog source files.
2. Compiling the design to generate the synthesized netlist.
3. Running the **Timing Analyzer** to evaluate the propagation delays and critical paths within the ALU.
4. Performing **Power Analysis** to estimate the power consumption based on switching activity and resource utilization.
5. Reviewing the generated reports and graphical summaries to evaluate performance and efficiency of the design.

These analyses provide insight into how the ALU behaves in terms of **timing performance and power consumption** when implemented on hardware.

![Timing Analysis](analysis/img1.png)
![Power Analysis](analysis/img2.png)


---
## Tools Used

- **Icarus Verilog (iverilog)** – Open-source Verilog compiler used to compile and simulate the ALU design with the testbench.  
- **GTKWave** – Waveform viewer used to visualize simulation output signals from generated VCD files.  
- **Yosys** – Open-source synthesis framework used to generate RTL schematics and synthesized gate-level representations of the design.  
- **Quartus & QuestaSim** – FPGA and HDL simulation environments used for graphical compilation, RTL/synthesis inspection, power/timing analysis, and waveform viewing.
---

## Report

A detailed report describing the **architecture, design methodology, RTL implementation, synthesis results, and verification of the 8-bit ALU** is available below:

[📄 Digital 8-bit ALU Design Report](report/Digital-alu8bit-design.pdf)

---
