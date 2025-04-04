//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);

logic valid;
logic [width - 1] idx = width - 1;
reg [0 : width - 1] res;

always_ff @(posedge clk)
    if (rst) begin
        valid <= 0;
    end
    else begin
        valid <= 0;
        if (serial_valid) begin
            res[idx] <= serial_data;
            idx <= idx - 1;
            if(idx == 0)begin
                valid <= 1;
                idx <= width - 1;
            end
        end
    end
assign parallel_data = res;
assign parallel_valid = valid;

    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.


endmodule
