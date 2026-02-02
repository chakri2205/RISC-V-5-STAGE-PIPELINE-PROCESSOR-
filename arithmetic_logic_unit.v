`timescale 1ns / 1ps
module arithmetic_logic_unit1(
    input [31:0] operand1,
    input [31:0] operand2,
    input [3:0] alu_control,    // operation select given by cu
    output reg [31:0] alu_result,
    output zero_flag
);

   always @(*) begin
    case (alu_control)
        4'b0000: alu_result = operand1 + operand2;        // ADD / ADDI
        4'b0001: alu_result = operand1 - operand2;        // SUB
        4'b0010: alu_result = operand1 & operand2;        // AND / ANDI
        4'b0011: alu_result = operand1 | operand2;        // OR / ORI
        4'b0100: alu_result = operand1 ^ operand2;        // XOR / XORI
        4'b0101: alu_result = (operand1 < operand2) ? 1 : 0; // SLT / SLTI
        default: alu_result = 32'b0;
    endcase
end

    // Zero flag for branches
    assign zero_flag = (alu_result == 0);

endmodule

