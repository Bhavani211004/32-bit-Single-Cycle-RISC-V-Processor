# 32-bit Single-Cycle RISC-V Processor (RV32I Subset)

## Overview

This project implements a **32-bit Single-Cycle RISC-V Processor** using Verilog HDL. The processor is based on the **RV32I instruction set architecture (ISA)** and supports a subset of commonly used instructions for arithmetic, logical, memory, and branch operations.

The processor follows the **Harvard Architecture**, where instruction memory and data memory are implemented separately. Every instruction is executed completely within a **single clock cycle**, making the design simple and suitable for learning processor architecture and digital design concepts.

---

## Features

- 32-bit RISC-V Processor
- Single-Cycle Datapath
- Harvard Architecture
- 32 General Purpose Registers
- Separate Instruction and Data Memory
- Modular RTL Design
- Simulation using Vivado
- External Instruction Loading using `program.hex`

---

## Supported Instruction Set

### R-Type Instructions

| Instruction | Description |
|------------|-------------|
| ADD | Addition |
| SUB | Subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |
| SLL | Shift Left Logical |
| SRL | Shift Right Logical |

---

### I-Type Instructions

| Instruction | Description |
|------------|-------------|
| ADDI | Add Immediate |
| LW | Load Word |

---

### S-Type Instructions

| Instruction | Description |
|------------|-------------|
| SW | Store Word |

---

### B-Type Instructions

| Instruction | Description |
|------------|-------------|
| BEQ | Branch if Equal |

---

## Processor Architecture

The processor consists of the following modules:

- Program Counter (PC)
- Next PC Generator
- Instruction Memory
- Instruction Decoder
- Control Unit
- Register File
- Immediate Generator
- ALU Control
- Arithmetic Logic Unit (ALU)
- Data Memory
- Write Back Multiplexer
- Top Module

---

## Datapath Flow
<img width="600" style="height: auto" alt="ChatGPT Image Jul 25, 2026, 08_06_49 PM" src="https://github.com/user-attachments/assets/bf59c080-3288-4961-a32d-b5bbe315f40b" />




---

## Project Structure
```

RISCV/
│
├── src/
│   ├── pc.v
│   ├── next_pc_generator.v
│   ├── instruction_memory.v
│   ├── instruction_decoder.v
│   ├── control_unit.v
│   ├── reg_file.v
│   ├── immediate_generator.v
│   ├── alu_control.v
│   ├── alu.v
│   ├── data_memory.v
│   └── top.v
│
├── sim/
│   ├── top_tb.v
│   └── program.hex
│
└── README.md
```

---

## Simulation results 

<img src="https://github.com/user-attachments/assets/a2244c50-a415-4ac1-9e60-92eea73bb092" width="750" style="height: auto;" alt="Screenshot" />

<img width="400" style="height: auto;" alt="Screenshot 2026-07-25 195019" src="https://github.com/user-attachments/assets/b94725c7-46e4-456a-8435-5cba163a0af1" />

---

## Sample Program

```assembly
addi x1, x0, 20
addi x2, x0, 5

add  x3, x1, x2
sub  x4, x1, x2
and  x5, x1, x2
or   x6, x1, x2
xor  x7, x1, x2
sll  x8, x2, x2
srl  x9, x2, x2

sw   x3, 0(x0)
lw   x10, 0(x0)

beq  x10, x3, label

addi x11, x0, 99

label:
addi x12, x0, 55
```

---

## Expected Output

| Register | Value |
|----------|------:|
| x0 | 0 |
| x1 | 20 |
| x2 | 5 |
| x3 | 25 |
| x4 | 15 |
| x5 | 4 |
| x6 | 21 |
| x7 | 17 |
| x8 | 160 |
| x9 | 0 |
| x10 | 25 |
| x11 | 0 |
| x12 | 55 |

Memory:

```
Memory[0] = 25
```

---

## Design Highlights

- Modular Verilog implementation
- Synthesizable RTL
- Harvard Architecture
- External instruction loading using `program.hex`
- Supports arithmetic, logical, memory, and branch operations
- Easily extendable to a pipelined processor

---




## Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator

---

## Author

**Lakshmi Bhavani Katta**

Dual Degree (B.Tech + M.Tech)  
Electronics and Communication Engineering (ECE)  


---

## License

This project is intended for educational and academic purposes.
