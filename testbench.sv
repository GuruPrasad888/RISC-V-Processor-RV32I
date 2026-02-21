// Simple Testbench for RV32I Single-Cycle Processor
`timescale 1ns/1ps

module rv32i_testbench;
    logic clk;
    logic reset;
    
    // Instantiate the processor
    rv32i_single_cycle processor(
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        #20 reset = 0;
        
        // Run for 200ns (10 clock cycles)
        #200 $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t PC=%h Instr=%h ALU_Result=%h Zero=%b", 
                 $time, processor.pc, processor.instr, 
                 processor.alu_result, processor.zero);
    end

endmodule
