module fixed_point_top;
  timeunit 1ns/1ns;
  import fixed_point_pkg::*;

  // DUT inputs
  fixed_t a, b;

  // DUT outputs
  fixed_t add_out;
  fixed_t sub_out;
  fixed_t mul_out;
  fixed_t div_out;

  // Combinational logic using your package functions
  always_comb begin
    add_out = add(a, b);
    sub_out = sub(a, b);
    mul_out = mul(a, b);
    div_out = div(a, b);
  end

endmodule
