module multiply(multiplicand, multiplier,multTurn, clock, out, multCompleted, multException);
    input [31:0] multiplicand, multiplier;
    input multTurn, clock;
    output [31:0] out;
    output multCompleted, multException;
    
    wire signed [64:0] productIn, productOut, startingProduct, product, shiftedProduct;
    wire signed [31:0] latchedMultiplicand, aluIn, aluOut;
    wire[5:0] count;
    wire  isSubtract, doNothing,instantiate65bits, overflow, isProductNeg, incompatableSigns, inSigns;

    //startingProduct = 0s on 32 MSBs, multiplier on next 32 bits, and 0 on LSB,
    assign startingProduct[64:33] = 32'b0; // pad zeros on upper 32 bits
    assign startingProduct[32:1] = multiplier;//multiplier goes on bottom 32 bits
    assign startingProduct[0] = 1'b0;//implicit 0

    //Determine whether we put starting product into our register or the product currently being used
    assign instantiate65bits = &(~count);//if count =0000(starting multiplication), then put starting product into register
    assign productIn = instantiate65bits ? startingProduct: shiftedProduct;//productAfterShiftmaybewrong
    //assign product = instantiate65bits ? startingProduct: shiftedProduct;
    //registers to hold and output our product and our multiplicand, are always write enabled*****CLRN MIGHT HAVE TO CHANGE****
    register64 p(.clk(clock), .in(productIn), .out(productOut), .clrn(1'b0), .we(1'b1));//clk, in, out, clrn, we
    register multiplicandReg(.clk(clock), .in(multiplicand),.out(latchedMultiplicand),.clrn(1'b0), .we(1'b1));//clk, in, out, clrn, we

    //Determines if we are adding, subtracting, or doing nothing, in which case we add 32'b0
    assign doNothing = &productOut[1:0] || &(~productOut[1:0]);
    assign isSubtract = productOut[1] & ~productOut[0];
    //assign doNothing = &product[1:0] || &(~product[1:0]);
    //assign isSubtract = product[1] & ~product[0];
    // add zero if last LSBs are 00 or 11
    assign aluIn = doNothing ? 32'b0: latchedMultiplicand; 
    

    // adding 32 MSBS in product to whatever we need to add/subtract/donothing
    multAlu blah(.data_operandA(productOut[64:33]), .data_operandB(aluIn), .data_result(aluOut), .isSub(isSubtract),.overflow(overflow));
    //assign shiftedProduct = $signed({aluOut, product[32:0]}) >>>1;
    assign shiftedProduct = $signed({{aluOut}, {productOut[32:0]}}) >>>1;

    //counter incremented by one at each clock 
    counter c(.clock(clock), .out(count), .clrn(multTurn));//clock, out, clrn
    assign multCompleted = count[5] & count[0];
    //assign multCompleted = &count;// , count[0] , count[1] , count[2] , count[3] , count[4]); // over when counter completed and reaches 11111
    assign out = multCompleted ? productOut[32:1] : 32'b0;
    xor(isProductNeg, multiplicand[31], multiplier[31]);
    xor (incompatableSigns, isProductNeg, out[31]);
    and (inSigns, |multiplicand, |multiplier, incompatableSigns);
    assign multException = ~((&productOut[64:33]) | (productOut[64:33] == 32'b0)) | overflow | inSigns;
endmodule