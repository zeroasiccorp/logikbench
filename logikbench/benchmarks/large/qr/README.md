# qr

**Source:** [rtl/qr.v](rtl/qr.v)

A fixed-point **QR decomposition** solver, `A = Q*R`, computed by **Givens
rotations implemented with CORDIC** on a Gentleman-Kung-style triangular
systolic array. Fills the linear-algebra (`solver`) gap in the suite.

## What it is

Given an `N x N` signed matrix `A`, `qr` produces the upper-triangular factor
`R` (the orthogonal `Q` is implicit in the applied rotation sequence). Each
sub-diagonal element is annihilated by a Givens rotation: a boundary cell finds
the rotation angle with a CORDIC in vectoring mode, and internal cells apply
that same angle to the rest of the two rows with a CORDIC in rotation mode. The
CORDIC gain is divided out per rotation so each transform is a true orthogonal
rotation and the Frobenius norm is preserved.

## Circuit

```
qr                top: parallel-load A, FSM sequences one Givens rotation per
                  cycle over the (pivot, row) pairs, drains upper-triangular R
+- qr_array           one rotation across two rows (combinational)
   +- qr_boundary     diagonal cell: CORDIC vectoring -> rotation angle (sigma)
   +- qr_internal     off-diagonal cell: CORDIC rotation + gain compensation
      +- qr_cordic    unrolled circular CORDIC (vectoring and rotation modes)
```

Internally the matrix is carried at `IW = DW+16` bits with `F = 8` fractional
bits (CORDIC needs fractional headroom to converge on integer-scale inputs) and
`M = 16` micro-rotations. The datapath assumes first-quadrant pivots (positive
diagonal), which holds for the well-conditioned, diagonally dominant matrices
this benchmark targets.

## Parameters

- `N`  -- matrix dimension (`N x N`); default `4`
- `DW` -- signed I/O word width; default `16`

## Testbench

`testbench/test_qr_smoke.v` is a self-checking smoke test (`lb sim`) that needs
no golden reference: it loads a fixed 4x4 diagonally dominant, positive-diagonal
integer matrix, runs the decomposition, and verifies (1) `R` is
upper-triangular (every strictly sub-diagonal entry is ~0) and (2) the Frobenius
norm is preserved (`sum(R^2) == sum(A^2)` within tolerance, i.e. `Q` is
orthogonal). Tolerances absorb CORDIC and fixed-point rounding. Prints
`PASSED`/`FAILED`.

## References

This `qr.v` is an original RTL implementation, written from the QR-decomposition
definition and the standard Givens-rotation (CORDIC) systolic-array
(Gentleman-Kung) architecture; it is not derived from a specific HDL source.

* W. M. Gentleman and H. T. Kung, "Matrix Triangularization by Systolic
  Arrays," Proc. SPIE Real-Time Signal Processing IV, 1981.
* J. E. Volder, "The CORDIC Trigonometric Computing Technique," IRE Trans.
  Electronic Computers, 1959.
* G. H. Golub and C. F. Van Loan, "Matrix Computations" (Givens rotations / QR).
