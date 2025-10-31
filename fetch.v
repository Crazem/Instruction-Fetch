`timescale 1ns / 1ps

module fetch(
    input wire clk,
    input wire rst,
    input wire ex_mem_pc_src,
    input wire [31:0] ex_mem_npc,
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_npc
);

    wire [31:0] pc_out, pc_mux, next_pc, instr_data;

    mux m0(.a_true(ex_mem_npc), .b_false(next_pc), .sel(ex_mem_pc_src), .y(pc_mux));
    pc pc0(.clk(clk), .rst(rst), .pc_in(pc_mux), .pc_out(pc_out));
    incrementer in0(.pcin(pc_out), .pcout(next_pc)); // FIXED: no clk/rst
    instrMem inMem0(.addr(pc_out), .data(instr_data)); // FIXED: combinational
    ifIdLatch ifIdLatch0(.clk(clk), .rst(rst), .pc_in(next_pc), .instr_in(instr_data),
                         .pc_out(if_id_npc), .instr_out(if_id_instr)); // FIXED: use next_pc

endmodule


module ifIdLatch(
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 32'b0;
            instr_out <= 32'b0;
        end else begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule


module mux (
    input wire [31:0] a_true,
    input wire [31:0] b_false,
    input wire sel,
    output reg [31:0] y
);
    always @(*) begin
        if (sel)
            y = a_true;
        else
            y = b_false;
    end
endmodule


module pc (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        if (rst)
            pc_out <= 32'b0;
        else
            pc_out <= pc_in;
    end
endmodule


module incrementer (
    input wire [31:0] pcin,
    output wire [31:0] pcout
);
    assign pcout = pcin + 32'd4;
endmodule


module instrMem (
    input wire [31:0] addr,
    output reg [31:0] data
);
    reg [31:0] mem [0:31];

    initial begin
        mem[0]  = 32'hA00000AA;
        mem[1]  = 32'h10000011;
        mem[2]  = 32'h20000022;
        mem[3]  = 32'h30000033;
        mem[4]  = 32'h40000044;
        mem[5]  = 32'h50000055;
        mem[6]  = 32'h60000066;
        mem[7]  = 32'h70000077;
        mem[8]  = 32'h80000088;
        mem[9]  = 32'h90000099;
    end

    always @(*) begin
        data = mem[addr >> 2];
    end
endmodule
