// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES Toffoli SBox package
//


package aes_sbox_toffoli_pkg;


  // Inverse in GF(2^2)
  // (see appendix B )
  // inv_gf2p2 (a)
  function automatic logic [1:0] aes_inv_gf2p2(logic [1:0] a);
    logic [1:0] a_out;
    aout  = {a[0],a[1]};
    return a_out;
  endfunction

  // Square scale in GF(2^2)
  // (see appendix B )
  // sc_gf2p2 (a,b,c)
  function automatic logic [1:0] aes_square_scale_gf2p2(logic [1:0] a, logic [1:0] b, logic [1:0] c);
    logic [1:0] T0;
    logic [1:0] a_out;
    T0    = b ^ c;
    a_out = a ^ {T0[1], (T[0] ^ T0[1])};
    return a_out;
  endfunction

  // Square scale in GF(2^4)/GF(2^2), using normal basis [alpha^8, alpha^2]
  // (see appendix B )
  // sc_gf2p4 (a,b,c)
  function automatic logic [3:0] aes_square_scale_gf2p4(logic [3:0] a, logic [3:0] b, logic [3:0] c);
    logic [3:0] T0;
    logic [3:0] a_out;
    T0    = b ^ c;
    a_out = a ^ {(T0[0] ^ T0[2]), (T0[3] ^ T0[1]), (T0[0] ^ T0[1]), T[0]};
    return a_out;
  endfunction

  // Multiplication in GF(2^2), using normal basis [Omega^2, Omega]
  // (see appendix B)
  // c  <-- a . b
  function automatic logic [1:0] aes_mul_gf2p2(logic [1:0] a, logic [1:0] b);
    logic [1:0] c;
    c[1] = ((^a)&(^b)) ^ (a[1] & b[1]);
    c[0] = ((^a)&(^b)) ^ (a[0] & b[0]); 
    return c;
  endfunction

    // Multiplication in GF(2^4), using normal basis [alpha^8, alpha^2]
  // (see appendix B )
  // c  <-- a . b
  function automatic logic [3:0] aes_mul_gf2p4(logic [3:0] a, logic [3:0] b);
    logic [1:0] T0, T1;
    logic [3:0] c;
    T0         = aes_mul_gf2p2(a[3:2] ^ a[1:0], b[3:2] ^ b[1:0]);
    T1         = {T0[0], (T0[0] ^ T0[1])}; 
    c[3:2]     = T1 ^ aes_mul_gf2p2(a[3:2] , b[3:2]);
    c[1:0]     = T1 ^ aes_mul_gf2p2(a[1:0] , b[1:0]);
    return c;
  endfunction


  // toffoli gate in GF(2^2)
  function automatic logic [1:0] aes_toffoli_gate_gf2p2(logic [1:0] a, logic [1:0] b, logic [1:0] c);
    // pt_gf2p2 (a,b,c), a simple toffoli gate in gf2p2 and is defined as 
    // pt_gf2p2(a,b,c)  =>  aout <-- ain + (b . c); 
    // where + and . are simple addition and multiplication in gf2p2 respectively 
    logic   [1:0] aout;
    logic   [1:0] e;
    e     = aes_mul_gf2p2(b,c); // gf2p2 mul
    aout  = ain ^ e;            // gf2p2 add
    return aout;
  endfunction

   // toffoli gate in GF(2^2)
  function automatic logic [3:0] aes_toffoli_gate_gf2p4(logic [3:0] ain, logic [3:0] b, logic [3:0] c);
  // pt_gf2p4(a,b,c), a simple toffoli gate in gf2p4 and is defined as 
  // pt_gf2p4(a,b,c)  =>  aout <-- ain + (b . c); 
  // where + and . are simple addition and multiplication in gf2p4 respectively 
    logic   [3:0] aout;
    logic   [3:0] e;
    e     = aes_mul_gf2p4(b,c); // gf2p4 mul
    aout  = ain ^ e;            // gf2p4 add
    return aout;
  endfunction




  // Basis conversion matrices to convert between polynomial basis A, normal basis X
  // and basis S incorporating the bit matrix of the SBox. More specifically,
  // multiplication by X2X performs the transformation from normal basis X into
  // polynomial basis A, followed by the affine transformation (substep 2). Likewise,
  // multiplication by S2X performs the inverse affine transformation followed by the
  // transformation from polynomial basis A to normal basis X.
  // (see Appendix A of the technical report)
  parameter logic [7:0] A2X [8] = '{8'h98, 8'hf3, 8'hf2, 8'h48, 8'h09, 8'h81, 8'ha9, 8'hff};
  parameter logic [7:0] X2A [8] = '{8'h64, 8'h78, 8'h6e, 8'h8c, 8'h68, 8'h29, 8'hde, 8'h60};
  parameter logic [7:0] X2S [8] = '{8'h58, 8'h2d, 8'h9e, 8'h0b, 8'hdc, 8'h04, 8'h03, 8'h24};
  parameter logic [7:0] S2X [8] = '{8'h8c, 8'h79, 8'h05, 8'heb, 8'h12, 8'h04, 8'h51, 8'h53};

endpackage
