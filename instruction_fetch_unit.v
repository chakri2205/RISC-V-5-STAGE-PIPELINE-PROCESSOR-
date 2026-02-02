`timescale 1ns / 1ps

// IFU
module instruction_fetch_unit (
    input clk,
    input rst,
    output reg [31:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'b0;       // reset PC to 0
        end else begin
                pc <= pc + 4;     // increment normally
            end
        end
endmodule
