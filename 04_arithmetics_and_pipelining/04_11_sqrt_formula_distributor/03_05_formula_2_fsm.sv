//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
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

enum logic [2:0]
{
    st_idle = 3'd0,
    st_wait_res_c = 3'd1,
    st_wait_res_b = 3'd2,
    st_wait_res_a = 3'd3,
    st_wait_res_total = 3'd4
}
state, next_state;

always_comb begin
    isqrt_x     = 'x;
    isqrt_x_vld = '0;
    next_state = state;
    case(state)
        st_idle:
        begin
            isqrt_x = c;
            if(arg_vld) begin
                isqrt_x_vld = 1'b1;
                next_state = st_wait_res_c;
            end
        end
        st_wait_res_c:
        begin
            isqrt_x = b + isqrt_y;
            if(isqrt_y_vld) begin
                isqrt_x_vld = 1'b1;
                next_state = st_wait_res_b;
            end
        end
        st_wait_res_b:
        begin
            isqrt_x = a + isqrt_y;
            if(isqrt_y_vld) begin
                isqrt_x_vld = 1'b1;
                next_state = st_wait_res_total;
            end
        end
        st_wait_res_total:
        begin 
            if(isqrt_y_vld)
                next_state = st_idle;
        end
    endcase
end

always_ff @(posedge clk)begin
    if(rst)
        state <= st_idle;
    else
        state <= next_state;
end

always_ff @ (posedge clk)
    if (rst)
        res_vld <= '0;
    else
        res_vld <= (state == st_wait_res_total & isqrt_y_vld);

always_ff @(posedge clk)
    if(state == st_idle) begin
        res <= 0;
    end
    else if(isqrt_y_vld)
        res <= 32' (isqrt_y);

    // Task:
    //
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm


endmodule
