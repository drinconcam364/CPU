module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;


	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] zeros, we, writePortDecoderOutput, r0out,r1out, r2out, r3out, r4out, r5out, r6out, r7out, r8out, r9out, r10out, r11out, r12out, r13out, r14out, r15out, r16out, r17out, r18out,r19out, r20out, r21out, r22out, r23out, r24out, r25out, r26out, r27out, r28out, r29out, r30out, r31out;
	wire zero;
	assign zeros = 32'b0;
	assign zero = 1'b0;
	decoder writePort(.ctrl_writeReg(ctrl_writeReg),.out(writePortDecoderOutput)); //ctrl_writeReg, out
	writeEnables w(.writePortDecoderOutput(writePortDecoderOutput), .ctrl_writeEnable(ctrl_writeEnable), .we(we)); //writePortDecoderOutput, ctrl_writeEnable, we
	register r0(.clk(clock), .in(data_writeReg), .out(r0out), .clrn(ctrl_reset), .we(we[0]));//clk, in, out, clrn, we
	register r1(.clk(clock), .in(data_writeReg), .out(r1out), .clrn(ctrl_reset), .we(we[1]));
	register r2 (.clk(clock), .in(data_writeReg), .out(r2out), .clrn(ctrl_reset), .we(we[2]));
	register r3 (.clk(clock), .in(data_writeReg), .out(r3out), .clrn(ctrl_reset), .we(we[3]));
	register r4 (.clk(clock), .in(data_writeReg), .out(r4out), .clrn(ctrl_reset), .we(we[4]));
	register r5 (.clk(clock), .in(data_writeReg), .out(r5out), .clrn(ctrl_reset), .we(we[5]));
	register r6 (.clk(clock), .in(data_writeReg), .out(r6out), .clrn(ctrl_reset), .we(we[6]));
	register r7 (.clk(clock), .in(data_writeReg), .out(r7out), .clrn(ctrl_reset), .we(we[7]));
	register r8 (.clk(clock), .in(data_writeReg), .out(r8out), .clrn(ctrl_reset), .we(we[8]));
	register r9 (.clk(clock), .in(data_writeReg), .out(r9out), .clrn(ctrl_reset), .we(we[9]));
	register r10 (.clk(clock), .in(data_writeReg), .out(r10out), .clrn(ctrl_reset), .we(we[10]));
	register r11 (.clk(clock), .in(data_writeReg), .out(r11out), .clrn(ctrl_reset), .we(we[11]));
	register r12 (.clk(clock), .in(data_writeReg), .out(r12out), .clrn(ctrl_reset), .we(we[12]));
	register r13 (.clk(clock), .in(data_writeReg), .out(r13out), .clrn(ctrl_reset), .we(we[13]));
	register r14 (.clk(clock), .in(data_writeReg), .out(r14out), .clrn(ctrl_reset), .we(we[14]));
	register r15 (.clk(clock), .in(data_writeReg), .out(r15out), .clrn(ctrl_reset), .we(we[15]));
	register r16 (.clk(clock), .in(data_writeReg), .out(r16out), .clrn(ctrl_reset), .we(we[16]));
	register r17 (.clk(clock), .in(data_writeReg), .out(r17out), .clrn(ctrl_reset), .we(we[17]));
	register r18 (.clk(clock), .in(data_writeReg), .out(r18out), .clrn(ctrl_reset), .we(we[18]));
	register r19 (.clk(clock), .in(data_writeReg), .out(r19out), .clrn(ctrl_reset), .we(we[19]));
	register r20 (.clk(clock), .in(data_writeReg), .out(r20out), .clrn(ctrl_reset), .we(we[20]));
	register r21 (.clk(clock), .in(data_writeReg), .out(r21out), .clrn(ctrl_reset), .we(we[21]));
	register r22 (.clk(clock), .in(data_writeReg), .out(r22out), .clrn(ctrl_reset), .we(we[22]));
	register r23 (.clk(clock), .in(data_writeReg), .out(r23out), .clrn(ctrl_reset), .we(we[23]));
	register r24 (.clk(clock), .in(data_writeReg), .out(r24out), .clrn(ctrl_reset), .we(we[24]));
	register r25 (.clk(clock), .in(data_writeReg), .out(r25out), .clrn(ctrl_reset), .we(we[25]));
	register r26 (.clk(clock), .in(data_writeReg), .out(r26out), .clrn(ctrl_reset), .we(we[26]));
	register r27 (.clk(clock), .in(data_writeReg), .out(r27out), .clrn(ctrl_reset), .we(we[27]));
	register r28 (.clk(clock), .in(data_writeReg), .out(r28out), .clrn(ctrl_reset), .we(we[28]));
	register r29 (.clk(clock), .in(data_writeReg), .out(r29out), .clrn(ctrl_reset), .we(we[29]));
	register r30 (.clk(clock), .in(data_writeReg), .out(r30out), .clrn(ctrl_reset), .we(we[30]));
	register r31 (.clk(clock), .in(data_writeReg), .out(r31out), .clrn(ctrl_reset), .we(we[31]));
	mux_32 readRegA(data_readRegA, ctrl_readRegA, zeros,r1out, r2out, r3out, r4out, r5out, r6out, r7out, r8out, r9out, r10out, r11out, r12out, r13out, r14out, r15out, r16out, r17out, r18out,r19out, r20out, r21out, r22out, r23out, r24out, r25out, r26out, r27out, r28out, r29out, r30out, r31out); //out, select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31
	mux_32 readRegB(data_readRegB, ctrl_readRegB, zeros,r1out, r2out, r3out, r4out, r5out, r6out, r7out, r8out, r9out, r10out, r11out, r12out, r13out, r14out, r15out, r16out, r17out, r18out,r19out, r20out, r21out, r22out, r23out, r24out, r25out, r26out, r27out, r28out, r29out, r30out, r31out);
endmodule
