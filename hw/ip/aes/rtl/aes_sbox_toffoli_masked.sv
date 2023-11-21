module aes_maksed_square_scale_gf2p2 
  (
    input   logic clk_i,
    input   logic rst_ni,

    input   logic [1:0] a0in,
    input   logic [1:0] a1in,
    input   logic [1:0] b0in,
    input   logic [1:0] b1in,
    input   logic [1:0] c0in,
    input   logic [1:0] c1in,

    output  logic [1:0] a0out,
    output  logic [1:0] a1out,
    output  logic [1:0] b0out,
    output  logic [1:0] b1out,
    output  logic [1:0] c0out,
    output  logic [1:0] c1out
    
  );
  // scs_gf2p2 (a0,a1,b0,b1,c0,c1) where scs_gf2p2 means masked square scale in GF(2^2), 
  // Its cricuit can be defined combination of two unmasked square scale implmentation in GF2p2 
  // as below, ref circuit 8.b 
  // sc_gf2p2 (a0,b0,c0), output a0temp 
  // sc_gf2p2 (a1,b1,c1), output a1temp

  logic [1:0] a0temp, a0temp_reg,  a0out_reg;
  logic [1:0] a1temp, a1temp_reg,  a1out_reg;
  logic [1:0]         b0temp_reg,  b0out_reg;
  logic [1:0]         b1temp_reg,  b1out_reg;
  logic [1:0]         c0temp_reg,  c0out_reg;
  logic [1:0]         c1temp_reg,  c1out_reg;

  // sc_gf2p4 (a0,b0,c0), output a0temp
  assign  a0temp       =   aes_square_scale_gf2p2(a0in,b0in,c0in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0temp_reg   <=    2'd0;
      b0temp_reg   <=    2'd0;
      c0temp_reg   <=    2'd0;    
    end
    else begin
      a0temp_reg   <=    a0temp;
      b0temp_reg   <=    b0in;
      c0temp_reg   <=    c0in;
    end
  end

  // sc_gf2p4 (a1,b1,c1), output a1temp
  assign  a1temp       =   aes_square_scale_gf2p2(a1in,b1in,c1in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
    a1temp_reg     <=    2'd0;
    b1temp_reg     <=    2'd0;
    c1temp_reg     <=    2'd0;
    end
    else begin
    a1temp_reg     <=    a1temp;
    b1temp_reg     <=    a1in;
    c1temp_reg     <=    c1in;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0out_reg     <=    2'd0;
      a1out_reg     <=    2'd0;
      b0out_reg     <=    2'd0;
      b1out_reg     <=    2'd0;
      c0out_reg     <=    2'd0;
      c1out_reg     <=    2'd0;

    end
    else begin
      a0out_reg     <=    a1temp_reg;
      a1out_reg     <=    b1temp_reg;
      b0out_reg     <=    b0temp_reg;
      b1out_reg     <=    b1temp_reg;
      c0out_reg     <=    c0temp_reg;
      c1out_reg     <=    c1temp_reg;
    end
  end
  
  //  assign output
  assign  {a0out,a1out}   =   {a0out_reg,a1out_reg};
  assign  {b0out,b1out}   =   {b0out_reg,b1out_reg};
  assign  {c0out,c1out}   =   {c0out_reg,c1out_reg};

endmodule

module aes_maksed_square_scale_gf2p4 
  (
    input   logic clk_i,
    input   logic rst_ni,

    input   logic [3:0] a0in,
    input   logic [3:0] a1in,
    input   logic [3:0] b0in,
    input   logic [3:0] b1in,
    input   logic [3:0] c0in,
    input   logic [3:0] c1in,

    output  logic [3:0] a0out,
    output  logic [3:0] a1out,
    output  logic [3:0] b0out,
    output  logic [3:0] b1out,
    output  logic [3:0] c0out,
    output  logic [3:0] c1out
    
  );
  // scs_gf2p4 (a0,a1,b0,b1,c0,c1) where scs_gf2p4 means masked square scale in GF(2^4), 
  // Its cricuit can be defined combination of two unmasked square scale implmentation in GF2p4 
  // as below, ref circuit 8.b 
  // sc_gf2p4 (a0,b0,c0), output a0temp 
  // sc_gf2p4 (a1,b1,c1), output a1temp

  logic [3:0] a0temp, a0temp_reg,  a0out_reg;
  logic [3:0] a1temp, a1temp_reg,  a1out_reg;
  logic [3:0]         b0temp_reg,  b0out_reg;
  logic [3:0]         b1temp_reg,  b1out_reg;
  logic [3:0]         c0temp_reg,  c0out_reg;
  logic [3:0]         c1temp_reg,  c1out_reg;

  // sc_gf2p4 (a0,b0,c0), output a0temp
  assign  a0temp       =   aes_square_scale_gf2p4(a0in,b0in,c0in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0temp_reg   <=    4'd0;
      b0temp_reg   <=    4'd0;
      c0temp_reg   <=    4'd0;    
    end
    else begin
      a0temp_reg   <=    a0temp;
      b0temp_reg   <=    b0in;
      c0temp_reg   <=    c0in;
    end
  end

  // sc_gf2p4 (a1,b1,c1), output a1temp
  assign  a1temp       =   aes_square_scale_gf2p4(a1in,b1in,c1in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
    a1temp_reg     <=    4'd0;
    b1temp_reg     <=    4'd0;
    c1temp_reg     <=    4'd0;
    end
    else begin
    a1temp_reg     <=    a1temp;
    b1temp_reg     <=    a1in;
    c1temp_reg     <=    c1in;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0out_reg     <=    4'd0;
      a1out_reg     <=    4'd0;
      b0out_reg     <=    4'd0;
      b1out_reg     <=    4'd0;
      c0out_reg     <=    4'd0;
      c1out_reg     <=    4'd0;

    end
    else begin
      a0out_reg     <=    a1temp_reg;
      a1out_reg     <=    b1temp_reg;
      b0out_reg     <=    b0temp_reg;
      b1out_reg     <=    b1temp_reg;
      c0out_reg     <=    c0temp_reg;
      c1out_reg     <=    c1temp_reg;
    end
  end
  
  //  assign output
  assign  {a0out,a1out}   =   {a0out_reg,a1out_reg};
  assign  {b0out,b1out}   =   {b0out_reg,b1out_reg};
  assign  {c0out,c1out}   =   {c0out_reg,c1out_reg};

endmodule

module aes_maksed_toffli_gf2p2 
  (
    input   logic clk_i,
    input   logic rst_ni,

    input   logic [1:0] a0in,
    input   logic [1:0] a1in,
    input   logic [1:0] b0in,
    input   logic [1:0] b1in,
    input   logic [1:0] c0in,
    input   logic [1:0] c1in,

    output  logic [1:0] a0out,
    output  logic [1:0] a1out,
    output  logic [1:0] b0out,
    output  logic [1:0] b1out,
    output  logic [1:0] c0out,
    output  logic [1:0] c1out

  );
  // pts_gf2p2 (a0,a1,b0,b1,c0,c1), a pts_gf2p2 means masked toffoli gate in GF(2^2), 
  // Its cricuit can be defined combination of four unmasked toffoli gate implmentation in GF2p4 
  // as below, ref circuit 5.a 
  // pt_gf2p2 (a0,b0,c0), output a0temp // modified: change ordr of b0c0 and b0c1, ref figure(6)
  // pt_gf2p2 (a0,b0,c1), output a0out
  // pt_gf2p2 (a1,b1,c1), output a1temp
  // pt_gf2p2 (a1,b1,c0), output a1out

  import aes_pkg::*;
  import  aes_sbox_toffoli_pkg::*;


  logic [1:0] a0temp, a0temp_reg, a0out_combo,  a0out_reg;
  logic [1:0] a1temp, a1temp_reg, a1out_combo,  a1out_reg;
  logic [1:0]         b0temp_reg,               b0out_reg;
  logic [1:0]         b1temp_reg,               b1out_reg;
  logic [1:0]         c0temp_reg,               c0out_reg;
  logic [1:0]         c1temp_reg,               c1out_reg;

  // pt_gf2p2 (a0,b0,c0), output a0temp 
  assign  a0temp       =   aes_toffoli_gate_gf2p2(a0in,b0in,c0in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0temp_reg   <=    2'd0;
      b0temp_reg   <=    2'd0;
      c0temp_reg   <=    2'd0;    
    end
    else begin
      a0temp_reg   <=    a0temp;
      b0temp_reg   <=    b0in;
      c0temp_reg   <=    c0in;
    end
  end

  // pt_gf2p2 (a1,b1,c1), output a1temp
  assign  a1temp       =   aes_toffoli_gate_gf2p2(a1in,b1in,c1in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
    a1temp_reg     <=    2'd0;
    b1temp_reg     <=    2'd0;
    c1temp_reg     <=    2'd0;
    end
    else begin
    a1temp_reg     <=    a1temp;
    b1temp_reg     <=    a1in;
    c1temp_reg     <=    c1in;
    end
  end

  // pt_gf2p2 (a0,b0,c1), output a0out
  assign  a0out_combo  =   aes_toffoli_gate_gf2p2(a0temp_reg,b0temp_reg,c1temp_reg);

  // pt_gf2p2 (a1,b1,c0), output a1out
  assign  a1out_combo  =   aes_toffoli_gate_gf2p2(a1temp_reg,b1temp_reg,c0temp_reg);   

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0out_reg     <=    2'd0;
      a1out_reg     <=    2'd0;
      b0out_reg     <=    2'd0;
      b1out_reg     <=    2'd0;
      c0out_reg     <=    2'd0;
      c1out_reg     <=    2'd0;

    end
    else begin
      a0out_reg     <=    a0out_combo;
      a1out_reg     <=    a1out_combo;
      b0out_reg     <=    b0temp_reg;
      b1out_reg     <=    b1temp_reg;
      c0out_reg     <=    c0temp_reg;
      c1out_reg     <=    c1temp_reg;
    end
  end
  
  //  assign output
  assign  {a0out,a1out}   =   {a0out_reg,a1out_reg};
  assign  {b0out,b1out}   =   {b0out_reg,b1out_reg};
  assign  {c0out,c1out}   =   {c0out_reg,c1out_reg};

endmodule

module aes_maksed_toffli_gate_gf2p4
  (
    input   logic clk_i,
    input   logic rst_ni,

    input   logic [3:0] a0in,
    input   logic [3:0] a1in,
    input   logic [3:0] b0in,
    input   logic [3:0] b1in,
    input   logic [3:0] c0in,
    input   logic [3:0] c1in,

    output  logic [3:0] a0out,
    output  logic [3:0] a1out,
    output  logic [3:0] b0out,
    output  logic [3:0] b1out,
    output  logic [3:0] c0out,
    output  logic [3:0] c1out

  );
  // pts_gf2p4 (a0,a1,b0,b1,c0,c1), a pts_gf2p4 means masked toffoli gate in GF(2^4),  figure (6)
  // Its cricuit can be defined combination of four unmasked toffoli gate implmentation in GF2p4 
  // as below, ref circuit 5.a 
  // pt_gf2p4 (a0,b0,c0)  output a0temp // modified: change order of b0c0 and b0c1, ref figure(6)
  // pt_gf2p4 (a0,b0,c1)  output a0out
  // pt_gf2p4 (a1,b1,c1)  output a1temp
  // pt_gf2p4 (a1,b1,c0)  output a1out
  import aes_pkg::*;
  import  aes_sbox_toffoli_pkg::*;


  logic [3:0] a0temp, a0temp_reg, a0out_combo,  a0out_reg;
  logic [3:0] a1temp, a1temp_reg, a1out_combo,  a1out_reg;
  logic [3:0]         b0temp_reg,               b0out_reg;
  logic [3:0]         b1temp_reg,               b1out_reg;
  logic [3:0]         c0temp_reg,               c0out_reg;
  logic [3:0]         c1temp_reg,               c1out_reg;


  // pt_gf2p4 (a0,b0,c0)  output a0temp
  assign  a0temp       =   aes_toffoli_gate_gf2p4(a0in,b0in,c0in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0temp_reg   <=    4'd0;
      b0temp_reg   <=    4'd0;
      c0temp_reg   <=    4'd0;    
    end
    else begin
      a0temp_reg   <=    a0temp;
      b0temp_reg   <=    b0in;
      c0temp_reg   <=    c0in;
    end
  end
 
  // pt_gf2p4 (a1,b1,c1)  output a1temp
  assign  a1temp       =   aes_toffoli_gate_gf2p4(a1in,b1in,c1in);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
    a1temp_reg     <=    4'd0;
    b1temp_reg     <=    4'd0;
    c1temp_reg     <=    4'd0;
    end
    else begin
    a1temp_reg     <=    a1temp;
    b1temp_reg     <=    a1in;
    c1temp_reg     <=    c1in;
    end
  end

  // pt_gf2p4 (a0,b0,c1)  output a0out
  assign  a0out_combo  =   aes_toffoli_gate_gf2p4(a0temp_reg,b0temp_reg,c1temp_reg);

  // pt_gf2p4 (a1,b1,c0)  output a1out
  assign  a1out_combo  =   aes_toffoli_gate_gf2p4(a1temp_reg,b1temp_reg,c0temp_reg);   

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)begin
      a0out_reg     <=    4'd0;
      a1out_reg     <=    4'd0;
      b0out_reg     <=    4'd0;
      b1out_reg     <=    4'd0;
      c0out_reg     <=    4'd0;
      c1out_reg     <=    4'd0;

    end
    else begin
      a0out_reg     <=    a0out_combo;
      a1out_reg     <=    a1out_combo;
      b0out_reg     <=    b0temp_reg;
      b1out_reg     <=    b1temp_reg;
      c0out_reg     <=    c0temp_reg;
      c1out_reg     <=    c1temp_reg;
    end
  end
  
  //  assign output
  assign  {a0out,a1out}   =   {a0out_reg,a1out_reg};
  assign  {b0out,b1out}   =   {b0out_reg,b1out_reg};
  assign  {c0out,c1out}   =   {c0out_reg,c1out_reg};


endmodule

module  aes_masked_toffoli_inverse_gf2p8 
  (
    input   logic       clk_i,
    input   logic       rst_ni,

    input   logic [7:0] x0  ,
    input   logic [7:0] x1  ,
    input   logic [3:0] a0  ,
    input   logic [1:0] b0  ,
    input   logic [3:0] c0  ,
    input   logic [7:0] d0  ,
    output  logic [7:0] e0  ,
    output  logic [3:0] f0  ,
    output  logic [1:0] g0  ,
    output  logic [4:0] h0  ,
    output  logic [7:0] y0  ,
    output  logic [7:0] y1  
  ) ;     
  
  import aes_pkg::*;
  import  aes_sbox_toffoli_pkg::*;  

  logic   [3:0] a1,a0_mul,a1_mul;
  logic   [1:0] b1,b0_mul,b1_mul,b0_sc,b1_sc;
  logic   [3:0] c1,c0_mul0,c1_mul0;
  logic   [7:0] d1,d0_mul0,d1_mul0,d0_mul1,d1_mul1;
  logic   [7:0] e1;
  logic   [3:0] f1;
  logic   [1:0] g1;
  logic   [3:0] h1;
  logic   [1:0] inv_gf2p2;
  

  /////////////
  // cloning //
  /////////////
  assign  {a1,b1,c1,d1}  = {a0,b0,c0,d0};

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (a0,a1,x0_H,x1_H,x0_L,x1_L) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(a0),
    .a1in(a1),
    .b0in(b0),
    .b1in(b1),
    .c0in(c0),
    .c1in(c1),

    .a0out(a0_mul),
    .a1out(a1_mul),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //    masked gf2p4 square scale   //
  //////////////////////////////////// 
  // scs_gf2p4 (a0,a1,x0_H,x1_H,x0_L,x1_L) where scs_gf2p4 means masked square scale in GF(2^4), 
  
  aes_maksed_square_scale_gf2p4 u_aes_maksed_square_scale_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (b0,b1,a0_H,a1_H,a0_L,a1_L) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //    masked gf2p2 square scale   //
  //////////////////////////////////// 
  // scs_gf2p2 (b0,b1,a0_H,a1_H,a0_L,a1_L) where scs_gf2p2 means masked square scale in GF(2^2), 
  
  aes_maksed_square_scale_gf2p2 u_aes_maksed_square_scale_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //         gf2p2 inverse          //
  //////////////////////////////////// 
  // inv_gf2p2 (b0) where inv_gf2p2 means inverse in GF(2^2), 
  aes_inv_gf2p2();
  // inv_gf2p2 (b1) where inv_gf2p2 means inverse in GF(2^2), 
  aes_inv_gf2p2();

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (c0_H,c1_H,a0_L,a1_L,b0,b1) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (c0_L,c1_L,a0_H,a1_H,b0,b1) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (d0_H,d1_H,x0_L,x1_L,c0,c1) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (d0_L,d1_L,x0_H,x1_H,c0,c1) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(),
    .a1in(),
    .b0in(),
    .b1in(),
    .c0in(),
    .c1in(),

    .a0out(),
    .a1out(),
    .b0out(),
    .b1out(),
    .c0out(),
    .c1out()
  );

endmodule







module aes_sbox_toffoli_masked (
  input  aes_pkg::ciph_op_e op_i,
  input  logic [7:0]        data_i, // masked, the actual input data is data_i ^ mask_i (x0)
  input  logic [7:0]        mask_i, // input mask, independent from actual input data   (x1)
  input  logic [3:0]        a0_i,   // random number
  input  logic [1:0]        b0_i,   // random number 
  input  logic [3:0]        c0_i,   // random number
  input  logic [7:0]        d0_i,   // random number
  output logic [3:0]        e0_o,   // output to be used as input for next sbox as random number
  output logic [1:0]        f0_o,   // output to be used as input for next sbox as random number
  output logic [3:0]        g0_o,   // output to be used as input for next sbox as random number
  output logic [7:0]        h0_o,   // output to be used as input for next sbox as random number
  output logic [7:0]        data_o, // masked, the actual output data is data_o ^ mask_o  (y0)
  output logic [7:0]        mask_o  // output mask                                        (y1)
);

  import aes_pkg::*;
  import  aes_sbox_toffoli_pkg::*;

  //////////////////////////
  // Masked Toffoli SBox //
  //////////////////////////

  logic [7:0] in_data_basis_x, out_data_basis_x;
  logic [7:0] in_mask_basis_x, out_mask_basis_x;


  // |``(x)  linear transformation 
  // Convert data to normal basis X. (only doing forward sbox computation for now)
  assign in_data_basis_x = (op_i == CIPH_FWD) ? aes_mvm(data_i, A2X)         :
                                                aes_mvm(data_i, A2X);

  // Convert mask to normal basis X. (only doing forward sbox computation for now)
  assign in_mask_basis_x = (op_i == CIPH_FWD) ? aes_mvm(data_i, A2X)         :
                                                aes_mvm(data_i, A2X);        

  // Inversion in gf2^8 using toffoli gate implementation
  aes_masked_toffoli_inverse_gf2p8 u_aes_masked_toffoli_inverse_gf2p8
  (
    .x0(in_data_basis_x),
    .x1(in_mask_basis_x),
    .a0(a0_i),
    .b0(b0_i),
    .c0(c0_i),
    .d0(d0_i),
    .e0(e0_o),
    .f0(f0_o),
    .g0(g0_o),
    .h0(h0_o),
    .y0(out_data_basis_x),
    .y1(out_mask_basis_x)
  ) ;            

  
  // E(x) linear transformation
  // Convert to basis S 
  assign data_o = (op_i == CIPH_FWD) ? (aes_mvm(out_data_basis_x, X2S) ^ 8'h63) :
                                       (aes_mvm(out_data_basis_x, X2S) ^ 8'h63);            

  assign mask_o = (op_i == CIPH_FWD) ? aes_mvm(out_mask_basis_x, X2S)           :
                                       aes_mvm(out_mask_basis_x, X2S) ;            



endmodule