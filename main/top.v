module top(
    input clk,
    input reset
);

wire [31:0] pc;
wire [31:0] next_pc;

wire [31:0] instruction;

wire [6:0] opcode;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [2:0] funct3;
wire [6:0] funct7;

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire branch;
wire [1:0] alu_op;

wire [3:0] alu_control;

wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] imm_out;

wire [31:0] alu_b;
wire [31:0] alu_result;
wire zero;

wire [31:0] mem_data;
wire [31:0] write_back_data;
wire branch_taken;
wire [31:0] branch_pc;
wire [31:0] next_pc_final;

assign branch_taken = branch & zero;
assign branch_pc = pc + imm_out;
assign next_pc_final = (branch_taken) ? branch_pc : next_pc;

next_pc_generator npc_gen(
    .pc(pc),
    .next_pc(next_pc)
);

pc pc_reg(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc_final),
    .pc(pc)
);
instruction_memory imem(
    .addr(pc),
    .instruction(instruction)
);

instruction_decoder decoder(
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
);

control_unit cu(
    .opcode(opcode),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch),
    .alu_op(alu_op)
);

reg_file rf(
    .clk(clk),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

immediate_generator imm_gen(
    .instruction(instruction),
    .imm_out(imm_out)
);

alu_control alu_ctrl(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_control(alu_control)
);
assign alu_b = (alu_src) ? imm_out : read_data2;
alu alu_inst(
    .a(read_data1),
    .b(alu_b),
    .alu_control(alu_control),
    .result(alu_result),
    .zero(zero)
);
data_memory dmem(
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(alu_result),
    .write_data(read_data2),
    .read_data(mem_data)
);
assign write_back_data = (mem_to_reg) ? mem_data : alu_result;

endmodule
