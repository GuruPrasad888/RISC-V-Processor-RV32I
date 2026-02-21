module instruction_fetch (
    input  logic clk,
    input  logic reset,
    input  logic [31:0] branch_addr,
    input  logic [31:0] jump_addr,
    input  logic branch_taken,
    input  logic jump,
    output logic [31:0] pc
);

    logic [31:0] pc_next;
    
    // Sequential PC update
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end
    
    // Combinational PC next logic
    always_comb begin
        if (jump)
            pc_next = jump_addr;
        else if (branch_taken)
            pc_next = branch_addr;
        else
            pc_next = pc + 32'd4;
    end

endmodule
