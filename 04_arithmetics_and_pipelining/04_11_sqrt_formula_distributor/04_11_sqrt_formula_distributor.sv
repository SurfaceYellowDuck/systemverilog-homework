module sqrt_formula_distributor
# (
    parameter formula = 1,
              impl    = 1
)
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output logic        res_vld,
    output logic [31:0] res
);

    logic [31:0] results [49:0];
    logic [49:0] results_vld;

    logic [7:0]    counter;
    logic [49:0]   instance_en;
    

    logic [31:0] a_in [49:0];
    logic [31:0] b_in [49:0];
    logic [31:0] c_in [49:0];
    logic [49:0] arg_vld_;

    always_ff @ (posedge clk) begin
        if (rst)
            counter <= 'd0;
        else if (arg_vld)
            counter <= (counter + 'd1) % 50;
    end

    always_comb begin
        for (logic [7 - 1:0] i = 0; i < 50; ++i)
            instance_en[i] = counter == i ? '1 : '0;
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            arg_vld_ <= 0;
        end
        for (int i = 0; i < 50; i ++) begin
        if(instance_en[i])begin
            arg_vld_[i] <= arg_vld;
        end
        else
            arg_vld_[i] <= '0;
        end
    end

    always_ff @(posedge clk)begin
        for (int i = 0; i < 50; i ++)begin
            if(instance_en[i] && arg_vld)begin
                a_in[i] <= a;
                b_in[i] <= b;
                c_in[i] <= c;
            end
        end
    end

    genvar i;
    generate
        if(formula == 1 && impl == 1)begin
            for (i = 0; i < 50; i ++)begin : module_gen1
                formula_1_impl_1_top f1i1top(
                    .clk (clk),
                    .rst (rst),
                    .arg_vld (arg_vld_[i]),
                    .a (a_in[i]),
                    .b (b_in[i]),
                    .c (c_in[i]),
                    .res_vld (results_vld[i]),
                    .res (results[i])
                );
            end
        end
        else if(formula == 1 && impl == 2)begin
            for (i = 0; i < 50; i ++)begin : module_gen2
                formula_1_impl_2_top f1i2top(
                    .clk (clk),
                    .rst (rst),
                    .arg_vld (arg_vld_[i]),
                    .a (a_in[i]),
                    .b (b_in[i]),
                    .c (c_in[i]),
                    .res_vld (results_vld[i]),
                    .res (results[i])
                );
            end
        end
        else if(formula == 2 && impl == 1)begin
            for (i = 0; i < 50; i ++)begin : module_gen3
                formula_2_top f2i1top(
                    .clk (clk),
                    .rst (rst),
                    .arg_vld (arg_vld_[i]),
                    .a (a_in[i]),
                    .b (b_in[i]),
                    .c (c_in[i]),
                    .res_vld (results_vld[i]),
                    .res (results[i])
                );
            end
        end
    endgenerate

    always_comb begin
        for (int i = 0; i < 50; i ++)
            if(results_vld[i])begin
                res = results[i];
            end
        res_vld = | results_vld;
    end
    
    // Task:
    //
    // Implement a module that will calculate formula 1 or formula 2
    // based on the parameter values. The module must be pipelined.
    // It should be able to accept new triple of arguments a, b, c arriving
    // at every clock cycle.
    //
    // The idea of the task is to implement hardware task distributor,
    // that will accept triplet of the arguments and assign the task
    // of the calculation formula 1 or formula 2 with these arguments
    // to the free FSM-based internal module.
    //
    // The first step to solve the task is to fill 03_04 and 03_05 files.
    //
    // Note 1:
    // Latency of the module "formula_1_isqrt" should be clarified from the corresponding waveform
    // or simply assumed to be equal 50 clock cycles.
    //
    // Note 2:
    // The task assumes idealized distributor (with 50 internal computational blocks),
    // because in practice engineers rarely use more than 10 modules at ones.
    // Usually people use 3-5 blocks and utilize stall in case of high load.
    //
    // Hint:
    // Instantiate sufficient number of "formula_1_impl_1_top", "formula_1_impl_2_top",
    // or "formula_2_top" modules to achieve desired performance.

endmodule
