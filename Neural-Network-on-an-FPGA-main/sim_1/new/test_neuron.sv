`timescale 1ns / 1ps

`include "include.svh"

module test_neuron;

    // Device under test

    localparam int NUM_INPUTS = 16;
    localparam activation_type ACTIVATION = RELU;

    logic clock, reset, inputs_ready, output_ready;
    fixed_point inputs[NUM_INPUTS], out;

    neuron #(
        .NUM_INPUTS(NUM_INPUTS),
        .ACTIVATION(ACTIVATION)
    ) n (.*);


    // Clock generator

    localparam real CLOCK_PERIOD = 1.0;
    localparam real RESET_PERIOD = 0.1;

    clock_generator #(
        .CLOCK_PERIOD(CLOCK_PERIOD),
        .RESET_PERIOD(RESET_PERIOD)
    ) cg (.*);


    // Stimulus

    initial begin
        #RESET_PERIOD

        $display("Inputs:");
        foreach (inputs[i]) begin
            inputs[i].integral = 0;
            inputs[i].fraction = $urandom_range(1 << FRACTION_WIDTH);
            $display("%b.%b", inputs[i].integral, inputs[i].fraction);
        end
        inputs_ready = 1;

        forever begin
            #CLOCK_PERIOD
            if (output_ready) begin
                $display("Output:");
                $display("%b.%b", out.integral, out.fraction);
                $stop;
            end
        end
        $stop;
    end

endmodule