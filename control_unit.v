`timescale 1ns / 1ps
module control_unit1(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg [3:0] alu_control,
    output reg       reg_write_enable
);

    always @(*) begin
        // defaults
        alu_control      = 4'b0000;
        reg_write_enable = 0;

        case (opcode)
            // ----------------- R-type -----------------
            7'b0110011: begin
                reg_write_enable = 1;
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD
                    end
                    3'b111: alu_control = 4'b0010; // AND
                    3'b110: alu_control = 4'b0011; // OR
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b010: alu_control = 4'b0101; // SLT
                    default: alu_control = 4'b0000;
                endcase
            end

            // ----------------- I-type (ADDI, ANDI, ORI, XORI, SLTI) -----------------
            7'b0010011: begin
                reg_write_enable = 1;
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b111: alu_control = 4'b0010; // ANDI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b010: alu_control = 4'b0101; // SLTI
                    default: alu_control = 4'b0000; // default ADDI
                endcase
            end

            default: begin
                alu_control      = 4'b0000;
                reg_write_enable = 0;
            end
        endcase
    end

endmodule
