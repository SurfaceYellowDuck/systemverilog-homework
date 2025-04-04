module float_discriminant_distributor (
    input                           clk,
    input                           rst,

    input                           arg_vld,
    input        [FLEN - 1:0]       a,
    input        [FLEN - 1:0]       b,
    input        [FLEN - 1:0]       c,

    output logic                    res_vld,
    output logic [FLEN - 1:0]       res,
    output logic                    res_negative,
    output logic                    err,

    output logic                    busy
);

    logic [FLEN - 1:0] a_in [9:0];
    logic [FLEN - 1:0] b_in [9:0];
    logic [FLEN - 1:0] c_in [9:0];
    logic [9:0] arg_vld_;

    logic [FLEN - 1:0] results [9:0];
    logic [9:0] results_vld;
    logic [9:0] res_negative_out;
    logic [9:0] err_out;
    logic [9:0] busy_out;

    logic [3:0]    counter;
    logic [9:0]   instance_en;

    always_ff @ (posedge clk) begin
        if (rst)
            counter <= 'd0;
        else if (arg_vld)
            counter <= (counter + 'd1) % 10;
    end

    always_comb begin
        for (logic [4 - 1:0] i = 0; i < 10; ++i)
            instance_en[i] = counter == i ? '1 : '0;
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            arg_vld_ <= 0;
        end
        for (int i = 0; i < 10; i ++) begin
        if(instance_en[i])begin
            arg_vld_[i] <= arg_vld;
        end
        else
            arg_vld_[i] <= '0;
        end
    end

    always_ff @(posedge clk)begin
        for (int i = 0; i < 10; i ++)begin
            if(instance_en[i] && arg_vld)begin
                a_in[i] <= a;
                b_in[i] <= b;
                c_in[i] <= c;
            end
        end
    end

 genvar i;
    generate
        begin
            for (i = 0; i < 10; i ++)begin : module_gen1
                float_discriminant fd1(
                    .clk (clk),
                    .rst (rst),
                    .arg_vld (arg_vld_[i]),
                    .a (a_in[i]),
                    .b (b_in[i]),
                    .c (c_in[i]),
                    .res_vld (results_vld[i]),
                    .res (results[i]),
                    .res_negative (res_negative_out[i]),
                    .err (err_out[i]),
                    .busy (busy_out[i])
                );
            end
        end
    endgenerate

    always_comb begin
        for (int i = 0; i < 10; i ++)
            if(results_vld[i])begin
                res = results[i];
            end
        res_vld = | results_vld;
        res_negative = | res_negative_out;
        err = | err_out;
        busy = | busy_out;
    end

    // Task:
    //
    // Implement a module that will calculate the discriminant based
    // on the triplet of input number a, b, c. The module must be pipelined.
    // It should be able to accept a new triple of arguments on each clock cycle
    // and also, after some time, provide the result on each clock cycle.
    // The idea of the task is similar to the task 04_11. The main difference is
    // in the underlying module 03_08 instead of formula modules.
    //
    // Note 1:
    // Reuse your file "03_08_float_discriminant.sv" from the Homework 03.
    //
    // Note 2:
    // Latency of the module "float_discriminant" should be clarified from the waveform.


endmodule
