module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
    input [31:0] data_operandA, data_operandB; // Int A and Int B
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt; // Opcode and shiftAmount
    output [31:0] data_result; // Final Result
    output isNotEqual, isLessThan, overflow;
    wire [31:0] zeros, addResult, andResult, orResult, sllResult, sraResult;
    wire one, isSub;
    assign one = 1'b1;
    assign zeros = 32'b0;
    and (isSub, one, ctrl_ALUopcode[0]);// If opcode = 0(add) then isSub = 0, if opcode = 1(subtract), then isSub = 1
    claAdder add_(addResult, data_operandA, data_operandB, isSub, overflow, isNotEqual, isLessThan);
    orOp or_(orResult,data_operandA, data_operandB);
    sll sll_(sllResult,data_operandA, ctrl_shiftamt);
    sra sra_(sraResult,data_operandA, ctrl_shiftamt);
    opAnd and_(andResult,data_operandA, data_operandB);
    mux_32 opSelect(data_result, ctrl_ALUopcode, addResult, addResult, andResult, orResult, sllResult, sraResult, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros, zeros);
endmodule