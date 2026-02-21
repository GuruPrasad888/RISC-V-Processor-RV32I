module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic MemToReg,
    output logic ALUSrc,
    output logic Branch,
    output logic Jump,
    output logic [1:0] ALUOp,
    output logic lui,
    output logic auipc,
    output logic jalr
);

    always_comb begin
        // Default
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        MemToReg = 0;
        ALUSrc   = 0;
        Branch   = 0;
        Jump     = 0;
        ALUOp    = 2'b00;
        lui      = 0;
        auipc    = 0;
        jalr     = 0;

        case (opcode)

            7'b0110011: begin // R-type
                RegWrite = 1;
                ALUOp    = 2'b10;
            end

            7'b0010011: begin // I-type ALU
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b10;
            end

            7'b0000011: begin // LW
                RegWrite = 1;
                MemRead  = 1;
                MemToReg = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

            7'b0100011: begin // SW
                MemWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

            7'b1100011: begin // Branch
                Branch = 1;
                ALUOp  = 2'b01;
            end

            7'b1101111: begin // JAL
                RegWrite = 1;
                Jump     = 1;
            end

            7'b1100111: begin // JALR
                RegWrite = 1;
                ALUSrc   = 1;
                Jump     = 1;
                jalr     = 1;
            end

            7'b0110111: begin // LUI
                RegWrite = 1;
                ALUSrc   = 1;
                lui      = 1;
            end

            7'b0010111: begin // AUIPC
                RegWrite = 1;
                ALUSrc   = 1;
                auipc    = 1;
            end
        endcase
    end

endmodule