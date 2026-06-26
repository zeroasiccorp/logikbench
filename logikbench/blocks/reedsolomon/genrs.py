#!/usr/bin/env python3
# Computes and prints the GF(2^10) constant tables baked into the RS(544,514)
# RTL: the generator polynomial g(x), the syndrome powers alpha^i, and the Chien
# constants K[j]=alpha^(-(N-1)*j) and alpha^j. Run it to reproduce/verify the
# localparam values in rs_enc.v, rs_syndrome.v and rs_dec.v. The RTL itself
# carries the constants directly (no generated file is required to build).
#
# Field: GF(2^10), primitive polynomial p(x)=x^10+x^3+1 (0x409), alpha=2,
# first consecutive root FCR=0, n=544, k=514, 2t=30, t=15.

PRIM = 0x409
M = 10
NN = (1 << M) - 1
TWOT = 30
N = 544


def gf_mul(a, b):
    r = 0
    while b:
        if b & 1:
            r ^= a
        b >>= 1
        a <<= 1
        if a & (1 << M):
            a ^= PRIM
    return r


ALOG = [0] * (NN + 1)
LOG = [0] * (1 << M)
_x = 1
for _i in range(NN):
    ALOG[_i] = _x
    LOG[_x] = _i
    _x = gf_mul(_x, 2)
ALOG[NN] = 1


def apow(e):
    return ALOG[e % NN]


def gen_poly():
    g = [1]
    for i in range(TWOT):
        root = apow(i)
        ng = [0] * (len(g) + 1)
        for j in range(len(g)):
            ng[j + 1] ^= g[j]
            ng[j] ^= gf_mul(g[j], root)
        g = ng
    return g


def fmt(vals):
    return ';'.join("10'd%d" % v for v in vals)


def main():
    g = gen_poly()
    assert g[TWOT] == 1
    print("g(x) coeffs g[0..29] (rs_enc GPOLY):")
    print("  " + fmt(g[:TWOT]))
    print("syndrome powers alpha^i, i=0..29 (rs_syndrome APOW):")
    print("  " + fmt([apow(i) for i in range(TWOT)]))
    print("Chien K[j]=alpha^(-(N-1)*j), j=0..15 (rs_dec KCON):")
    print("  " + fmt([apow(-(N - 1) * j) for j in range(16)]))
    print("Chien step alpha^j, j=0..15 (rs_dec AJCON):")
    print("  " + fmt([apow(j) for j in range(16)]))
    print("alpha^-1 = %d (AINV), alpha^(N-1) = %d (XINIT)"
          % (apow(-1), apow(N - 1)))


if __name__ == "__main__":
    main()
