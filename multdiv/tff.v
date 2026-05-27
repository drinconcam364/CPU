module tff(t, clock, q, clrn);
    input t, clock, clrn;
    output q;
    wire tnot,qnot, w1, w2, w3, w4, ones;
    assign ones = 1'b1;
    not(tnot, t);// tnot = ~t;
    not(qnot, q);//assign qnot = ~q;
    and (w1, tnot, q);
    and (w2, t, qnot);
    or (w3, w1, w2);
    dffe_ref df0(q, w3, clock, ones, clrn);
endmodule