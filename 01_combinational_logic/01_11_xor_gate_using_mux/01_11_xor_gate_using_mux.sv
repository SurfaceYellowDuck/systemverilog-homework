//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

wire y_1;
wire y_2;

wire y_3;
wire y_4;


mux mux_1
(
    .d0  ( 1   ),
    .d1  ( 0   ),
    .sel ( a   ),
    .y   ( y_1 )
);

mux mux_2
(
    .d0  ( a   ),
    .d1  ( y_1 ),
    .sel ( b   ),
    .y   ( y_2 )
);

assign o = y_2;

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


endmodule
