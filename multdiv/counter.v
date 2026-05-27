module counter(clock, out, clrn);
    input clrn, clock;
    output [5:0] out;
    wire ones, w1,w2,w3,w4;
    assign ones = 1'b1;
    tff t0(.t(ones), .clock(clock), .q(out[0]), .clrn(clrn));//t, clock, q, clrn
    tff t1(.t(out[0]), .clock(clock), .q(out[1]), .clrn(clrn));
    and (w1, out[0], out[1]);
    tff t2(.t(w1), .clock(clock), .q(out[2]), .clrn(clrn));
    assign w2 = &out[2:0];//and (w2, out[0], out[1], out[2]);
    tff t3(.t(w2), .clock(clock), .q(out[3]), .clrn(clrn));
    assign w3 = &out[3:0];//and (w3, out[0], out[1], out[2], out[3]);
    tff t4(.t(w3), .clock(clock), .q(out[4]), .clrn(clrn));
    assign w4 = &out[4:0];
    tff t5(.t(w4), .clock(clock), .q(out[5]), .clrn(clrn));
endmodule