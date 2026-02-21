# RV32I Single-Cycle RISC-V Processor

A complete SystemVerilog implementation of a single-cycle RV32I processor, featuring a classic 5-stage pipeline architecture (collapsed into single cycle) with support for 40+ RV32I instructions.

---

## Overview

This project implements a **single-cycle RV32I RISC-V processor** - a fully functional CPU that executes one instruction per clock cycle. The design follows standard computer architecture principles with clear separation between:

- **Instruction Fetch (IF)** - Program Counter management
- **Control Unit (CU)** - Instruction decoding
- **Datapath (DP)** - Data processing (ALU, registers, memory)
- **Memory Hierarchy** - Instruction and data memory

**Key Specifications:**
- **ISA:** RV32I (RISC-V 32-bit Integer base)
- **Word Width:** 32-bit
- **Pipeline:** Single-cycle (all stages combined)
- **Memory:** 
  - Program Memory: 109 bytes (~27 instructions)
  - Data Memory: 256 × 32-bit words (1 KB)
  - Register File: 32 × 32-bit registers

---

## Architecture

### Block Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    RV32I Processor (top.sv)                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐      ┌─────────────────────────────┐  │
│  │ Instruction Fetch│      │   Control Unit              │  │
│  │ (IF Stage)       │      │   - Opcode decoder          │  │
│  │ - PC management  │      │   - Control signals         │  │
│  │ - Branch/Jump    │      │   - ALUOp, RegWrite, etc.   │  │
│  └────────┬─────────┘      └─────────────────────────────┘  │
│           │                            │                     │
│           ↓                            ↓                     │
│  ┌─────────────────────────────────────────────────┐        │
│  │          Instruction Memory (IM)                │        │
│  │  - 109 bytes @ address 0x0-0x6C                │        │
│  │  - Pre-loaded with test instructions           │        │
│  └─────────────────────────────────────────────────┘        │
│           ↓                                                   │
│  ┌─────────────────────────────────────────────────┐        │
│  │            Datapath (DP)                        │        │
│  ├─────────────────────────────────────────────────┤        │
│  │  ┌──────────────┐    ┌──────────────────────┐ │        │
│  │  │ Register File│    │ Immediate Generator │ │        │
│  │  │ (32×32-bit)  │    │ (I,S,B,U,J formats) │ │        │
│  │  └──────┬───────┘    └──────────┬───────────┘ │        │
│  │         │                        │              │        │
│  │  ┌──────▼─────────────────────────▼──────┐     │        │
│  │  │   ALU Control + ALU                    │     │        │
│  │  │   - ADD, SUB, AND, OR, XOR, etc.      │     │        │
│  │  │   - SLL, SRL, SRA, SLT, SLTU          │     │        │
│  │  └──────┬──────────────────────────────────┘    │        │
│  │         │                                        │        │
│  │  ┌──────▼──────────────────────────────────┐   │        │
│  │  │   Data Memory (256×32-bit)              │   │        │
│  │  │   - Synchronous write                   │   │        │
│  │  │   - Combinational read                  │   │        │
│  │  └──────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────┘        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
PC → [Instruction Memory] → Instruction
                                    ↓
                    ┌───────────────┼───────────────┐
                    ↓               ↓               ↓
            [Control Unit]  [Immediate Gen]  [Register File]
                    ↓               ↓               ↓
                    └───────────────┼───────────────┘
                                    ↓
                            [ALU & ALU Control]
                                    ↓
                    ┌───────────────┼───────────────┐
                    ↓               ↓               ↓
            [PC Calculate]  [Data Memory]  [Register Write]
                    ↓               ↓               ↓
              [PC + 4 or        [Load/Store]   [Write Back]
               Branch/Jump]
```

---

## Supported Instructions

### R-Type (Register-Register Operations)
- **Arithmetic:** ADD, SUB
- **Logical:** AND, OR, XOR
- **Shift:** SLL, SRL, SRA
- **Compare:** SLT, SLTU

### I-Type (Immediate Operations & Load)
- **Arithmetic:** ADDI
- **Logical:** ANDI, ORI, XORI
- **Shift:** SLLI, SRLI, SRAI
- **Load/Compare:** LW, SLTI, SLTIU

### S-Type (Store Operations)
- **Store:** SW (Store Word)

### B-Type (Branch Operations)
- **Conditional Branches:** BEQ, BNE, BLT, BGE, BLTU, BGEU

### J-Type (Jump Operations)
- **Unconditional:** JAL (Jump and Link)
- **Indirect:** JALR (Jump and Link Register)

### U-Type (Upper Immediate)
- **Load Upper:** LUI (Load Upper Immediate)
- **PC Relative:** AUIPC (Add Upper Immediate to PC)

---


### 4. Modify Program
Edit `program_memory.sv` to load different instructions:
```systemverilog
initial begin
    // Add: 0x00940333 (rd=6, rs1=8, rs2=9)
    memory[3] = 8'h00;
    memory[2] = 8'h94;
    memory[1] = 8'h03;
    memory[0] = 8'h33;
end
```

---


## References


### Learning Resources
- **YouTube Channel:** [ALL ABOUT VLSI](https://www.youtube.com/@allabotutvlsi)


---



### Control Signal Truth Table
```
Opcode    | Instruction | RegWrite | MemWrite | Branch | Jump
0110011   | R-type      | 1        | 0        | 0      | 0
0010011   | I-ALU       | 1        | 0        | 0      | 0
0000011   | LW          | 1        | 0        | 0      | 0
0100011   | SW          | 0        | 1        | 0      | 0
1100011   | Branch      | 0        | 0        | 1      | 0
1101111   | JAL         | 1        | 0        | 0      | 1
1100111   | JALR        | 1        | 0        | 0      | 1
0110111   | LUI         | 1        | 0        | 0      | 0
0010111   | AUIPC       | 1        | 0        | 0      | 0
```

---
