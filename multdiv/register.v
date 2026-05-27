module register (clk, in, out, clrn, we);//d, clk, clrn, prn, in_enable, out_enable, out
    input [31:0] in;
    output [31:0] out;
    input clk, we, clrn;
    wire ena, zero;
    assign zero = 1'b0;
    assign ena = we;//dffe_ref
    dffe_ref d0 (.q(out[0]), .d(in[0]), .clk(clk), .en(ena), .clr(clrn));//q, d, clk, en, clr)
    dffe_ref d1 (.q(out[1]), .d(in[1]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d2 (.q(out[2]), .d(in[2]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d3 (.q(out[3]), .d(in[3]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d4 (.q(out[4]), .d(in[4]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d5 (.q(out[5]), .d(in[5]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d6 (.q(out[6]), .d(in[6]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d7 (.q(out[7]), .d(in[7]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d8 (.q(out[8]), .d(in[8]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d9 (.q(out[9]), .d(in[9]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d10 (.q(out[10]), .d(in[10]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d11 (.q(out[11]), .d(in[11]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d12 (.q(out[12]), .d(in[12]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d13 (.q(out[13]), .d(in[13]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d14 (.q(out[14]), .d(in[14]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d15 (.q(out[15]), .d(in[15]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d16 (.q(out[16]), .d(in[16]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d17 (.q(out[17]), .d(in[17]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d18 (.q(out[18]), .d(in[18]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d19 (.q(out[19]), .d(in[19]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d20 (.q(out[20]), .d(in[20]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d21 (.q(out[21]), .d(in[21]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d22 (.q(out[22]), .d(in[22]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d23 (.q(out[23]), .d(in[23]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d24 (.q(out[24]), .d(in[24]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d25 (.q(out[25]), .d(in[25]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d26 (.q(out[26]), .d(in[26]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d27 (.q(out[27]), .d(in[27]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d28 (.q(out[28]), .d(in[28]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d29 (.q(out[29]), .d(in[29]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d30 (.q(out[30]), .d(in[30]), .clk(clk), .en(ena), .clr(clrn));
    dffe_ref d31 (.q(out[31]), .d(in[31]), .clk(clk), .en(ena), .clr(clrn));
endmodule