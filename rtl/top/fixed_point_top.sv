// You can later instantiate with different formats:
// e.g.
// fixed_point_top #(.WIDTH(16), .FRAC(10)) dut_fp16_10();

module fixed_point_top #(
  parameter int WIDTH = 12,
  parameter int FRAC  = 8
)(
  input  logic                     clk,
  input  logic                     rst,
  input  logic                     valid_in,
  input  fixed_point_pkg::fixed_t  a_in,
  input  fixed_point_pkg::fixed_t  b_in,
  output logic                     valid_out,
  output fixed_point_pkg::fixed_t  add_out,
  output fixed_point_pkg::fixed_t  sub_out,
  output fixed_point_pkg::fixed_t  mul_out,
  output fixed_point_pkg::fixed_t  div_out
);
  import fixed_point_pkg::*;

  // Stage 0 registers
  fixed_t a_s0, b_s0;
  logic   v_s0;

  // Stage 1 registers (results)
  fixed_t add_s1, sub_s1, mul_s1, div_s1;
  logic   v_s1;

  // Stage 0: capture inputs
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      v_s0 <= 1'b0;
    end else begin
      v_s0 <= valid_in;
      a_s0 <= a_in;
      b_s0 <= b_in;
    end
  end

  // Combinational arithmetic from stage 0
  fixed_t add_c, sub_c, mul_c, div_c;
  always_comb begin
    add_c = add(a_s0, b_s0);
    sub_c = sub(a_s0, b_s0);
    mul_c = mul(a_s0, b_s0);
    div_c = div(a_s0, b_s0);
  end

  // Stage 1: register results
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      v_s1 <= 1'b0;
    end else begin
      v_s1   <= v_s0;
      add_s1 <= add_c;
      sub_s1 <= sub_c;
      mul_s1 <= mul_c;
      div_s1 <= div_c;
    end
  end

  assign valid_out = v_s1;
  assign add_out   = add_s1;
  assign sub_out   = sub_s1;
  assign mul_out   = mul_s1;
  assign div_out   = div_s1;

endmodule

