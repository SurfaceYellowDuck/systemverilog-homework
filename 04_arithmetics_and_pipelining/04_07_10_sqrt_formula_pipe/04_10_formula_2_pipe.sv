//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

logic [31:0] c_sqrt;
logic c_sqrt_rdy;

logic [31:0] half_sum_c_b;
logic        half_sum_c_b_rdy;

logic [31:0]  b_shift;
logic         b_rdy;

logic [31:0] a_shift;
logic        a_rdy;

logic [31:0] half_sum_c_b_sqrt;
logic        half_sum_c_b_sqrt_rdy;

logic [31:0] half_sum_c_b_a;
logic        half_sum_c_b_a_rdy;

logic [31:0] half_sum_c_b_a_sqrt;
logic        half_sum_c_b_a_sqrt_rdy;

isqrt # (.n_pipe_stages (4)) isqrt1 (
    .clk (clk),
    .rst (rst),
    .x_vld (arg_vld),
    .x (c),
    .y_vld (c_sqrt_rdy),
    .y (c_sqrt)
);

shift_register_with_valid #(.width (32), .depth (4)) shift_reg (
    .clk (clk),
    .rst (rst),
    .in_vld (arg_vld),
    .in_data (b),
    .out_vld (b_rdy),
    .out_data (b_shift)
);

always_ff @(posedge clk)begin
    if (c_sqrt_rdy) begin
        half_sum_c_b <= b_shift + c_sqrt;
    end
end

always_ff @(posedge clk)begin
    if(rst)
        half_sum_c_b_rdy <= '0;
    else
        half_sum_c_b_rdy <= c_sqrt_rdy;
end

isqrt # (.n_pipe_stages (4)) isqrt2 (
    .clk (clk),
    .rst (rst),
    .x_vld (half_sum_c_b_rdy),
    .x (half_sum_c_b),
    .y_vld (half_sum_c_b_sqrt_rdy),
    .y (half_sum_c_b_sqrt)
);

shift_register_with_valid #(.width (32), .depth (9)) shift_reg1 (
    .clk (clk),
    .rst (rst),
    .in_vld (arg_vld),
    .in_data (a),
    .out_vld (a_rdy),
    .out_data (a_shift)
);

always_ff @(posedge clk)begin
    if (half_sum_c_b_sqrt_rdy) begin
        half_sum_c_b_a <= a_shift + half_sum_c_b_sqrt;
    end
end

always_ff @(posedge clk)begin
    if(rst)
        half_sum_c_b_a_rdy <= '0;
    else
        half_sum_c_b_a_rdy <= half_sum_c_b_sqrt_rdy;
end


isqrt # (.n_pipe_stages (4)) isqrt3 (
    .clk (clk),
    .rst (rst),
    .x_vld (half_sum_c_b_a_rdy),
    .x (half_sum_c_b_a),
    .y_vld (res_vld),
    .y (res)
);
    // Task:
    //
    // Implement a pipelined module formula_2_pipe that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0


endmodule
