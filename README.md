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

### RTL Visualization

QuestaSim provides the ability to inspect the **Register Transfer Level (RTL)** representation of the design.

1. After compiling the project, open the **design hierarchy viewer**.
2. Select the ALU module from the hierarchy.
3. Use the **RTL schematic viewer** to display the structural representation of the design.
4. The viewer shows how different components such as logic blocks and interconnections form the ALU architecture.

This graphical representation helps in understanding the internal structure of the design and verifying the connectivity between modules.

### Synthesis Visualization

A synthesized representation of the ALU can also be inspected graphically.

1. Load the synthesized version of the design in the project environment.
2. Open the **synthesis or netlist viewer**.
3. The tool displays the **gate-level implementation** generated from the RTL design.
4. This schematic shows the logic gates and connections used to implement the ALU operations.

Viewing the synthesized schematic helps analyze the final hardware structure produced from the Verilog design.

---


