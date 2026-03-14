module alu8bitest();

    reg [7:0] X;
    reg [7:0] Y;
    reg [3:0] sel;
    reg i_clk;
    reg R_W;
    reg i_rst_n;
    wire OverFlow;
    wire CarryOut;
    wire ZeroFlag;
    wire A_GR_B;
    wire A_LS_B;
    wire A_EQ_B;
    wire [7:0] out;


alu8bit test(X,Y,sel,i_clk,R_W,i_rst_n,out,OverFlow,CarryOut,ZeroFlag,A_GR_B,A_LS_B,A_EQ_B);

initial begin
  i_clk=0;

     forever #1 i_clk = ~i_clk;
end

initial begin
  sel=4'b0;

     forever #4 sel = sel + 1;
end


initial 
begin

X=8'b0;
Y=8'b0;
sel=4'b0000;
R_W=0;
i_rst_n=0;


        $dumpfile("voter_tb.vcd");  // Waveform file
        $dumpvars(0, test);         // signals to plot (everything)

        $display("X Y sel  | out OF CF ZF A<B A>B A=B ");
        $display("-------------------------");

        $monitor("%b %b %b  | %b %b %b %b %b %b %b",X,Y,sel,out,OverFlow,CarryOut,ZeroFlag,A_LS_B,A_GR_B,A_EQ_B);


#1
i_rst_n=1;
R_W=1;


X=8'b00001111;
Y=8'b11110000;
#3
check(8'b11111111,3'b100);

X=8'b00001111;
Y=8'b11110000;
#3
check(8'b00011111,3'b000);


X=8'b00101000;
Y=8'b00010000;
#7
check(8'b11110000,3'bxxx);

                     //And
X=8'b01100101;
Y=8'b00100101;
#22
check(8'b00100101,3'bxxx);

                     //Xor
X=8'b01100111;
Y=8'b00100100;
#3
check(8'b01000011,3'bxxx);

                     //Or
X=8'b01100101;
Y=8'b00100100;
#3
check(8'b01100101,3'bxxx);

                     //Not (1's complement)
X=8'b01010101;
Y=8'b01010101;
#4
check(8'b10101010,3'bxxx);

                     //Rotate right
X=8'b01100101;
Y=8'b00100100;
#4
check(8'b10110010,3'bxxx);

                     //Rotate left
X=8'b01100101;
Y=8'b00100100;
#4
check(8'b11001010,3'bxxx);

                     //Right shift
X=8'b01100101;
Y=8'b00100100;
#4
check(8'b00110010,3'bxxx);

                     //Left shift
X=8'b01100101;
Y=8'b00100100;
#4
check(8'b11001010,3'bxxx);


    $finish;
end	  


task check(input [7:0] out_exp, input [2:0] flags);
begin

if(sel < 4'b0011) begin

if({out_exp,flags} == {out,OverFlow,CarryOut,ZeroFlag})
$display("test successfull out is %b out_exp is %b flags %b %b",out,out_exp,flags,{OverFlow,CarryOut,ZeroFlag});

else
$display("test failed out %b out_exp %b flags %b %btime %0t",out,out_exp,flags,{OverFlow,CarryOut,ZeroFlag},$time);
end

else begin

if(out_exp == out)
$display("test successfull out is %b out_exp is %b",out,out_exp);

else
$display("test failed out %b out_exp %b time %0t",out,out_exp,$time);
end

end
endtask

endmodule
