module tb_fixed_point_top;
  timeunit 1ns/1ns;
  import fixed_point_pkg::*;

  // DUT instance
  fixed_point_top dut();

  initial begin
    // Initialize values
    dut.a = from_int(3);          // 3.0
    dut.b = from_real(1.7512);    // 1.75

    $display("a      = %f", to_real(dut.a));
    $display("a      = %h", dut.a);
    $display("b      = %f", to_real(dut.b));
    $display("b      = %h", dut.b);

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a + b  = %h", dut.add_out);

    #10;
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a - b  = %h", dut.sub_out);

    #10;
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a x b  = %h", dut.mul_out);

    #10;
    $display("a / b  = %f", to_real(dut.div_out));
    $display("a / b  = %h", dut.div_out);

    // Now reuse results like your original TB
    #10 dut.a = dut.b;
        dut.b = dut.mul_out;

    $display("a      = %f", to_real(dut.a));
    $display("b      = %f", to_real(dut.b));

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a / b  = %f", to_real(dut.div_out));

    $display("a      = %f", to_real(dut.a));
    $display("a      = %h", dut.a);
    $display("b      = %f", to_real(dut.b));
    $display("b      = %h", dut.b);

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a + b  = %h", dut.add_out);

    #10;
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a - b  = %h", dut.sub_out);

    #10;
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a x b  = %h", dut.mul_out);

    #10;
    $display("a / b  = %f", to_real(dut.div_out));
    $display("a / b  = %h", dut.div_out);

    // Now reuse results like your original TB
    #10 dut.a = dut.b;
        dut.b = dut.mul_out;

    $display("a      = %f", to_real(dut.a));
    $display("b      = %f", to_real(dut.b));

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a / b  = %f", to_real(dut.div_out));
$display("a      = %f", to_real(dut.a));
    $display("a      = %h", dut.a);
    $display("b      = %f", to_real(dut.b));
    $display("b      = %h", dut.b);

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a + b  = %h", dut.add_out);

    #10;
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a - b  = %h", dut.sub_out);

    #10;
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a x b  = %h", dut.mul_out);

    #10;
    $display("a / b  = %f", to_real(dut.div_out));
    $display("a / b  = %h", dut.div_out);

    // Now reuse results like your original TB
    #10 dut.a = dut.b;
        dut.b = dut.mul_out;

    $display("a      = %f", to_real(dut.a));
    $display("b      = %f", to_real(dut.b));

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a / b  = %f", to_real(dut.div_out));

    $display("a      = %f", to_real(dut.a));
    $display("a      = %h", dut.a);
    $display("b      = %f", to_real(dut.b));
    $display("b      = %h", dut.b);

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a + b  = %h", dut.add_out);

    #10;
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a - b  = %h", dut.sub_out);

    #10;
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a x b  = %h", dut.mul_out);

    #10;
    $display("a / b  = %f", to_real(dut.div_out));
    $display("a / b  = %h", dut.div_out);

    // Now reuse results like your original TB
    #10 dut.a = dut.b;
        dut.b = dut.mul_out;

    $display("a      = %f", to_real(dut.a));
    $display("b      = %f", to_real(dut.b));

    #10;
    $display("a + b  = %f", to_real(dut.add_out));
    $display("a - b  = %f", to_real(dut.sub_out));
    $display("a x b  = %f", to_real(dut.mul_out));
    $display("a / b  = %f", to_real(dut.div_out));

    
    #20 $finish;
  end

endmodule
