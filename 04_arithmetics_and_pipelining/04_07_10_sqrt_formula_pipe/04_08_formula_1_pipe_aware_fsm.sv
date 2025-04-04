//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

  enum logic[2:0]
  {
     IDLE = 3'b000,
     S0   = 3'b001,
     S1   = 3'b010,
     S2   = 3'b011,
     S3   = 3'b100,
     S4   = 3'b101
  }
  state, new_state;


 logic [31:0] a_in;
 logic [31:0] b_in;
 logic [31:0] c_in;
 logic args_rdy;

 logic [15:0] res_a;
 logic ready_a;
 logic [15:0] res_b;
 logic ready_b;
 logic [15:0] res_c;
 logic ready_c;

 always_comb begin
    new_state = state;
    case(state)
        IDLE: begin
            if (rst)
                new_state = IDLE;
            else if(!arg_vld)
                new_state = IDLE;
            else
                new_state = S0;
        end

        S0: begin
            if (rst)
                new_state = IDLE;
            else
                new_state = S1;
        end
        S1: begin
            if (rst)
                new_state = IDLE;
            else
                new_state = S2;
        end

        S2: begin
            if (rst) 
                new_state = IDLE;
            else if (!isqrt_y_vld)
                new_state = S2;
            else
                new_state = S3;
        end

        S3: begin
            if (rst) 
                new_state = IDLE;
            else if (!isqrt_y_vld)
                new_state = S3;
            else
                new_state = S4;
        end
        S4: begin
            if (rst) 
                new_state = IDLE;
            else if (!isqrt_y_vld)
                new_state = S4;
            else
                new_state = IDLE;
        end
    endcase
 end

 always_comb begin
    case(state)
        IDLE:begin
            args_rdy = arg_vld;
            a_in = 'x;
            b_in = 'x;
            c_in = 'x;
            res_vld = '0;
            if(arg_vld)begin
                a_in = a;
                b_in = b;
                c_in = c;
                isqrt_x = a_in;
                isqrt_x_vld = '1;
            end
        end
        S0: begin
            if(args_rdy)begin
                isqrt_x = b_in;
                isqrt_x_vld = '1;
            end
        end
        S1: begin
            if(args_rdy)begin
                isqrt_x = c_in;
                isqrt_x_vld = '1;
            end
        end
        S2: begin
            if(isqrt_y_vld)begin
                res_a = isqrt_y;
                ready_a = isqrt_y_vld;
            end
        end
        S3: begin
            if(isqrt_y_vld)begin
                res_b = isqrt_y;
                ready_b = isqrt_y_vld;
            end
        end
        S4: begin
            if(!arg_vld)
                isqrt_x_vld = 0;
            if(isqrt_y_vld)begin
                res_c = isqrt_y;
                ready_c = isqrt_y_vld;
                res = res_a + res_b + res_c;
                res_vld = ready_a & ready_b & ready_c;
            end
        end
    endcase
 end

 always_ff @(posedge clk)begin
    if(rst)
        state <= IDLE;
    else
        state <= new_state;
 end
    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0


endmodule
