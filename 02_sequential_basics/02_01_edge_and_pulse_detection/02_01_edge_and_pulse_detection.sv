//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

  logic a_r;
  logic detected_pos;
  logic detected_neg;
  logic more_one_unit;
  always_ff @ (posedge clk)
    if (rst) begin
      a_r <= '0;
      more_one_unit <= 1;
    end
    else if((a_r && a) == 1)
      more_one_unit <= 0;
    else begin
      a_r <= a;
      more_one_unit <= 1;
    end

  assign detected = (a_r & ~a) & more_one_unit;

  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).


endmodule
