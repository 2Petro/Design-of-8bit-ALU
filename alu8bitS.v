module alu8bit (
input [7:0] X,
input [7:0] Y,
input [3:0] sel,
input i_clk,
input  R_W,
input i_rst_n,
output  [7:0] out,
output  OverFlow,
output  CarryOut,
output  ZeroFlag,
output  A_GR_B,
output  A_LS_B,
output  A_EQ_B
);

wire [7:0] w1;
wire [7:0] w2;
wire [7:0] w3;
wire [7:0] w4;
wire [7:0] w5;

eightBitALU alu(X,Y,{sel[1],sel[0]},OverFlow,CarryOut,ZeroFlag,A_GR_B,A_LS_B,A_EQ_B,w1);
eightbitlu el(X,Y,{sel[1],sel[0]},w2);
eightbitshfun sh(X,{~sel[1],~sel[0]},w3);


mux8b2_1 uy(w2,w3,sel[2],w4);
mux8b2_1 ux(w4,w1,~sel[3],w5);



active_low_asynch_rst_dff rg(out,R_W,w5,i_clk,i_rst_n);



endmodule





module eightbitshfun(
  input [7:0] A,
  input [1:0] sel,
  output [7:0] out
);

  wire [7:0] w1;
  wire [7:0] w2;
  wire [7:0] shf;
  wire right;
  wire left;

  and8b and1 (.A(A), .B({1'b0, {7{~sel[0]}}}), .out(w1));
  and8b and2 (.A(A), .B({{7{sel[0]}}, 1'b0}), .out(w2));

  buf buf1 (shf[0], w2[1]);
  buf buf2 (shf[7], w1[6]);

  genvar i;
  generate
  for(i=2;i<8;i=i+1) begin : eightbitshfun
  or or2 (shf[i - 1], w1[i - 2], w2[i]);

  end
  endgenerate

  and and3(right,sel[1],A[0],sel[0]);
  and and4(left,sel[1],A[7],~sel[0]);

  or8b or_rot (.A(shf), .B({right,6'b0,left}), .out(out));


endmodule

module eightbitlu(
  input [7:0] A,
  input [7:0] B,
  input [1:0] sel,
  output [7:0] out
);

wire [7:0] w1;
wire [7:0] w2;
wire [7:0] w3;
wire [7:0] w4;

    and8b and1(.A(A),.B(B),.out(w1));
    xor8b xor1(.A(A),.B(B),.out(w2));
    or8b  or1(.A(A),.B(B),.out(w3));
    not8b not1(.A(B),.out(w4));


    mux8b4x1 mx1(.out(out),.A(w1),.B(w2),.C(w3),.D(w4),.s0(sel[1]),.s1(sel[0]));

endmodule


module eightBitALU (
    input [7:0] A,
    input [7:0] B,
    input [1:0] sel,
    output OverFlow,
    output CarryOut,
    output ZeroFlag,
    output A_GR_B,
    output A_LS_B,
    output A_EQ_B,
    output  [7:0] out
);

wire [7:0] out1;
wire [7:0] out2;
wire [7:0] out3;
wire ng,zf,cf,w1,w2,w3;
wire ng1,zf1,cf1,ww1,ww2,ww3;

signcom8bit sgn1(.A(A),.B(B),.Cin(sel[0]),.OverFlow(OverFlow),.CarryOut(CarryOut),.ZeroFlag(ZeroFlag),.A_GR_B(A_GR_B),.A_LS_B(A_LS_B),.A_EQ_B(A_EQ_B),.out(out1));

//signcom8bit sgn2(.A(A),.B(B),.Cin(1'b0),.OverFlow(ng1),.CarryOut(cf1),.ZeroFlag(zf1),.A_GR_B(ww1),.A_LS_B(ww2),.A_EQ_B(ww3),.out(out2));
signcom8bit sgn3(.A(8'b00000001),.B(~B),.Cin(1'b0),.OverFlow(ng),.CarryOut(cf),.ZeroFlag(zf),.A_GR_B(w1),.A_LS_B(w2),.A_EQ_B(w3),.out(out3));

mux8b4x1 mx1(.out(out),.A(out1),.B(out1),.C(8'b00000000),.D(out3),.s0(sel[1]),.s1(sel[0]));

endmodule

module signcom8bit(
    input  [7:0] A,
    input  [7:0] B,
    input  Cin,
    output OverFlow,
    output CarryOut,
    output ZeroFlag,
    output A_GR_B,
    output A_LS_B,
    output A_EQ_B,
    output [7:0] out
);

wire [7:0] w;
wire [7:0] Bxor;
wire [7:0] zw;
wire zf,wc1,wc2,wc3,wc4;

genvar i;
xor8b xort(.A(B),.B({8{Cin}}),.out(Bxor));

full_adder ad1(.A(A[0]), .B(Bxor[0]), .C(Cin), .sum(out[0]), .cout(w[0]));
generate
for (i = 1; i < 7; i = i + 1 ) begin :fulladder
        full_adder adz(.A(A[i]), .B(Bxor[i]), .C(w[i - 1]), .sum(out[i]), .cout(w[i]));
    end
endgenerate
full_adder ad2(.A(A[7]), .B(Bxor[7]), .C(w[6]), .sum(out[7]), .cout(w[7]));  //for the cout


not8b notz(.A(out),.out(zw));
and8_1b andz(.A(zw),.out(zf));
and and3(ZeroFlag,zf);


and co1(wc1,A[7],B[7],~out[7]);
and co2(wc2,~A[7],~B[7],out[7]);
xor cr(CarryOut,wc1,wc2);

xor xorov1(wc3,A[7],B[7]);
xor xorov2(wc4,out[7],A[7]);
and andov(OverFlow,wc3,wc4);

buf(A_LS_B,(A < B));
buf(A_EQ_B,ZeroFlag);
and and5(A_GR_B,~A_EQ_B,~A_LS_B);

endmodule

module active_low_asynch_rst_dff (
 output reg [0:7] o_q,
 input wire R_W,
 input wire [0:7] i_d,
 input wire i_clk,
 input wire i_rst_n
);

integer i;

always @ (posedge i_clk or negedge i_rst_n)
begin
 if (!i_rst_n)
 begin
 o_q <= 1'b0;
 end
 else
 begin

if (R_W)
   begin
    o_q <= i_d;
   end


 end
 end
endmodule

module full_adder(
input A,B,C,
output sum,cout
    );
  wire w1,c1,c2,c3,out1;
  xor x1(w1,A,B);
  xor x2(sum,w1,C);
  
  and a1(c1,A,B);
  and a2(c2,B,C);
  and a3(c3,A,C);
  
  or o1(out1,c1,c2);
  or o2(cout,out1,c3);
    
endmodule

module mux8b4x1 (
  output [7:0] out,
  input  [7:0] A,
  input  [7:0] B,
  input  [7:0] C,
  input  [7:0] D,
  input  s0, s1
);

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : mux_4x1
      mux_4x1 mx_inst (
        .out(out[i]),
        .A(A[i]),
        .B(B[i]),
        .C(C[i]),
        .D(D[i]),
        .s0(s0),
        .s1(s1)
      );
    end
  endgenerate

endmodule



module mux8b2_1 (
input [7:0] A,
input [7:0] B,
input sel,
output [7:0] out
);

genvar i;
generate
for(i=0;i<8;i=i+1) begin :  mux2_1
  mux2_1 mx1(.A(A[i]),.B(B[i]),.sel(sel),.out(out[i]));

end
endgenerate
endmodule



module mux2_1 (
input A,
input B,
input sel,
output out 
);

wire w1,w2,w3;

not g1(w1,sel);
and g2(w2,w1,A);
and g3(w3,sel,B);
or  g4(out,w2,w3);

endmodule


module mux_4x1(
output out,
input A, B, C, D, s0, s1
);

  wire s0n,s1n; //s0 not, s1 not
  wire w1,w2,w3,w4;

  not n0(s0n,s0);
  not n1(s1n,s1);

  and and1(w1,A,s0n,s1n);
  and and2(w2,B,s0n,s1);
  and and3(w3,C,s0,s1n);
  and and4(w4,D,s0,s1);

  or or1(out,w1,w2,w3,w4);

endmodule


module and8_1b (
input [7:0] A,
output out
);

and and1(out,A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7]);
endmodule


module not8b (
input [7:0] A,
output [7:0] out
);


genvar i;
generate
for(i=0;i<8;i=i+1) begin : not8b
not not8(out[i],A[i]);

end
endgenerate
endmodule


module xor8b (
input [7:0] A,
input [7:0] B,
output [7:0] out
);


genvar i;
generate
for(i=0;i<8;i=i+1) begin : xor8b
xor xor8(out[i],A[i],B[i]);

end
endgenerate
endmodule

module or8b (
input [7:0] A,
input [7:0] B,
output [7:0] out
);


genvar i;
generate
for(i=0;i<8;i=i+1) begin : or8b
or or8(out[i],A[i],B[i]);

end
endgenerate
endmodule

module and8b (
input [7:0] A,
input [7:0] B,
output [7:0] out
);


genvar i;
generate
for(i=0;i<8;i=i+1) begin : and8
and and8(out[i],A[i],B[i]);

end
endgenerate
endmodule

