package fixed_point_pkg;

  // Global fixed-point format
  localparam int WIDTH = 12;
  localparam int FRAC  = 8;

  localparam int FIXED_STORAGE_WIDTH = 24;

  typedef struct packed {
    logic signed [FIXED_STORAGE_WIDTH-1:0] value;
  } fixed_t;

  // Create from integer
  function automatic fixed_t from_int(input int i);
    fixed_t r;
    r.value = i <<< FRAC;
    return r;
  endfunction

  // Create from real
  function automatic fixed_t from_real(input real x);
    fixed_t r;
    r.value = $rtoi(x * (1 << FRAC));
    return r;
  endfunction

  // Convert to integer
  function automatic int to_int(input fixed_t a);
    return a.value >>> FRAC;
  endfunction

  // Convert to real
  function automatic real to_real(input fixed_t a);
    return a.value / real'(1 << FRAC);
  endfunction

  // Add
  function automatic fixed_t add(input fixed_t a, b);
    fixed_t r;
    r.value = a.value + b.value;
    return r;
  endfunction

  // Sub
  function automatic fixed_t sub(input fixed_t a, b);
    fixed_t r;
    r.value = a.value - b.value;
    return r;
  endfunction

  // Mul
  function automatic fixed_t mul(input fixed_t a, b);
    logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] temp;
    fixed_t r;
    temp = a.value * b.value;
    r.value = temp >>> FRAC;
    return r;
  endfunction

  // Div
  function automatic fixed_t div(input fixed_t a, b);
    fixed_t r;
    r.value = (a.value <<< FRAC) / b.value;
    return r;
  endfunction

endpackage
