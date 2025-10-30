`timescale 1ns / 1ps

module sim1;

   // Inputs
    reg clk;
    reg rst;
    reg ex_mem_pc_src;
    reg [31:0] ex_mem_npc;

    // Outputs
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // Instantiate the fetch stage
    fetch dut(
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

     //Test sequence
    initial begin
        rst = 1;
        ex_mem_pc_src = 0;
        ex_mem_npc = 32'b0;

        #10;  // hold reset for 1 clock cycle
        rst = 0;

        // Run simulation for 20 clock cycles
        #200;
    end

endmodule
