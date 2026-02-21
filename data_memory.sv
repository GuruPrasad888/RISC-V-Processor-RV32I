module data_memory (
    input  logic clk,
    input  logic rst,
    input  logic mem_read,
    input  logic mem_write,
    input  logic [31:0] addr,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] memory [0:255];
    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 32'b0;
        end
        else if (mem_write) begin
            memory[addr[9:2]] <= write_data; // word aligned
        end
    end

    assign read_data = mem_read ? memory[addr[9:2]] : 32'b0;

endmodule
