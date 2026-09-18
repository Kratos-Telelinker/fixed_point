# SystemVerilog Fixed‑Point Math Library
## A reusable, hardware‑friendly fixed‑point math library implemented in SystemVerilog.
Includes arithmetic, division, square root, and CORDIC‑based trigonometric functions, packaged for FPGA/ASIC workflows and simulation environments.

## 📦 Package Overview — fixed_point_pkg.sv
The package defines:

fixed_t — packed struct representing Q‑format fixed‑point numbers

## Conversion helpers:

from_int(int)

from_real(real)

to_real(fixed_t)

Arithmetic helpers:

fadd, fsub, fmul, fdiv

## Math functions:

fsqrt — Newton‑Raphson square root

cordic_sincos — CORDIC rotation algorithm

## 📐 Q‑Format Explanation
 This library uses a configurable Qm.n fixed‑point format.


Bit Layout

   MSB                                          LSB
    ↓                                            ↓
┌──────┬──────────────────────┬──────────────────────┐
│ Sign │   Integer (m bits)   │   Fraction (n bits)  │
└──────┴──────────────────────┴──────────────────────┘
## Conversion Rules
fixed = real * 2^n
real  = fixed / 2^n
Example: Q4.12
[ S | IIII | FFFFFFFFFFFF ]
 1     4          12
This gives:

Range: −16.0 to +15.999755

Resolution: 1 / 4096 ≈ 0.000244
Top‑Level Module — fixed_point_top.sv
The top‑level module performs:

### Addition

### Subtraction

### Multiplication

### Division

### Valid‑in / valid‑out pipelining

## Port Diagram
                ┌──────────────────────────────┐
   a_in  ──────►│                              │──────► add_out
   b_in  ──────►│      fixed_point_top         │──────► sub_out
 valid_in ─────►│                              │──────► mul_out
                │                              │──────► div_out
                └──────────────────────────────┘
                             ▲
                             │
                         valid_out
## 🧪 Testbench — tb_fixed_point_top.sv
The testbench provides:

Clock + reset generation

Arithmetic stimulus

Square‑root test

CORDIC sin/cos test

Output monitoring

## Testbench Flow Diagram
┌──────────────┐
│  Reset DUT   │
└──────┬───────┘
       │
┌──────▼───────┐
│ Drive inputs │
└──────┬───────┘
       │
┌──────▼───────┐
│ Arithmetic   │
└──────┬───────┘
       │
┌──────▼───────┐
│ Square Root  │
└──────┬───────┘
       │
┌──────▼───────┐
│ CORDIC Test  │
└──────┬───────┘
       │
┌──────▼───────┐
│ Print Output │
└──────────────┘

## 📐 CORDIC Math — Sin/Cos via Vector Rotation
CORDIC computes sin/cos using iterative vector rotations.

Rotation Equation
x' = x - y·2^-i
y' = y + x·2^-i

Each iteration rotates the vector by a micro‑angle:
θ_i = atan(2^-i)

Total rotation:
θ = Σ θ_i

## CORDIC Pipeline Diagram
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Iter 0   │→→│ Iter 1   │→→│ Iter 2   │→→│ Iter N   │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
      │             │             │             │
      ▼             ▼             ▼             ▼
   x_0,y_0       x_1,y_1       x_2,y_2       x_N,y_N
After N iterations:
cos(θ) ≈ x_N
sin(θ) ≈ y_N
🧩 Usage Examples
Import the package
import fixed_point_pkg::*;
Cofixed_t a = from_real(3.14159);
nvert real → fixed

## Arithmetic
fixed_t c = fadd(a, b);
fixed_t d = fmul(a, b);

## Square Root
fixed_t r = fsqrt(from_real(2.0));

## CORDIC Sin/Cos
fixed_t angle = from_real(0.785398163); // 45 degrees
fixed_t cos_val, sin_val;

cordic_sincos(angle, cos_val, sin_val);

## 🛠 Vivado TCL Build Instructions
Create a file: build.tcl

## Create project
create_project fixed_point ./vivado -part xc7a35tcsg324-1

## Add RTL
add_files ./rtl/fixed_point_pkg.sv
add_files ./rtl/fixed_point_top.sv

## Add testbench
add_files -fileset sim_1 ./sim/tb/tb_fixed_point_top.sv

## Set top
set_property top fixed_point_top [current_fileset]

## Run simulation
launch_simulation

## Run it
vivado -mode batch -source build.tcl

## 📄 License
## MIT License




