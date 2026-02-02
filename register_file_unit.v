`timescale 1ns / 1ps
module register_file_unit1(
     input clk,                   // clock
    input rst,                   // reset
    input [4:0] rs1,             // source register 1 address
    input [4:0] rs2,             // source register 2 address
    input [4:0] rd,              // destination register address
    input [31:0] write_data,     // data to write into rd
    input reg_write_enable,      // control signal to allow write

    output [31:0] data_rs1,      // output data from rs1
    output [31:0] data_rs2       // output data from rs2
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];
    integer i;

    // Initialize registers at reset with predefined values
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= i;  
                // Example: x0=0, x1=1, x2=2, … x31=31
                
            end
        end else begin
            // Write operation ALU gives the output
            if (reg_write_enable && (rd != 0)) begin
                registers[rd] <= write_data;  // ALU result updates rd
            end
        end
    end

    // Read operation 
    assign data_rs1 = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign data_rs2 = (rs2 == 0) ? 32'b0 : registers[rs2];

endmodule
