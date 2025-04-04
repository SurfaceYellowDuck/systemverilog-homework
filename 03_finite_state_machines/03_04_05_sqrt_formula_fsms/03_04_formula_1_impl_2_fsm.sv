//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_impl_2_fsm
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

    output logic        isqrt_1_x_vld,
    output logic [31:0] isqrt_1_x,

    input               isqrt_1_y_vld,
    input        [15:0] isqrt_1_y,

    output logic        isqrt_2_x_vld,
    output logic [31:0] isqrt_2_x,

    input               isqrt_2_y_vld,
    input        [15:0] isqrt_2_y
);

    enum logic [1:0]
    {
        st_idle1 = 2'd0,
        st_wait_res_a = 2'd1,
        st_wait_res_c1 = 2'd3
    }
    state1, next_state1;

    enum logic [1:0]
    {
        st_idle2 = 2'd0,
        st_wait_res_b = 2'd2,
        st_wait_res_c2 = 2'd3
    }
    state2, next_state2;

logic [32:0] minor_res;
always_comb 
begin 
    next_state1 = state1;
    isqrt_1_x_vld = '0;
    isqrt_1_x     = 'x;
    case(state1)
        st_idle1:
        begin
            isqrt_1_x = a;
            if (arg_vld)
            begin
                isqrt_1_x_vld = 1'b1;
                next_state1 = st_wait_res_a;
            end
        end
        st_wait_res_a:
        begin
            isqrt_1_x = c;
            if(isqrt_1_y_vld)begin
                isqrt_1_x_vld = 1'b1;
                next_state1 = st_wait_res_c1;
            end
        end
    endcase
end

always_comb begin 
    next_state2 = state2;
    isqrt_2_x_vld = '0;
    isqrt_2_x     = 'x;
    case(state2)
        st_idle2:
        begin
            isqrt_2_x = b;
            if (arg_vld)
            begin
                isqrt_2_x_vld = 1'b1;
                next_state2 = st_wait_res_b;
            end
        end
        st_wait_res_b:
        begin
            if(isqrt_2_y_vld)begin
                next_state2 = st_wait_res_c2;
            end
        end
    endcase
end

always_comb begin
    if(state1 == st_wait_res_c1 && state2 == st_wait_res_c2) begin
        if(isqrt_1_y_vld)begin
                next_state1 = st_idle1;
                next_state2 = st_idle2;
        end
    end
end

always_ff @(posedge clk)begin 
    if (rst)
    begin 
        state1 <= st_idle1;
        state2 <= st_idle2;
    end
    else 
    begin 
        state1 <= next_state1;
        state2 <= next_state2;
    end
end

always_ff @(posedge clk)begin 
    if (rst) begin 
        res_vld <= 1'b0;
    end
    else
        res_vld <= ( (state1 == st_wait_res_c1 & isqrt_1_y_vld) && (state2 == st_wait_res_c2 & isqrt_1_y_vld) );
end

always_ff @(posedge clk)begin 
    if(rst) begin 
        res <= 32'b0;
    end
    if (state1 == st_idle1 && state2 == st_idle2)
        res <= '0;
    else if ( (state1 == st_wait_res_c1 & isqrt_1_y_vld) && (state2 == st_wait_res_c2 & isqrt_1_y_vld) )
        res <= res + 32' (isqrt_1_y);
    else if (isqrt_1_y_vld && isqrt_2_y_vld)
        res <= res + 32' (isqrt_1_y) + 32' (isqrt_2_y);
end
    // Task:
    // Implement a module that calculates the formula from the `formula_1_fn.svh` file
    // using two instances of the isqrt module in parallel.
    //
    // Design the FSM to calculate an answer and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm


endmodule
