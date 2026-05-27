module decoder(ctrl_writeReg, out);
    input [4:0] ctrl_writeReg;
    output [31:0] out;
    assign out = 32'b1 << ctrl_writeReg;
endmodule
