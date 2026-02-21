module instruction_memory (
    input  logic [31:0] pc,
    output logic [31:0] instruction_code
);
 
    logic [7:0] memory [0:108];
    
    initial begin
        // Setting 32-bit instruction: add : 0x00940333 
        memory[3] = 8'h00;
        memory[2] = 8'h94;
        memory[1] = 8'h03;
        memory[0] = 8'h33;
        
        // Setting 32-bit instruction: sub : 0x800100b3
        memory[7] = 8'h80;
        memory[6] = 8'h01;
        memory[5] = 8'h00;
        memory[4] = 8'hb3;
        
        // Setting 32-bit instruction: sll : 0x00209133
        memory[11] = 8'h00;
        memory[10] = 8'h20;
        memory[9] = 8'h91;
        memory[8] = 8'h33;
        
        // Setting 32-bit instruction: xor : 0x00c54ab3 
        memory[15] = 8'h00;
        memory[14] = 8'hc5;
        memory[13] = 8'h4A;
        memory[12] = 8'hb3;
        
        // Setting 32-bit instruction: srl : 0x00c55ab3
        memory[19] = 8'h00;
        memory[18] = 8'hc5;
        memory[17] = 8'h5a;
        memory[16] = 8'hb3;
        
        // Setting 32-bit instruction: and : 0x01bd5f33
        memory[23] = 8'h01;
        memory[22] = 8'hbd;
        memory[21] = 8'h5f;
        memory[20] = 8'h33;
        
        // Setting 32-bit instruction: or : 0x00d67fb3
        memory[27] = 8'h00;
        memory[26] = 8'hd6;
        memory[25] = 8'h7f;
        memory[24] = 8'hb3;
        
        // Setting 32-bit instruction: and : 0x00f768b3
        memory[31] = 8'h00;
        memory[30] = 8'hf7;
        memory[29] = 8'h68;
        memory[28] = 8'hb3;
    end

    assign instruction_code = {memory[pc+3], memory[pc+2], memory[pc+1], memory[pc]};

endmodule
