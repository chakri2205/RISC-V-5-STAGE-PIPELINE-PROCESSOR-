`timescale 1ns / 1ps

module instruction_memory_unit1(
    input  [31:0] pc,
    output [31:0] ins_code
);

    // Instruction memory: 40 bytes = 10 instructions (32-bit each)
    reg [7:0] memory [0:39];

    // Initialize memory once at simulation start
    initial begin
    

// --------------------- Instruction Memory ---------------------
memory[0]  = 8'h93;  // addi x1, x0, 5 ? 0x00500093
memory[1]  = 8'h00;
memory[2]  = 8'h50;
memory[3]  = 8'h00;

memory[4]  = 8'h13;  // ori x2, x12, 7 ? 0x00766113
memory[5]  = 8'h61;
memory[6]  = 8'h76;
memory[7]  = 8'h00;

memory[8]  = 8'h93;  // addi x3, x10, 10 ? 0x00A50193
memory[9]  = 8'h01;
memory[10] = 8'hA5;
memory[11] = 8'h00;

memory[12] = 8'h13;  // andi x4, x13, 12 ? 0x00C6F213
memory[13] = 8'hF2;
memory[14] = 8'hC6;
memory[15] = 8'h00;

memory[16] = 8'h93;  // xori x5, x0, 15 ? 0x00F00293
memory[17] = 8'h02;
memory[18] = 8'hF0;
memory[19] = 8'h00;

memory[20] = 8'h33;  // slt x6, x1, x10 ? 0x00A0A333
memory[21] = 8'hA3;
memory[22] = 8'hA0;
memory[23] = 8'h00;

memory[24] = 8'hB3;  // add x7, x2, x14 ? 0x00E103B3
memory[25] = 8'h03;
memory[26] = 8'hE1;
memory[27] = 8'h00;

memory[28] = 8'hB3;  // sub x8, x4, x1 ? 0x401203B3
memory[29] = 8'h03;
memory[30] = 8'h12;
memory[31] = 8'h40;

memory[32] = 8'hB3;  // or x9, x2, x5 ? 0x005164B3
memory[33] = 8'h64;
memory[34] = 8'h51;
memory[35] = 8'h00;

memory[36] = 8'h33;  // xor x10, x3, x4 ? 0x0041C533
memory[37] = 8'hC5;
memory[38] = 8'h41;
memory[39] = 8'h00;

    end

    // Fetch 32-bit instruction (little-endian)
    assign ins_code = { memory[pc+3], memory[pc+2], memory[pc+1], memory[pc] };

endmodule
