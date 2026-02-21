module reg_file (
    input  logic        clk,
    input  logic        RegWrite,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    logic [31:0] regs [31:0];

    assign read_data1 = (rs1 != 0) ? regs[rs1] : 32'b0;
    assign read_data2 = (rs2 != 0) ? regs[rs2] : 32'b0;

    always_ff @(posedge clk)
        if (RegWrite && rd != 0)
            regs[rd] <= write_data;

endmodule