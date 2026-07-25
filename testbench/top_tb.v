module top_tb;

reg clk;
reg reset;

top uut(
    .clk(clk),
    .reset(reset)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test
initial begin
    reset = 1;
    #20;
    reset = 0;

    // Wait for program execution
    #300;

    $display("\n================ PROCESSOR RESULTS ================");
    $display("x0  = %0d", uut.rf.registers[0]);
    $display("x1  = %0d", uut.rf.registers[1]);
    $display("x2  = %0d", uut.rf.registers[2]);
    $display("x3  = %0d", uut.rf.registers[3]);
    $display("x4  = %0d", uut.rf.registers[4]);
    $display("x5  = %0d", uut.rf.registers[5]);
    $display("x6  = %0d", uut.rf.registers[6]);
    $display("x7  = %0d", uut.rf.registers[7]);
    $display("x8  = %0d", uut.rf.registers[8]);
    $display("x9  = %0d", uut.rf.registers[9]);
    $display("x10 = %0d", uut.rf.registers[10]);
    $display("x11 = %0d", uut.rf.registers[11]);
    $display("x12 = %0d", uut.rf.registers[12]);

    $display("-----------------------------------------------");
   $display("Memory[0] = %0d", uut.dmem.memory[0]);
    $display("=================================================\n");

    $finish;
end

endmodule
