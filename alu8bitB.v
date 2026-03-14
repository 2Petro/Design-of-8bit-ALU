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
eightbitshfun sh(X,{sel[1],sel[0]},w3);


mux16_8 uy(w2,w3,~sel[2],w4);
mux16_8 ux(w4,w1,sel[3],w5);



active_low_asynch_rst_dff rg(out,R_W,w5,i_clk,i_rst_n);



endmodule


module eightBitALU (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [1:0] sel,
    output reg OverFlow,
    output reg CarryOut,
    output reg ZeroFlag,
    output reg A_GR_B,
    output reg A_LS_B,
    output reg A_EQ_B,
    output reg [7:0] out
);
    reg [8:0] temp;
    reg temps;

    always @ (*)
    begin
        case (sel)
            2'b00:  // Addition
            begin
                temp = A + B;
		out  = temp[7:0];
            end
            2'b01:  // Subtraction
            begin
                temp = A - B;
                out  = temp[7:0];
            end
            2'b11:  // 2's complement
            begin
                out = ~B + 1;
            end
            default:
            begin
                out = 8'b0;  // Default case for undefined sel value
            end
        endcase

        // Set the flags based on the result
        //OverFlow = A[7] & B[7] & ~out[7];
	OverFlow = (A[7] ^ B[7]) & (out[7] ^ A[7]);
	CarryOut = (A[7] & B[7] & ~out[7]) | (~A[7] & ~B[7] & out[7]);
        ZeroFlag = (out == 0);
        A_GR_B = (A > B) ? 1 : 0;
        A_LS_B = (A < B) ? 1 : 0;
        A_EQ_B = (A == B) ? 1 : 0;
    end
    
endmodule

module eightbitshfun(
  input [7:0] A,
  input [1:0] sel,
  output reg [7:0] out
);

always @ (*)
  begin
  case (sel)
    2'b00: out = {A[0], A[7:1]}; // rotate right
    2'b01: out = A[7] ? {A[6:0], 1'b1} : {A[6:0], 1'b0}; // rotate left
    2'b10: out = {1'b0, A[7:1]}; // right shift
    2'b11: out = {A[6:0], 1'b0}; // left shift
    default: out = 8'b0; // default case
  endcase
end

endmodule

module eightbitlu(
  input [7:0] A,
  input [7:0] B,
  input [1:0] sel,
  output reg [7:0] out
);

always @ (*)
  begin
  case (sel)
    2'b00: out = A & B; // and
    2'b01: out = A ^ B; // xor
    2'b10: out = A | B; // or
    2'b11: out = ~B;    // one's complement of B
    default: out = 8'b0; // default case
  endcase
end

endmodule

module active_low_asynch_rst_dff ( 
 output reg [0:7] o_q,
 input wire R_W,
 input wire [0:7] i_d,
 input wire i_clk,
 input wire i_rst_n
);

//reg [0:15] data [0:15];
integer i;

always @ (posedge i_clk or negedge i_rst_n)
begin
 if (!i_rst_n)
 begin
 o_q <= 1'b0;
 end
 else
 begin
//  demuxregselect(addr_1,R_W,i_d,data);
//  muxregselect(addr_1,R_W,data,o_q);

if (R_W)
   begin
    o_q <= i_d;
   end


 end
 end
endmodule

module mux16_8 (
input wire [0:7] A,
input wire [0:7] B,
input wire sel,
output reg [0:7] out 
);

always @ (*)
begin

out = (sel) ? A : B;


end
endmodule
