module rv32i_single_cycle (
    input  logic clk,
    input  logic reset
);

    // PC and instruction
    logic [31:0] pc;
    logic [31:0] instr;
    
    // Control signals
    logic RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, Jump;
    logic [1:0] ALUOp;
    logic lui, auipc, jalr;
    
    // Datapath signals
    logic [31:0] alu_result;
    logic zero;
    logic [31:0] mem_data;
    logic [31:0] reg_data1;
    
    // Branch/Jump signals
    logic branch_taken;
    logic [31:0] branch_addr, jump_addr;

    // Instruction Fetch Unit
    instruction_fetch IFU(
        .clk(clk),
        .reset(reset),
        .branch_addr(branch_addr),
        .jump_addr(jump_addr),
        .branch_taken(branch_taken),
        .jump(Jump),
        .pc(pc)
    );

    // Instruction Memory
    instruction_memory IM(
        .pc(pc),
        .instruction_code(instr)
    );

    // Control Unit
    control_unit CU(
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp),
        .lui(lui),
        .auipc(auipc),
        .jalr(jalr)
    );

    // Datapath
    datapath DP(
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .pc(pc),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .lui(lui),
        .auipc(auipc),
        .alu_result(alu_result),
        .zero(zero),
        .mem_data(mem_data),
        .reg_data1(reg_data1)
    );

    // Extract immediates for branch/jump calculation
    logic [31:0] imm_i_calc, imm_b_calc, imm_j_calc;
    
    imm_gen IMM_CALC(
        .instr(instr),
        .imm_i(imm_i_calc),
        .imm_s(),
        .imm_b(imm_b_calc),
        .imm_u(),
        .imm_j(imm_j_calc)
    );

    // Branch logic - determine if branch should be taken
    always_comb begin
        if (Branch) begin
            case (instr[14:12])
                3'b000: branch_taken = zero;            // beq (rs1 == rs2)
                3'b001: branch_taken = !zero;           // bne (rs1 != rs2)
                3'b100: branch_taken = alu_result[31];  // blt (rs1 < rs2 signed)
                3'b101: branch_taken = !alu_result[31]; // bge (rs1 >= rs2 signed)
                3'b110: branch_taken = alu_result[31];  // bltu (rs1 < rs2 unsigned)
                3'b111: branch_taken = !alu_result[31]; // bgeu (rs1 >= rs2 unsigned)
                default: branch_taken = 1'b0;
            endcase
        end else begin
            branch_taken = 1'b0;
        end
    end

    // Branch and Jump address calculation
    assign branch_addr = pc + imm_b_calc;
    assign jump_addr = Jump ? (jalr ? (reg_data1 + imm_i_calc) : (pc + imm_j_calc)) : 32'b0;

endmodule
