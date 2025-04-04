//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);
enum logic [2 : 0]
{
    st_idle = 3'b0,
    st_set_a_b = 3'b001,
    st_set_b_c = 3'b010,
    st_set_a_c = 3'b011,
    st_sort = 3'b100,
    st_res = 3'b101,
    st_err = 3'b110
}
state, next_state;

logic a_le_b;
logic b_le_c;
logic a_le_c;

always_comb begin 
    next_state = state;
    case(state)
        st_idle:
        begin
            if(valid_in) begin
                next_state = st_set_a_b;
            end
            else begin
                next_state = st_idle;
            end
        end
        st_set_a_b:
        begin
            if (!f_le_err) begin
                next_state = st_set_b_c;
            end
            else begin
                next_state = st_err;
            end
        end
        st_set_b_c:
        begin
            if (!f_le_err) begin
                next_state = st_set_a_c;
            end
            else begin
                next_state = st_err;
            end
        end
        st_set_a_c:
        begin
            if (!f_le_err) begin
                next_state = st_sort;
            end
            else begin
                next_state = st_err;
            end
        end
        st_sort:
        begin
            next_state = st_res;
        end
        st_err:
        begin
            next_state = st_idle;
        end
        st_res:
        begin
            next_state = st_idle;
        end
    endcase
end

always_comb begin 
    case(state)
        st_idle: 
        begin
            valid_out = 1'b0;
            err = 1'b0;
        end
        st_set_a_b:
        begin
            f_le_a = unsorted[0];
            f_le_b = unsorted[1];
            a_le_b = f_le_res;
        end
        st_set_b_c:
        begin
            f_le_a = unsorted[1];
            f_le_b = unsorted[2];
            b_le_c = f_le_res;
        end
        st_set_a_c:
        begin
            f_le_a = unsorted[0];
            f_le_b = unsorted[2];
            a_le_c = f_le_res;
        end
        st_sort:
        begin
            if(a_le_b)begin 
            
                if (b_le_c) begin 
                    sorted = {unsorted[0], unsorted[1], unsorted[2]};
                end

                else if (a_le_c) begin 
                    {  sorted[0],   sorted[1],   sorted[2]} = 
                    {unsorted[0], unsorted[2], unsorted[1]};
                end

                else
                    {  sorted[0],   sorted[1],   sorted[2]} = 
                    {unsorted[2], unsorted[0], unsorted[1]};
            end
            else begin 
                if (b_le_c && a_le_c) begin 
                    {  sorted[0],   sorted[1],   sorted[2]} = 
                    {unsorted[1], unsorted[0], unsorted[2]};
                end
                else if (b_le_c && !a_le_c) begin 
                    {  sorted[0],   sorted[1],   sorted[2]} = 
                    {unsorted[1], unsorted[2], unsorted[0]};
                end
                else if (!b_le_c && !a_le_c) begin 
                    {  sorted[0],   sorted[1],   sorted[2]} =
                    {unsorted[2], unsorted[1], unsorted[0]};
                end
            end
        end
        st_err:
            begin
                err = 1'b1;
                valid_out = 1'b1;
            end
        st_res: valid_out = 1'b1;

    endcase
end

always_ff @(posedge clk) begin 
    if (rst)
        state <= st_idle;
    else
        state <= next_state;
end
    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.



endmodule
