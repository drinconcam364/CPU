module divide(dividend, divisor, clock, out, divException, divCompleted, divTurn);
    input [31:0] dividend, divisor;
    input clock,divTurn;
    output [31:0] out;
    output divException, divCompleted;

    wire isDividendNegative, isDivisorNegative, one, zero, isQuotientNegative, instantiateRQ, rMSB, q0, overflow1, overflow2, overflow3, overflow4;
    wire [31:0] r, unsignedDividend, unsignedDivisor, zeros, complementDividend, complementDivisor, latchedDivisor, restoredR, rMinusMresult, complementQuotient;
    wire [63:0] rqIn, rqOut, rqInitial, leftShiftedRQ;
    wire [5:0] count;

    assign zeros = 32'b0;
    assign one = 1'b1;
    assign zero = 1'b0;
    assign rqInitial[63:32] = zeros;
    assign rqInitial[31:0] = unsignedDividend;

    //get unsigned divisors and dividends
    assign isDividendNegative = dividend[31];
    assign isDivisorNegative = divisor[31];
    multAlu twosComplementDividend(zeros, dividend,complementDividend,one, overflow1);//data_operandA, data_operandB, data_result, isNotEqual, isLessThan, overflow, isSub)
    multAlu twosComplementDivisor(zeros, divisor, complementDivisor, one, overflow2);
    assign unsignedDividend = isDividendNegative ? complementDividend: dividend;
    assign unsignedDivisor = isDivisorNegative ? complementDivisor: divisor;

    //Determine whether we put starting rq into our register or the rq currently being used
    //and (instantiateRQ, ~count[0], ~count[1], ~count[2], ~count[3], ~count[4]);// if count =0000(starting multiplication), then put starting product into register
    assign instantiateRQ = &(~count);
    assign rqIn = instantiateRQ ? rqInitial: {{r}, {leftShiftedRQ[31:1]}, {q0}};//MAY BE WRONG

    // registers to store remainder/Quotient and divisor
    divRegister64 remainderQuotient(clock, rqIn, rqOut, zero, one);//clk, in, out, clrn, we
    register divisorReg(clock, unsignedDivisor, latchedDivisor, zero, one);//clk, in, out, clrn, we

    //counter incremented by one at each clock 
    counter divCounter(.clock(clock), .out(count), .clrn(divTurn));//clock, out, clrn

    //Restoring Algo
    assign leftShiftedRQ = rqOut << 1;//might need <<<  Shift Left RQ
    assign restoredR = leftShiftedRQ[63:32]; // R before subtraction if we need to restore it
    multAlu rMinusM(leftShiftedRQ[63:32], unsignedDivisor, rMinusMresult, one, overflow3); // R = R-M
    //assign copyOfrMinusMresult = rMinusMresult;
    assign rMSB = rMinusMresult[31];
    assign q0 = rMSB ? zero: one;
    assign r = rMSB? restoredR: rMinusMresult;
    //assign rMinusMresult = copyOfrMinusMresult[31]? restoredR : copyOfrMinusMresult;//if MSB of R = 1, restore R. if MSB of R=0,  keep R
    //assign q0 = rMinusMresult[31] ? zero: one;
    //assign QleftShiftedRQ = {{leftShiftedRQ[31:1]},{copyOfrMinusMresult[31] ? zero : one}};
    //assign leftShiftedRQ[0] = copyOfrMinusMresult[31] ? zero: one;// Q[0] = 1 if MSB of R =0 or Q[0] = 0 is MSB of R = 1

    assign divCompleted = count[5] & count[0];//, count[0], count[1], count[2], count[3], count[4]); // over when counter completed and reaches 11111
    multAlu twosComplementQuotient(zeros, rqOut[31:0], complementQuotient, one, overflow4);
    assign isQuotientNegative = (dividend[31] & ~divisor[31]) | (~dividend[31] & divisor[31]);
    assign out = divCompleted ? (isQuotientNegative ? complementQuotient: rqOut[31:0]) : 32'b0;
    assign divException = &(~divisor);// divException = 1 if all bits in divisor = 0
    






endmodule