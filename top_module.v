`timescale 1ns / 1ps
module top_module(
    input clk,
    input rst,
    output [31:0] pc_out,
    output [31:0] ins_out,
    output [31:0] alu_result_out
);

    // ----------------- Internal Wires -----------------
    wire [31:0] pc;
    wire [31:0] ins_code;
    wire [31:0] data_rs1, data_rs2;
    wire [3:0]  alu_control;
    wire        reg_write_enable;
    wire [31:0] alu_out;
    wire        zero_flag;

    // ----------------- Pipeline Registers -----------------
    reg  [63:0] pipeline_IF_ID;   // { pc[31:0], ins_code[31:0] }
    reg  [73:0] pipeline_ID_EX;   // { op1, op2, rd, alu_ctrl, reg_we }
    reg [37:0] pipeline_EX_MEM;  // { alu_out, rd, reg_we }
    reg  [37:0] pipeline_MEM_WB;  // { wb_data, rd, reg_we }

    // ----------------- IF/ID Unpack -----------------
    wire [31:0] IF_ID_pc   = pipeline_IF_ID[63:32];
    wire [31:0] IF_ID_ins  = pipeline_IF_ID[31:0];

    // ----------------- Instruction Decode -----------------
    wire [6:0]  opcode = IF_ID_ins[6:0];
    wire [4:0]  rd     = IF_ID_ins[11:7];
    wire [2:0]  funct3 = IF_ID_ins[14:12];
    wire [4:0]  rs1    = IF_ID_ins[19:15];
    wire [4:0]  rs2    = IF_ID_ins[24:20];
    wire [6:0]  funct7 = IF_ID_ins[31:25];

    // Immediate for I-type
    wire [31:0] imm_i = {{20{IF_ID_ins[31]}}, IF_ID_ins[31:20]};

    // ----------------- ID/EX Unpack -----------------
    wire [31:0] ID_EX_op1  = pipeline_ID_EX[73:42];
    wire [31:0] ID_EX_op2  = pipeline_ID_EX[41:10];
    wire [4:0]  ID_EX_rd   = pipeline_ID_EX[9:5];
    wire [3:0]  ID_EX_ctrl = pipeline_ID_EX[4:1];
    wire        ID_EX_we   = pipeline_ID_EX[0];

    // ----------------- EX/MEM Unpack -----------------
    wire [31:0] EX_MEM_alu_out = pipeline_EX_MEM[37:6];
    wire [4:0]  EX_MEM_rd      = pipeline_EX_MEM[5:1];
    wire        EX_MEM_we      = pipeline_EX_MEM[0];

    // ----------------- MEM/WB Unpack -----------------
    wire [31:0] MEM_WB_wb_data = pipeline_MEM_WB[37:6];
    wire [4:0]  MEM_WB_rd      = pipeline_MEM_WB[5:1];
    wire        MEM_WB_we      = pipeline_MEM_WB[0];

    // ----------------- IFU -----------------
    instruction_fetch_unit ifu(
        clk,
        rst,
        pc
    );

    // ----------------- IMU -----------------
    instruction_memory_unit1 imu(
        pc,
        ins_code
    );

    // ----------------- RFU -----------------
    register_file_unit1 rfu(
        clk,
        rst,
        rs1,
        rs2,
        MEM_WB_rd,
        MEM_WB_wb_data,
        MEM_WB_we,
        data_rs1,
        data_rs2
    );

    // ----------------- CU -----------------
    control_unit1 cu( 
        opcode,
        funct3,
        funct7,
        alu_control,
        reg_write_enable
    );

    // ----------------- ALU -----------------
    arithmetic_logic_unit1 alu (
        ID_EX_op1,
        ID_EX_op2,
        ID_EX_ctrl,
        alu_out,
        zero_flag
    );

    // ----------------- Main Pipeline -----------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_IF_ID  <= 64'd0;
            pipeline_ID_EX  <= 74'd0;
            pipeline_EX_MEM <= 38'd0;
            pipeline_MEM_WB <= 38'd0;
        end else begin
            // IF ? ID
            pipeline_IF_ID <= { pc, ins_code };

            // ID ? EX
            pipeline_ID_EX <= { data_rs1,
                                (opcode == 7'b0010011) ? imm_i : data_rs2,
                                rd,
                                alu_control,
                                reg_write_enable };

            // EX ? MEM
            pipeline_EX_MEM <= { alu_out, ID_EX_rd, ID_EX_we };

            // MEM ? WB
            pipeline_MEM_WB <= { EX_MEM_alu_out, EX_MEM_rd, EX_MEM_we };
        end
    end

    // ----------------- Outputs -----------------
    assign pc_out         = pc;
    assign ins_out        = ins_code;
    assign alu_result_out = alu_out;

endmodule