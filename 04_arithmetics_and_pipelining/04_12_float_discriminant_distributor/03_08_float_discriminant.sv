//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);

    localparam [FLEN - 1:0] four = 64'h4010_0000_0000_0000;


    logic [FLEN - 1:0] res_mult_b_b;
    logic [FLEN - 1:0] res_mult_a_c;
    logic [FLEN - 1:0] res_mult_4_a_c;
    logic [FLEN - 1:0] res_sub;

    logic res_b_b_mux_rdy;
    logic res_a_c_mux_rdy;
    logic res_4_a_c_mux_rdy;
    logic res_sub_rdy;

    logic err_b_b_mux;
    logic err_a_c_mux;
    logic err_4_a_c_mux;
    logic err_sub;

    logic data_rdy = res_b_b_mux_rdy && res_4_a_c_mux_rdy;
    assign err = (err_b_b_mux || err_a_c_mux || err_4_a_c_mux || err_sub);;

    f_mult f_mult_b_b
    (
        .clk (clk),
        .rst (rst),
        .a     (b),
        .b     (b),
        .up_valid (arg_vld),
        .res   (res_mult_b_b),
        .down_valid (res_b_b_mux_rdy),
        .busy (),
        .error (err_b_b_mux)
    );

    f_mult f_mult_a_c
    (
        .clk (clk),
        .rst (rst),
        .a     (a),
        .b     (c),
        .up_valid (arg_vld),
        .res   (res_mult_a_c),
        .down_valid (res_a_c_mux_rdy),
        .busy (),
        .error (err_a_c_mux)
    );

    f_mult f_mult_4_a_c
    (
        .clk (clk),
        .rst (rst),
        .a     (four),
        .b     (res_mult_a_c),
        .up_valid (res_a_c_mux_rdy),
        .res   (res_mult_4_a_c),
        .down_valid (res_4_a_c_mux_rdy),
        .busy (),
        .error (err_4_a_c_mux)
    );

    f_sub f_sub_b_4_a_c
    (
        .clk (clk),
        .rst (rst),
        .a     (res_mult_b_b),
        .b     (res_mult_4_a_c),
        .up_valid (res_4_a_c_mux_rdy),
        .res   (res),
        .down_valid (res_vld),
        .busy (),
        .error (err_sub)
    );
    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs their discriminant.
    // The resulting value res should be calculated as a discriminant of the quadratic polynomial.
    // That is, res = b^2 - 4ac == b*b - 4*a*c
    //
    // Note:
    // If any argument is not a valid number, that is NaN or Inf, the "err" flag should be set.
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.


endmodule
