module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output logic                      down_vld,
    output logic [ width   - 1 : 0 ]  down_data
);

    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.

logic [ n_inputs - 1: 0 ]
      [ width   - 1 : 0 ] queue_data ;

logic [ n_inputs - 1 : 0 ] queue_vld;

logic [$clog2(n_inputs) + 1 : 0] next_awaiting_index;

always_ff @(posedge clk)begin
    if(| up_vlds)begin
        for (int i = 0; i < n_inputs; i ++)begin
            if(up_vlds[i]) begin
                queue_data[i] <= up_data[i];
                queue_vld[i] <= up_vlds[i];
            end
        end
    end
end

always_ff @(posedge clk)begin
        if(queue_vld[next_awaiting_index])begin
            queue_vld[next_awaiting_index] <= '0;
            down_data <= queue_data[next_awaiting_index];
            down_vld <= queue_vld[next_awaiting_index];
            next_awaiting_index <= (next_awaiting_index + 1) % n_inputs;
        end
        else
            down_vld <= 0;
end

always_ff @(posedge clk)begin
    if(rst)begin
        next_awaiting_index <= 0;
    end
end

endmodule
