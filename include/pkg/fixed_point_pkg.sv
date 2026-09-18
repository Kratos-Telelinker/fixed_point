package fixed_point_pkg;

  // ============================================================
  // Parameters
  // ============================================================
  parameter int WIDTH = 12;
  parameter int FRAC  = 8;
  parameter int FIXED_STORAGE_WIDTH = 2*WIDTH;

  // ============================================================
  // Types
  // ============================================================
  typedef struct packed {
    logic signed [FIXED_STORAGE_WIDTH-1:0] value;
  } fixed_t;

  typedef enum logic [1:0] {
    ROUND_TRUNC,
    ROUND_NEAREST,
    ROUND_TOWARD_ZERO
  } round_mode_t;

  // ============================================================
  // Limits
  // ============================================================
  localparam logic signed [FIXED_STORAGE_WIDTH-1:0] MAX_VAL =
    ( (1 <<< (FIXED_STORAGE_WIDTH-1)) - 1 );
  localparam logic signed [FIXED_STORAGE_WIDTH-1:0] MIN_VAL =
    -(1 <<< (FIXED_STORAGE_WIDTH-1));

  // ============================================================
  // Rounding Helper (MUST appear before mul_rm)
  // ============================================================
  function automatic logic signed [FIXED_STORAGE_WIDTH-1:0]
    round_shift(
      input logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] x,
      input int shift,
      input round_mode_t mode
    );

    logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] adj;

    case (mode)
      ROUND_TRUNC:       adj = x;
      ROUND_NEAREST:     adj = x + (1 <<< (shift-1));
      ROUND_TOWARD_ZERO: adj = (x >= 0)
                                ? x
                                : (x + (1 <<< shift) - 1);
      default:           adj = x;
    endcase

    return adj >>> shift;
  endfunction

  // ============================================================
  // Conversions
  // ============================================================
  function automatic fixed_t from_int(input int i);
    fixed_t r;
    r.value = i <<< FRAC;
    return r;
  endfunction

  function automatic fixed_t from_real(input real x);
    fixed_t r;
    r.value = $rtoi(x * (1 << FRAC));
    return r;
  endfunction

  function automatic int to_int(input fixed_t a);
    return a.value >>> FRAC;
  endfunction

  function automatic real to_real(input fixed_t a);
    return a.value / real'(1 << FRAC);
  endfunction

  // ============================================================
  // Saturation
  // ============================================================
  function automatic fixed_t saturate(input logic signed [FIXED_STORAGE_WIDTH-1:0] x);
    fixed_t r;
    if (x > MAX_VAL)
      r.value = MAX_VAL;
    else if (x < MIN_VAL)
      r.value = MIN_VAL;
    else
      r.value = x;
    return r;
  endfunction

  // ============================================================
  // Arithmetic
  // ============================================================
  function automatic fixed_t add(input fixed_t a, b);
    fixed_t r;
    logic signed [FIXED_STORAGE_WIDTH-1:0] tmp;
    tmp = a.value + b.value;
    r = saturate(tmp);
    return r;
  endfunction

  function automatic fixed_t sub(input fixed_t a, b);
    fixed_t r;
    logic signed [FIXED_STORAGE_WIDTH-1:0] tmp;
    tmp = a.value - b.value;
    r = saturate(tmp);
    return r;
  endfunction

  function automatic fixed_t mul(input fixed_t a, b);
    logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] temp;
    fixed_t r;
    temp = a.value * b.value;
    r = saturate(temp >>> FRAC);
    return r;
  endfunction

  function automatic fixed_t mul_rm(
    input fixed_t a,
    input fixed_t b,
    input round_mode_t mode
  );
    logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] temp;
    fixed_t r;
    temp = a.value * b.value;
    r.value = round_shift(temp, FRAC, mode);
    r = saturate(r.value);
    return r;
  endfunction

  function automatic fixed_t div(input fixed_t a, b);
    fixed_t r;
    logic signed [(2*FIXED_STORAGE_WIDTH)-1:0] temp;
    temp = (a.value <<< FRAC) / b.value;
    r = saturate(temp[FIXED_STORAGE_WIDTH-1:0]);
    return r;
  endfunction

  // ============================================================
  // Nonlinear Functions
  // ============================================================
  function automatic fixed_t fsqrt(input fixed_t x);
    fixed_t y;
    y = from_int(1);

    for (int i = 0; i < 4; i++) begin
      fixed_t term1 = div(x, y);
      fixed_t sum   = add(y, term1);
      fixed_t half  = div(sum, from_int(2));
      y = half;
    end

    return y;
  endfunction

  function automatic fixed_t frecip(input fixed_t x);
    return div(from_int(1), x);
  endfunction

  // ============================================================
  // CORDIC Constants
  // ============================================================
  localparam int CORDIC_ITER = 16;

  localparam fixed_t cordic_atan_table [0:CORDIC_ITER-1] = '{
    from_real(0.7853981633974483),
    from_real(0.4636476090008061),
    from_real(0.2449786631268641),
    from_real(0.1243549945467614),
    from_real(0.06241880999595735),
    from_real(0.031239833430268277),
    from_real(0.015623728620476831),
    from_real(0.007812341060101111),
    from_real(0.0039062301319669718),
    from_real(0.0019531225164788188),
    from_real(0.0009765621895593195),
    from_real(0.0004882812111948983),
    from_real(0.00024414062014936177),
    from_real(0.00012207031189367021),
    from_real(0.00006103515617420877),
    from_real(0.000030517578115526096)
  };

  localparam fixed_t cordic_gain = from_real(0.607252935);

  // ============================================================
  // CORDIC sin/cos
  // ============================================================
  function automatic void cordic_sincos(
    input  fixed_t angle,
    output fixed_t cos_out,
    output fixed_t sin_out
  );

    fixed_t x, y, z;
    fixed_t x_new, y_new;

    x = cordic_gain;
    y = from_int(0);
    z = angle;

    for (int i = 0; i < CORDIC_ITER; i++) begin
      if (z.value >= 0) begin
        x_new.value = x.value - (y.value >>> i);
        y_new.value = y.value + (x.value >>> i);
        z.value     = z.value - cordic_atan_table[i].value;
      end else begin
        x_new.value = x.value + (y.value >>> i);
        y_new.value = y.value - (x.value >>> i);
        z.value     = z.value + cordic_atan_table[i].value;
      end

      x = x_new;
      y = y_new;
    end

    cos_out = x;
    sin_out = y;
  endfunction

endpackage

