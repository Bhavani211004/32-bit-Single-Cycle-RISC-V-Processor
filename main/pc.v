`timescale 1ns / 1ps

//==============================
// Next PC Generator
//==============================
module next_pc_generator (
    input  [31:0] pc,
    output [31:0] next_pc
);

assign next_pc = pc + 32'd4;

endmodule


//==============================
// Program Counter
//==============================
module pc(
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc
);

always @(posedge clk)
begin
    if (reset)
        pc <= 32'b0;
    else
        pc <= next_pc;
end

endmodule

module instruction_memory(
    input  [31:0] addr,
    output [31:0] instruction
);

reg [31:0] mem [0:255];

initial
begin
    $readmemh("C:/Users/Katta Bhavani/Downloads/program.hex", mem);
end

assign instruction = mem[addr[31:2]];

endmodule

//INSTRUCTION DECODER

module instruction_decoder(
    input  [31:0] instruction,

    output [6:0] opcode,
    output [4:0] rd,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [6:0] funct7
);
assign opcode= instruction[6:0];
assign rd= instruction [11:7];
assign funct3= instruction [14:12];
assign rs1= instruction[19:15];
assign rs2 = instruction[24:20];
assign funct7 = instruction [31:25];

endmodule

// REGISTER FILE

module reg_file(
    input clk,
    input reg_write,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] registers [0:31];
integer i;

assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];

initial
begin
    for(i = 0; i < 32; i = i + 1)
        registers[i] = 32'b0;
end

always @(posedge clk)
begin
    if(reg_write && (rd != 0))
        registers[rd] <= write_data;

    registers[0] <= 32'b0;
end

endmodule


// CONTROL UNIT 

module control_unit(
    input [6:0] opcode,

    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg branch,
    output reg [1:0] alu_op
);

always @(*)
begin
    // Default values
    reg_write  = 1'b0;
    alu_src    = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    mem_to_reg = 1'b0;
    branch     = 1'b0;
    alu_op     = 2'b00;

    case(opcode)

        // R-Type (add, sub, and, or, etc.)
        7'b0110011:
        begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 2'b10;
        end

        // I-Type (addi)
       7'b0010011:
begin
    reg_write = 1'b1;
    alu_src   = 1'b1;
    alu_op    = 2'b00;
end
        // Load Word (lw)
        7'b0000011:
        begin
            reg_write  = 1'b1;
            alu_src    = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
            alu_op     = 2'b00;
        end

        // Store Word (sw)
        7'b0100011:
        begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_op    = 2'b00;
        end

        // Branch Equal (beq)
        7'b1100011:
        begin
            branch = 1'b1;
            alu_op = 2'b01;
        end

        // Default
        default:
        begin
            reg_write  = 1'b0;
            alu_src    = 1'b0;
            mem_read   = 1'b0;
            mem_write  = 1'b0;
            mem_to_reg = 1'b0;
            branch     = 1'b0;
            alu_op     = 2'b00;
        end

    endcase
end

endmodule

module alu_control(
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_control
);

always @(*)
begin
    alu_control = 4'b0000;

    case (alu_op)

        2'b00:
            alu_control = 4'b0010;

        2'b01:
            alu_control = 4'b0110;

        2'b10:
        begin
            case ({funct7, funct3})

                {7'b0000000,3'b000}: alu_control = 4'b0010;
                {7'b0100000,3'b000}: alu_control = 4'b0110;
                {7'b0000000,3'b111}: alu_control = 4'b0000;
                {7'b0000000,3'b110}: alu_control = 4'b0001;
                {7'b0000000,3'b100}: alu_control = 4'b0011;
                {7'b0000000,3'b001}: alu_control = 4'b0100;
                {7'b0000000,3'b101}: alu_control = 4'b0101;

                default: alu_control = 4'b0000;

            endcase
        end

        default:
            alu_control = 4'b0000;

    endcase
end

endmodule

module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*)
begin
    case(alu_control)

        4'b0000: result = a & b;
        4'b0001: result = a | b;
        4'b0010: result = a + b;
        4'b0011: result = a ^ b;
        4'b0100: result = a << b[4:0];
        4'b0101: result = a >> b[4:0];
        4'b0110: result = a - b;

        default: result = 32'b0;

    endcase
end

assign zero = (result == 32'b0);

endmodule

module immediate_generator(
    input [31:0] instruction,
    output reg [31:0] imm_out
);

wire [6:0] opcode;

assign opcode = instruction[6:0];

always @(*)
begin
    case(opcode)

        7'b0010011,
        7'b0000011:
            imm_out = {{20{instruction[31]}}, instruction[31:20]};

        7'b0100011:
            imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

        7'b1100011:
            imm_out = {{19{instruction[31]}},
                       instruction[31],
                       instruction[7],
                       instruction[30:25],
                       instruction[11:8],
                       1'b0};

        default:
            imm_out = 32'b0;

    endcase
end

endmodule

module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory [0:255];
integer i;

initial
begin
    for(i = 0; i < 256; i = i + 1)
        memory[i] = 32'b0;
end

always @(posedge clk)
begin
    if(mem_write)
        memory[address[31:2]] <= write_data;
end

always @(*)
begin
    if(mem_read)
        read_data = memory[address[31:2]];
    else
        read_data = 32'b0;
end

endmodule
