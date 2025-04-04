//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_saturation
(
  input  [3:0] a, b,
  output [3:0] sum
);
wire [3:0] pre_sum;
wire overflow;
wire sat_sum;
assign pre_sum = a + b;
assign overflow = (~pre_sum[3] & a[3] & b[3]) | (pre_sum[3] & (~a[3]) & (~b[3]));
assign sum = ~overflow ? pre_sum : (overflow & a[3] & b[3]) ? 4'b1000 : 4'b0111;

// (overflow & a[3] & b[3]) ? 4'b1 : (overflow & ~a[3] & b[3]) pre_sum;
  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.


endmodule
