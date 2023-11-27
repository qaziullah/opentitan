module aes_reg_delay_block 
#(
  parameter NUM_CYCLES  =   2,
  parameter DATA_WIDTH  =   4
)(
  input logic   clk_i,
  input logic   rst_ni,

  input   logic   [DATA_WIDTH-1:0] data_i,
  output  logic   [DATA_WIDTH-1:0] data_o
);

  logic [DATA_WIDTH-1:0] data_reg [NUM_CYCLES];

always_ff @(posedge clk_i or negedge rst_ni) begin
  if(~rst_ni) begin
    for(int i =0; i<NUM_CYCLES; i++)begin :delay_block
    data_reg[i] <=  'd0;
    end
  end
  else begin
    data_reg[0] <=  data_i;
    for(int j =1; j<NUM_CYCLES; j++)begin :delay_block
      data_reg[j] <= data_reg[j-1]; 
    end
  end
end
assign  data_o  = data_reg[NUM_CYCLES-1];

endmodule


module aes_maksed_square_scale_gf2p2 
  (
    input   logic [1:0] a0in,
    input   logic [1:0] a1in,
    input   logic [1:0] b0in,
    input   logic [1:0] b1in,
    input   logic [1:0] c0in,
    input   logic [1:0] c1in,

    output  logic [1:0] a0out,
    output  logic [1:0] a1out
    
  );
  import aes_sbox_toffoli_pkg::*;
  // scs_gf2p2 (a0,a1,b0,b1,c0,c1) where scs_gf2p2 means masked square scale in GF(2^2), 
  // Its cricuit can be defined combination of two unmasked square scale implmentation in GF2p2 
  // as below, ref circuit 8.b 
  // sc_gf2p2 (a0,b0,c0), output a0temp 
  // sc_gf2p2 (a1,b1,c1), output a1temp

  logic [1:0] a0temp;
  logic [1:0] a1temp;

  // sc_gf2p4 (a0,b0,c0), output a0temp
  assign  a0temp       =   aes_square_scale_gf2p2(a0in,b0in,c0in);

  // sc_gf2p4 (a1,b1,c1), output a1temp
  assign  a1temp       =   aes_square_scale_gf2p2(a1in,b1in,c1in);

  //  assign output
  assign  {a0out,a1out}   =   {a0temp,a1temp};

endmodule

module aes_maksed_square_scale_gf2p4 
  (

    input   logic [3:0] a0in,
    input   logic [3:0] a1in,
    input   logic [3:0] b0in,
    input   logic [3:0] b1in,
    input   logic [3:0] c0in,
    input   logic [3:0] c1in,

    output  logic [3:0] a0out,
    output  logic [3:0] a1out
    
  );
  import aes_sbox_toffoli_pkg::*;

  // scs_gf2p4 (a0,a1,b0,b1,c0,c1) where scs_gf2p4 means masked square scale in GF(2^4), 
  // Its cricuit can be defined combination of two unmasked square scale implmentation in GF2p4 
  // as below, ref circuit 8.b 
  // sc_gf2p4 (a0,b0,c0), output a0temp 
  // sc_gf2p4 (a1,b1,c1), output a1temp

  logic [3:0] a0temp;
  logic [3:0] a1temp;

  // sc_gf2p4 (a0,b0,c0), output a0temp
  assign  a0temp       =   aes_square_scale_gf2p4(a0in,b0in,c0in);
 
  // sc_gf2p4 (a1,b1,c1), output a1temp
  assign  a1temp       =   aes_square_scale_gf2p4(a1in,b1in,c1in);

  //  assign output
  assign  {a0out,a1out}   =   {a0temp,a1temp};

endmodule

module aes_maksed_toffli_gate_gf2p2 
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
    b1temp_reg     <=    b1in;
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
    b1temp_reg     <=    b1in;
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
    output  logic [3:0] h0  ,
    output  logic [7:0] y0  ,
    output  logic [7:0] y1  
  ) ;     

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
  


  // variables for registering e, f, g, and h
  // pre_i_x means value of x variable i cycles eairler 
  //    (equal to the latency of one mult unit)
    logic   [7:0] pre_2_e0,           pre_6_e0;
    logic   [7:0] pre_2_e1,           pre_6_e1;
    logic   [3:0] pre_2_f0, pre_4_f0, pre_6_f0;
    logic   [3:0] pre_2_f1, pre_4_f1, pre_6_f1;
    logic   [1:0] pre_2_g0, pre_4_g0          ;
    logic   [1:0] pre_2_g1, pre_4_g1          ;
    logic   [3:0] pre_2_h0                    ;
    logic   [3:0] pre_2_h1                    ;

  // variables for registering b, c, and d
  // post_i_x mean value of x variable i cycles after  
  //    (equal to  the latency of one mult unit)
    logic   [1:0] post_2_b0;
    logic   [1:0] post_2_b1;
    logic   [3:0] post_4_c0;
    logic   [3:0] post_4_c1;
    logic   [7:0] post_6_d0;
    logic   [7:0] post_6_d1;


  // propogating signals e, f, g to the end 
    // propogate e
    aes_reg_delay_block 
    #(
      .NUM_CYCLES (4),
      .DATA_WIDTH ($bits(pre_6_e0))
    ) reg_delay_pre_2_e0_inst (
      .clk_i  (clk_i  ),
      .rst_ni (rst_ni ),

      .data_i(pre_6_e0),
      .data_o(pre_2_e0)
    );

      aes_reg_delay_block 
    #(
      .NUM_CYCLES (4),
      .DATA_WIDTH ($bits(pre_6_e1))
    ) reg_delay_pre_2_e1_inst (
      .clk_i  (clk_i  ),
      .rst_ni (rst_ni ),

      .data_i(pre_6_e1),
      .data_o(pre_2_e1)
    );

    // propogate f
      // pre_2_f -> f  
        aes_reg_delay_block 
        #(
          .NUM_CYCLES (2),
          .DATA_WIDTH ($bits(pre_2_f0))
        ) reg_delay_f0_inst (
          .clk_i  (clk_i  ),
          .rst_ni (rst_ni ),

          .data_i(pre_2_f0),
          .data_o(f0      )
        );

        aes_reg_delay_block 
        #(
          .NUM_CYCLES (2),
          .DATA_WIDTH ($bits(pre_2_f1))
        ) reg_delay_f1_inst (
          .clk_i  (clk_i  ),
          .rst_ni (rst_ni ),

          .data_i(pre_2_f1),
          .data_o(f1      )
        ); 
    
    // propogate g
      // pre_2_g -> g  
        aes_reg_delay_block 
        #(
          .NUM_CYCLES (2),
          .DATA_WIDTH ($bits(pre_2_g0))
        ) reg_delay_g0_inst (
          .clk_i  (clk_i  ),
          .rst_ni (rst_ni ),

          .data_i(pre_2_g0),
          .data_o(g0      )
        );

        aes_reg_delay_block 
        #(
          .NUM_CYCLES (2),
          .DATA_WIDTH ($bits(pre_2_g1))
        ) reg_delay_g1_inst (
          .clk_i  (clk_i  ),
          .rst_ni (rst_ni ),

          .data_i(pre_2_g1),
          .data_o(g1      )
        ); 

  // propogating signals b, c, d to the end   
    // propogate b
      aes_reg_delay_block 
      #(
        .NUM_CYCLES (2),
        .DATA_WIDTH ($bits(post_2_b0))
      ) reg_delay_post_2_b0_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(b0       ),
        .data_o(post_2_b0)
      );

        aes_reg_delay_block 
      #(
        .NUM_CYCLES (2),
        .DATA_WIDTH ($bits(post_2_b1))
      ) reg_delay_post_2_b1_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(b1       ),
        .data_o(post_2_b1)
      );
    // propogate c
      aes_reg_delay_block 
      #(
        .NUM_CYCLES (4),
        .DATA_WIDTH ($bits(post_4_c0))
      ) reg_delay_post_4_c0_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(c0       ),
        .data_o(post_4_c0)
      );

        aes_reg_delay_block 
      #(
        .NUM_CYCLES (4),
        .DATA_WIDTH ($bits(post_4_c1))
      ) reg_delay_post_4_c1_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(c1       ),
        .data_o(post_4_c1)
      );
    // propogate d
      aes_reg_delay_block 
      #(
        .NUM_CYCLES (6),
        .DATA_WIDTH ($bits(post_6_d0))
      ) reg_delay_post_6_d0_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(d0       ),
        .data_o(post_6_d0)
      );

        aes_reg_delay_block 
      #(
        .NUM_CYCLES (6),
        .DATA_WIDTH ($bits(post_6_d1))
      ) reg_delay_post_6_d1_inst (
        .clk_i  (clk_i  ),
        .rst_ni (rst_ni ),

        .data_i(d1       ),
        .data_o(post_6_d1)
      );




  /////////////
  // cloning //
  /////////////
  assign  {a1,b1,c1,d1}  = {a0,b0,c0,d0};

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (a0,a1,x0_H,x1_H,x0_L,x1_L) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u0_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(a0            ),
    .a1in(a1            ),
    .b0in(x0[7:4]       ), // x0_H
    .b1in(x1[7:4]       ), // x1_H
    .c0in(x0[3:0]       ), // x0_L
    .c1in(x1[3:0]       ), // x1_L

    .a0out(a0_mul       ),
    .a1out(a1_mul       ),
    .b0out(pre_6_e0[7:4]),  // x0_H -> pre_6_e0_H        
    .b1out(pre_6_e1[7:4]),  // x1_H -> pre_6_e1_H 
    .c0out(pre_6_e0[3:0]),  // x0_L -> pre_6_e0_L
    .c1out(pre_6_e1[3:0])   // x1_L -> pre_6_e1_L
  );

  ////////////////////////////////////
  //    masked gf2p4 square scale   //
  //////////////////////////////////// 
  // scs_gf2p4 (a0,a1,x0_H,x1_H,x0_L,x1_L) where scs_gf2p4 means masked square scale in GF(2^4), 
  
  aes_maksed_square_scale_gf2p4 u_aes_maksed_square_scale_gf2p4 
  (
    .a0in(a0_mul       ),
    .a1in(a1_mul       ),
    .b0in(pre_6_e0[7:4]), // x0_H -> pre_6_e0_H
    .b1in(pre_6_e1[7:4]), // x1_H -> pre_6_e1_H
    .c0in(pre_6_e0[3:0]), // x0_L -> pre_6_e0_L
    .c1in(pre_6_e1[3:0]), // x1_L -> pre_6_e1_L

    .a0out(pre_6_f0    ), 
    .a1out(pre_6_f1    )  
  );

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (b0,b1,a0_H,a1_H,a0_L,a1_L) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u0_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(post_2_b0),
    .a1in(post_2_b1),
    .b0in(pre_6_f0[3:2]),
    .b1in(pre_6_f1[3:2]),
    .c0in(pre_6_f0[1:0]),
    .c1in(pre_6_f1[1:0]),

    .a0out(b0_mul),
    .a1out(b1_mul),
    .b0out(pre_4_f0[3:2]),
    .b1out(pre_4_f1[3:2]),
    .c0out(pre_4_f0[1:0]),
    .c1out(pre_4_f1[1:0])
  );

  ////////////////////////////////////
  //    masked gf2p2 square scale   //
  //////////////////////////////////// 
  // scs_gf2p2 (b0,b1,a0_H,a1_H,a0_L,a1_L) where scs_gf2p2 means masked square scale in GF(2^2), 
  
  aes_maksed_square_scale_gf2p2 u_aes_maksed_square_scale_gf2p2 
  (
    .a0in(b0_mul),
    .a1in(b1_mul),
    .b0in(pre_4_f0[3:2]),
    .b1in(pre_4_f1[3:2]),
    .c0in(pre_4_f0[1:0]),
    .c1in(pre_4_f1[1:0]),

    .a0out(b0_sc),
    .a1out(b1_sc)
  );

  ////////////////////////////////////
  //         gf2p2 inverse          //
  //////////////////////////////////// 
  // inv_gf2p2 (b0) where inv_gf2p2 means inverse in GF(2^2), 
  assign  pre_4_g0  =   aes_inv_gf2p2(b0_sc);
  // inv_gf2p2 (b1) where inv_gf2p2 means inverse in GF(2^2), 
  assign  pre_4_g1  =   aes_inv_gf2p2(b1_sc);

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (c0_H,c1_H,a0_L,a1_L,b0,b1) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u1_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(post_4_c0[3:2]),
    .a1in(post_4_c1[3:2]),
    .b0in(pre_4_f0 [1:0]),
    .b1in(pre_4_f1 [1:0]),
    .c0in(pre_4_g0      ),
    .c1in(pre_4_g1      ),

    .a0out(pre_2_h0[3:2]),
    .a1out(pre_2_h1[3:2]),
    .b0out(pre_2_f0[1:0]),
    .b1out(pre_2_f1[1:0]),
    .c0out(),               //  same output is already taken from the instance below , thus igonored here
    .c1out()                //  same output is already taken from the instance below , thus igonored here
  );

  ////////////////////////////////////
  //      masked gf2p2 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p2 (c0_L,c1_L,a0_H,a1_H,b0,b1) where pts_gf2p2 means masked toffoli gate in GF(2^2), 
  
  aes_maksed_toffli_gate_gf2p2 u2_aes_maksed_toffli_gate_gf2p2 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(post_4_c0[1:0]),
    .a1in(post_4_c1[1:0]),
    .b0in(pre_4_f0 [3:2]),
    .b1in(pre_4_f1 [3:2]),
    .c0in(pre_4_g0      ),
    .c1in(pre_4_g1      ),

    .a0out(pre_2_h0[1:0]),
    .a1out(pre_2_h1[1:0]),
    .b0out(pre_2_f0[3:2]),
    .b1out(pre_2_f1[3:2]),
    .c0out(pre_2_g0     ),
    .c1out(pre_2_g1     )
  );

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (d0_H,d1_H,x0_L,x1_L,c0,c1) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u1_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 
    .a0in(post_6_d0[7:4]),
    .a1in(post_6_d1[7:4]),
    .b0in(pre_2_e0 [3:0]),
    .b1in(pre_2_e1 [3:0]),
    .c0in(pre_2_h0      ),
    .c1in(pre_2_h1      ),

    .a0out(y0[7:4]),
    .a1out(y1[7:4]),
    .b0out(e0[3:0]),
    .b1out(e1[3:0]),
    .c0out(h0     ),
    .c1out(h1     )
  );

  ////////////////////////////////////
  //      masked gf2p4 mult         //
  // implemented using toffoli gate //
  //////////////////////////////////// 
  // pts_gf2p4 (d0_L,d1_L,x0_H,x1_H,c0,c1) where pts_gf2p4 means masked toffoli gate in GF(2^4), 
  
  aes_maksed_toffli_gate_gf2p4 u2_aes_maksed_toffli_gate_gf2p4 
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
 

    .a0in(post_6_d0[3:0]),
    .a1in(post_6_d1[3:0]),
    .b0in(pre_2_e0 [7:4]),
    .b1in(pre_2_e1 [7:4]),
    .c0in(pre_2_h0      ),
    .c1in(pre_2_h1      ),

    .a0out(y0[3:0]),
    .a1out(y1[3:0]),
    .b0out(e0[7:4]),
    .b1out(e1[7:4]),
    .c0out(),                 //  same output is already taken from the above instance, thus igonored here
    .c1out()                  //  same output is already taken from the above instance, thus igonored here
  );

endmodule







module aes_sbox_toffoli_masked #(
  parameter DECRYPTION = 0
  )(
  input  logic              clk_i,
  input  logic              rst_ni,

  input  logic [7:0]        data_i, // masked, the actual input data is data_i ^ mask_i (x0)
  input  logic [7:0]        mask_i, // input mask, independent from actual input data   (x1)
  input  logic [3:0]        a0_i,   // random number
  input  logic [1:0]        b0_i,   // random number 
  input  logic [3:0]        c0_i,   // random number
  input  logic [7:0]        d0_i,   // random number
  output logic [7:0]        e0_o,   // output to be used as input for next sbox as random number
  output logic [3:0]        f0_o,   // output to be used as input for next sbox as random number
  output logic [1:0]        g0_o,   // output to be used as input for next sbox as random number
  output logic [3:0]        h0_o,   // output to be used as input for next sbox as random number
  output logic [7:0]        data_o, // masked, the actual output data is data_o ^ mask_o  (y0)
  output logic [7:0]        mask_o  // output mask                                        (y1)
);

  import  aes_sbox_toffoli_pkg::*;

  //////////////////////////
  // Masked Toffoli SBox  //
  //////////////////////////

  logic [7:0] in_data_basis_x, out_data_basis_x;
  logic [7:0] in_mask_basis_x, out_mask_basis_x;

  generate
    if(DECRYPTION == 0) begin   // encryption module 
      // |``(x)  linear transformation 
      // Convert data to normal basis X. 
      assign  in_data_basis_x  = aes_mvm(data_i,A2X);
      assign  in_mask_basis_x  = aes_mvm(mask_i,A2X);
      // do the inversion in normal basis X
        // for inversion the aes inverse gf2p8 module is instantitated  
        // outside of the generate block one time, as it is common for   
        // both encyrption (forward sbox) and decryption (revserse sbox)

      // E_S(x) linear transformation
      // convert to basis S
      assign  data_o        = aes_mvm(out_data_basis_x, X2S) ^ 8'h63;
      assign  mask_o        = aes_mvm(out_mask_basis_x, X2S) ;
    end
    else   begin                // Decryption module
      // convert to normal basis X
      assign  in_data_basis_x  = aes_mvm(data_i ^ 8'h63,S2X);
      assign  in_mask_basis_x  = aes_mvm(mask_i,S2X);

      // do the inversion in normal basis X
        // for inversion the aes inverse gf2p8 module is instantitated  
        // outside of the generate block one time, as it is common for   
        // both encyrption (forward sbox) and decryption (revserse sbox)
      
      // E_A(x) linear transformation
      // convert to basis A
        assign  data_o        = aes_mvm(out_data_basis_x, X2A);
        assign  mask_o        = aes_mvm(out_mask_basis_x, X2A);
    end
  endgenerate 

  // Inversion in gf2^8 using toffoli gate implementation
  aes_masked_toffoli_inverse_gf2p8 u_aes_masked_toffoli_inverse_gf2p8
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),

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

endmodule