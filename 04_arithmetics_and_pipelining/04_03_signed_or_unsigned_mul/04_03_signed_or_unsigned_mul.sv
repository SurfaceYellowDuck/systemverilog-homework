//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

// A non-parameterized module
// that implements the signed multiplication of 4-bit numbers
// which produces 8-bit result

module signed_mul_4
(
  input  signed [3:0] a, b,
  output signed [7:0] res
);

  assign res = a * b;

endmodule

// A parameterized module
// that implements the unsigned multiplication of N-bit numbers
// which produces 2N-bit result

module unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  output [2 * n - 1:0] res
);

  assign res = a * b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
//
// Implement a parameterized module
// that produces either signed or unsigned result
// of the multiplication depending on the 'signed_mul' input bit.

module signed_or_unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  input                signed_mul,
  output [2 * n - 1:0] res
);

  logic sign_a, sign_b;
  logic [n-1:0] abs_a, abs_b;
  logic [n*2-1:0] unsigned_product;

  assign sign_a = a[n-1];
  assign sign_b = b[n-1];

  assign abs_a = signed_mul ? (sign_a ? ~a + 'd1 : a) : a;
  assign abs_b = signed_mul ? (sign_b ? ~b + 'd1 : b) : b;

  assign unsigned_product =  abs_a * abs_b;

  assign res = signed_mul ? ((sign_a ^ sign_b) ? ~unsigned_product + 'd1 : unsigned_product): unsigned_product;
endmodule
