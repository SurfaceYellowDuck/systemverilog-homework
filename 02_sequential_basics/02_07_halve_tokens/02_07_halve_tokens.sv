//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);
logic two_units;
always_ff @(posedge clk)
    if(rst)begin
        two_units <= 0;
    end
    else if(a)begin 
        two_units <= ~ two_units; 
    end
assign b = a & two_units;


    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101


endmodule
