module DFFtri(d, clk, clrn, prn, in_enable, out_enable, out);
    input d, clk, clr, pr, in_enable, out_enable;
    output out;
    wire q, clrn, prn;
    DFFE dff(.d(d), .clk(clk), .clrn(clrn), .prn(prn), .ena(in_enable), .q(q));
    assign out = out_enable ? q: 1'bz;
endmodule