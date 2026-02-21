module datapath (
    input  logic clk,
    input  logic reset,
    input  logic [31:0] instr,
    input  logic [31:0] pc,
    input  logic RegWrite,
    input  logic MemRead,
    input  logic MemWrite,
    input  logic MemToReg,
    input  logic ALUSrc,
    input  logic [1:0] ALUOp,
    input  logic lui,
    input  logic auipc,
    output logic [31:0] alu_result,
    output logic zero,
    output logic [31:0] mem_data,
    output logic [31:0] reg_data1
);

    // Internal signals
    logic [31:0] reg_data2;
    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;
    logic [31:0] alu_in2;
    logic [3:0] alu_ctrl;
    logic [31:0] imm;
    logic [31:0] write_data_mux;

    // Immediate Generator
    imm_gen IG(
        .instr(instr),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b),
        .imm_u(imm_u),
        .imm_j(imm_j)
    );

    // Immediate Selection
    always_comb begin
        case (instr[6:0])
            7'b0010011: imm = imm_i; // I-type ALU
            7'b0000011: imm = imm_i; // load
            7'b0100011: imm = imm_s; // store
            7'b1100011: imm = imm_b; // branch
            7'b1100111: imm = imm_i; // jalr
            7'b0110111: imm = imm_u; // lui
            7'b0010111: imm = imm_u; // auipc
            7'b1101111: imm = imm_j; // jal
            default: imm = 32'b0;
        endcase
    end

    // Register File
    reg_file RF(
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .write_data(write_data_mux),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    // ALU input mux - select between register and immediate
    assign alu_in2 = ALUSrc ? imm : reg_data2;

    // ALU Control
    alu_control ALUC(
        .ALUOp(ALUOp),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .lui(lui),
        .auipc(auipc),
        .alu_ctrl(alu_ctrl)
    );

    // ALU
    alu ALU(
        .a(reg_data1),
        .b(alu_in2),
        .pc(pc),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    data_memory DM(
        .clk(clk),
        .rst(reset),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .addr(alu_result),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    // Write data mux - select between memory data and ALU result
    assign write_data_mux = MemToReg ? mem_data : alu_result;

endmodule
