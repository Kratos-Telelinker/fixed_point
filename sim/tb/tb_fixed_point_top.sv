
`timescale 1ns/1ps

module tb_fixed_point_top;

  import fixed_point_pkg::*;

  // ------------------------------------------------------------
  // DUT Signals
  // ------------------------------------------------------------
  logic clk;
  logic rst;
  logic valid_in;

  fixed_t a_in;
  fixed_t b_in;

  logic   valid_out;
  fixed_t add_out;
  fixed_t sub_out;
  fixed_t mul_out;
  fixed_t div_out;

  // ------------------------------------------------------------
  // Extra fixed-point variables for tests
  // ------------------------------------------------------------
  fixed_t sqrt_input;
  fixed_t sqrt_output;

  fixed_t angle;
  fixed_t cos_val;
  fixed_t sin_val;

  // ------------------------------------------------------------
  // DUT Instance
  // ------------------------------------------------------------
  fixed_point_top dut (
    .clk       (clk),
    .rst       (rst),
    .valid_in  (valid_in),
    .a_in      (a_in),
    .b_in      (b_in),
    .valid_out (valid_out),
    .add_out   (add_out),
    .sub_out   (sub_out),
    .mul_out   (mul_out),
    .div_out   (div_out)
  );

  // ------------------------------------------------------------
  // Clock Generation
  // ------------------------------------------------------------
  always #5 clk = ~clk;   // 100 MHz

  // ------------------------------------------------------------
  // Stimulus: arithmetic + sqrt + CORDIC
  // ------------------------------------------------------------
  initial begin
    clk      = 0;
    rst      = 1;
    valid_in = 0;

    a_in        = from_int(0);
    b_in        = from_int(0);
    sqrt_input  = from_int(0);
    sqrt_output = from_int(0);
    angle       = from_int(0);
    cos_val     = from_int(0);
    sin_val     = from_int(0);

    #20 rst = 0;

    // -----------------------------
    // Test 1: Arithmetic
    // -----------------------------
    @(posedge clk);
    a_in     = from_real(3.0);
    b_in     = from_real(0.75);
    valid_in = 1;

    @(posedge clk);
    valid_in = 0;

    repeat (4) @(posedge clk);

    // -----------------------------
    // Test 2: Square Root
    // -----------------------------
    sqrt_input  = from_real(2.0);
    sqrt_output = fsqrt(sqrt_input);

    $display("SQRT Test:");
    $display("sqrt_input  = %f", to_real(sqrt_input));
    $display("sqrt_output = %f", to_real(sqrt_output));

    // -----------------------------
    // Test 3: CORDIC sin/cos
    // -----------------------------
    angle = from_real(0.785398163); // 45 degrees

    cordic_sincos(angle, cos_val, sin_val);

    $display("CORDIC Test:");
    $display("angle = %f", to_real(angle));
    $display("cos   = %f", to_real(cos_val));
    $display("sin   = %f", to_real(sin_val));

    // -----------------------------
    // End simulation
    // -----------------------------
    #50 $finish;
  end

  // ------------------------------------------------------------
  // Output Monitor
  // ------------------------------------------------------------
  always @(posedge clk) begin
    if (valid_out) begin
      $display("--------------------------------------------------");
      $display("ADD = %f", to_real(add_out));
      $display("SUB = %f", to_real(sub_out));
      $display("MUL = %f", to_real(mul_out));
      $display("DIV = %f", to_real(div_out));
      $display("--------------------------------------------------");
    end
  end

endmodule
