module alu_control (
    input  logic [1:0] ALUOp,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic lui,
    input  logic auipc,
    output logic [3:0] alu_ctrl
);

    always_comb begin
        if (lui) begin
            alu_ctrl = 4'b1010; // pass b
        end else if (auipc) begin
            alu_ctrl = 4'b1011; // pc + b
        end else begin
            case (ALUOp)

                2'b00: alu_ctrl = 4'b0000; // ADD (load/store)

                2'b01: begin // Branch - always subtract
                    alu_ctrl = 4'b0001; // SUB for all branch types
                end

                2'b10: begin
                    case ({funct7[5], funct3})
                        4'b0000: alu_ctrl = 4'b0000; // ADD
                        4'b1000: alu_ctrl = 4'b0001; // SUB
                        4'b0001: alu_ctrl = 4'b0111; // SLL
                        4'b0010: alu_ctrl = 4'b0101; // SLT
                        4'b0011: alu_ctrl = 4'b0110; // SLTU
                        4'b0100: alu_ctrl = 4'b0100; // XOR
                        4'b0101: alu_ctrl = 4'b1000; // SRL
                        4'b1101: alu_ctrl = 4'b1001; // SRA
                        4'b0110: alu_ctrl = 4'b0010; // OR
                        4'b0111: alu_ctrl = 4'b0011; // AND
                        default: alu_ctrl = 4'b0000;
                    endcase
                end

                default: alu_ctrl = 4'b0000;
            endcase
        end
    end

endmodule