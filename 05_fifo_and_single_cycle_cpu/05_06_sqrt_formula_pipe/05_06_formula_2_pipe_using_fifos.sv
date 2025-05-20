//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_fifos
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

logic [31:0] a_fifo_out;
logic        a_fifo_full;


logic [31:0] c_sqrt_out;
logic        c_sqrt_out_vld;

logic [31:0] b_fifo_out;

logic [31:0] c_b_sum;
logic        cb_vld;

logic [31:0] c_b_sqrt;
logic        c_b_sqrt_vld;

logic        a_cb_sum;

logic [31:0] a_c_b_sqrt;

logic        c_b_sqrt_vld_reg;

isqrt #(.n_pipe_stages(16)) i_isqrt_c
(
    .clk   ( clk            ),
    .rst   ( rst            ),
    .x_vld ( arg_vld        ),
    .x     ( c              ),
    .y_vld ( c_sqrt_out_vld ),
    .y     ( c_sqrt_out     )
);


flip_flop_fifo_with_counter #(.width(32), .depth(16)) fifo_depth_33Tc
(
    .clk        (clk),
    .rst        (rst),
    .push       (arg_vld),
    .pop        (c_sqrt_out_vld),
    .write_data (b),
    .read_data  (b_fifo_out),
    .empty      (),
    .full       ()
);

always_ff @(posedge clk)begin
    if(rst)begin
        cb_vld <= '0;
    end
        cb_vld <= c_sqrt_out_vld;
end

always_ff @(posedge clk) begin
    if (c_sqrt_out_vld) begin
        c_b_sum <= b_fifo_out + c_sqrt_out;
    end
end


isqrt i_isqrt_cb
(
    .clk   ( clk         ),
    .rst   ( rst         ),
    .x_vld ( cb_vld            ),
    .x     ( c_b_sum           ),
    .y_vld ( c_b_sqrt_vld ),
    .y     ( c_b_sqrt     )
);

always_ff @(posedge clk)begin
    if(rst)begin
        c_b_sqrt_vld_reg <= '0;
    end
    c_b_sqrt_vld_reg <= c_b_sqrt_vld;
end

always_ff @(posedge clk) begin
    if (c_b_sqrt_vld) begin
        a_c_b_sqrt <= a_fifo_out + c_b_sqrt;
    end
end

flip_flop_fifo_with_counter #(.width (32), .depth (33)) fifo_depth_16
(
    .clk (clk),
    .rst (rst),
    .push (arg_vld),
    .pop (c_b_sqrt_vld),
    .write_data (a),
    .read_data (a_fifo_out),
    .empty (),
    .full ()
);


isqrt i_isqrt_a
(
    .clk   ( clk         ),
    .rst   ( rst         ),
    .x_vld ( c_b_sqrt_vld_reg ),
    .x     ( a_c_b_sqrt     ),
    .y_vld ( res_vld ),
    .y     ( res     )
);


    // Task:
    //
    // Implement a pipelined module formula_2_pipe_using_fifos that computes the result
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
    // 3. Your solution should use FIFOs instead of shift registers
    // which were used in 04_10_formula_2_pipe.sv.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm


endmodule
