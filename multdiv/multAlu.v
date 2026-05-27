module multAlu(data_operandA, data_operandB, data_result, isSub, overflow);
    input [31:0] data_operandA, data_operandB; // Int A and Int B
    input isSub;
    output [31:0] data_result; // Final Result
    output overflow;//isNotEqual, isLessThan, overflow;
    claAdder add_(data_result, data_operandA, data_operandB, isSub, overflow);
endmodule