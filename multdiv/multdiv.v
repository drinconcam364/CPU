module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    wire multCompleted, multException, isMult, divCompleted, divException, latchedIsMult, latchedisDiv, multTurn, divTurn, one, isDiv;
    wire [31:0] multResult, divResult;
    assign one = 1'b1;

    dffe_ref isMUlt(.q(isMult),.d(1'b1),.clk(clock),.en(ctrl_MULT), .clr(ctrl_DIV));//q, d, clk, en, clr
    //dffe_ref isDIv(.q(isDiv), .d(1'b1), .clk(clock), .en(ctrl_DIV), .clr(ctrl_MULT));
    dffe_ref changeToMult(.q(latchedIsMult), .d(ctrl_MULT), .clk(clock), .en(one), .clr(~ctrl_MULT));
    dffe_ref changeToDiv(.q(latchedisDiv), .d(ctrl_DIV), .clk(clock), .en(one), .clr(~ctrl_DIV));
    assign multTurn = ~latchedIsMult &ctrl_MULT;
    assign divTurn = ~latchedisDiv & ctrl_DIV;

    multiply mult(.multiplicand(data_operandA), .multiplier(data_operandB), .multTurn(multTurn), .clock(clock), .out(multResult),.multCompleted(multCompleted), .multException(multException));//multiplicand, multiplier,ctrl_MULT, clock, out
    divide die(.dividend(data_operandA),.divisor(data_operandB), .clock(clock), .out(divResult), .divException(divException), .divCompleted(divCompleted),.divTurn(divTurn));//dividend, divisor, clock, out, divException, divCompleted,ctrl_DIV);
    assign data_resultRDY = isMult ? multCompleted : divCompleted;
    assign data_exception = isMult ? multException : divException;
    assign data_result = isMult ? multResult: divResult;
endmodule