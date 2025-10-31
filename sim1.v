`timescale 1ns / 1ps

module fetch_tb;

    // Inputs
    reg clk;
    reg rst;
    reg ex_mem_pc_src;
    reg [31:0] ex_mem_npc;

    // Outputs
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // Instantiate the Unit Under Test (UUT)
    fetch uut (
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    // Clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        ex_mem_pc_src = 0;
        ex_mem_npc = 32'b0;

        // Hold reset for 2 cycles
        #15;
        rst = 0;

        // Let PC increment normally for a few cycles
        #60;

        // Simulate a branch: jump to instruction at address 0x00000020
        ex_mem_pc_src = 1;
        ex_mem_npc = 32'h00000020;

        #10; // one clock cycle
        ex_mem_pc_src = 0; // back to normal

        // Run a few more cycles after the jump
        #100;
    end
endmodule
