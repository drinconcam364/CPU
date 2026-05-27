module aluControl(productOut, isSubtract, doNothing);
    input[64:0] productOut;
    output isSubtract, doNothing;
    wire bit0, bit1, nbit0, nbit1;
    assign bit0 = productOut[0];
    assign nbit0 = ~bit0;
    assign bit1 = productOut[1];
    assign nbit1 = ~bit1;
    //assign add = bit0 & nbit1;
    assign isSubtract = nbit0 & bit1;
    assign doNothing = (nbit0 & nbit1) || (bit0 & bit1);
endmodule