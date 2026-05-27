/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

	// ================FETCH STAGE=================== //
    wire [31:0] pc_in, pc_out, pc_plus_one, f_d_pc_out,f_d_ir_out;
    //pc = pc+1
    register pc_reg(.clk(clock), .in(pc_in), .out(pc_out), .clrn(reset), .we(1'b1)); // latch to hold current program counter
    alu pc_adder(.data_operandA(pc_out), .data_operandB(32'd1), .ctrl_ALUopcode(5'd0), .ctrl_shiftamt(5'd0), .data_result(pc_plus_one),.isNotEqual(), .isLessThan(), .overflow());
    assign pc_in = pc_plus_one;
    assign address_imem = pc_out;

    // ================FETCH-DECODE=================== //
    register fd_ir_latch(.clk(~clock), .in(q_imem), .out(f_d_ir_out), .clrn(reset), .we(1'b1));//clk, in, out, clrn, we
    register fd_pc_latch(.clk(~clock), .in(pc_out), .out(f_d_pc_out), .clrn(reset), .we(1'b1));

    // ================DEC0DE STAGE==================//
    wire [31:0] d_x_ir, d_x_A, d_x_B, d_x_pc, d_x_inst_type, x_m_inst_type;
    wire[24:0] I_opcodes;
    wire [3:0] instruction_type; // [JII, JI, I, R]
    assign I_opcodes = 25'b0010100111010000001000110; //[addi,sw, lw, bne, blt]
    //Determine what is the isntruction type
    assign instruction_type[0] = (f_d_ir_out[31:27] == 5'b0);// R=1 if opcode = 00000
    assign instruction_type[1] = (f_d_ir_out[31:27] == I_opcodes[4:0]) | (f_d_ir_out[31:27] == I_opcodes[9:5]) | (f_d_ir_out[31:27] == I_opcodes[14:10]) | (f_d_ir_out[31:27] == I_opcodes[19:15]) | (f_d_ir_out[31:27] == I_opcodes[24:20]);
    //
    assign ctrl_readRegA = f_d_ir_out[21:17]; // $rs
    assign ctrl_readRegB = instruction_type[0] ? f_d_ir_out[16:12] : f_d_ir_out[26:22];
//assign ctrl_readRegB = instruction_type[0] ? f_d_latch_out[16:12] : 5'b0; // $rd, doesn't matter if instruction isn't R type
    
    // ================DECODE-EXECUTE=================== //
    register data_operand_A_latch(.clk(~clock), .in(data_readRegA), .out(d_x_A), .clrn(reset), .we(1'b1));
    register data_operand_B_latch(.clk(~clock), .in(data_readRegB), .out(d_x_B), .clrn(reset), .we(1'b1));
    register dx_ir1(.clk(~clock), .in(f_d_ir_out), .out(d_x_ir), .clrn(reset), .we(1'b1));
    register dx_pc1(.clk(~clock), .in (f_d_pc_out), .out(d_x_pc), .clrn(reset), .we(1'b1));
    register dx_inst_type(.clk(~clock), .in({28'd0, instruction_type}), .out(d_x_inst_type), .clrn(reset), .we(1'b1));
    
    // ================Execute STAGE==================//
    wire [31:0] alu_out, immediate, alu_b_in, x_m_ir, x_m_B, x_m_alu_out;  
    wire [4:0] alu_opcode, shift_amount;
    wire isNotEqual, isLessThan, overflow;
    assign alu_opcode =  d_x_inst_type[0] ? d_x_ir[6:2] : (d_x_inst_type[1] ? 5'b0 : 5'b0);
    assign immediate = {{15{d_x_ir[16]}}, d_x_ir[16:0]}; // assign immediate = {15'b0, d_x_latch_out[16:0]};
    assign shift_amount = d_x_ir[11:7];

    //if instruction_type[0] (isR), then alu_b_in is B, if isI, then alu_b_in is immediate
    assign alu_b_in = d_x_inst_type[0] ? d_x_B: (d_x_inst_type[1] ? immediate : 32'b0);
    alu execute_alu(.data_operandA(d_x_A), .data_operandB(alu_b_in), .ctrl_ALUopcode(alu_opcode), .ctrl_shiftamt(shift_amount),.data_result(alu_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));//data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow
    // ================EXECUTE-MEMORY=================== //
    register alu_result_latch(.clk(~clock), .in(alu_out), .out(x_m_alu_out), .clrn(reset), .we(1'b1));
    register xm_ir1(.clk(~clock), .in(d_x_ir), .out(x_m_ir), .clrn(reset), .we(1'b1));
    register b_latch(.clk(~clock), .in(d_x_B), .out(x_m_B), .clrn(reset), .we(1'b1));
    register xm_inst_type(.clk(~clock), .in(d_x_inst_type), .out(x_m_inst_type), .clrn(reset), .we(1'b1));

    // ================Memory STAGE==================//
    wire [31:0] m_w_ir, data_memory_out,m_w_alu_out;
    assign address_dmem = x_m_alu_out;
    assign data = x_m_B;
    assign wren = (x_m_ir[31:27] == 5'b00111);

    // ================MEMORY-WRITEBACK=================== //
    register alu_result_m_w_latch(.clk(~clock), .in(x_m_alu_out), .out(m_w_alu_out), .clrn(reset), .we(1'b1));
    register data_memory_latch(.clk(~clock), .in(q_dmem), .out(data_memory_out), .clrn(reset), .we(1'b1));
    register mw_ir1(.clk(~clock), .in(x_m_ir), .out(m_w_ir), .clrn(reset), .we(1'b1));

    // ================Writeback STAGE==================//
    assign data_writeReg = (m_w_ir[31:27] == 5'b01000) ? data_memory_out : m_w_alu_out;
//assign data_writeReg = (m_w_latch_out[31:27] != 5'b01000) ? m_w_latched_alu_out : 32'd1;//data_memory_out; // lw only instruction that writes memory data, all other instructions write alu result
    //assign ctrl_writeReg = 5'd4;//q_imem[26:22];//
    assign ctrl_writeReg = m_w_ir[26:22]; // $rd
    //assign ctrl_writeEnable = (m_w_latch_out[31:27] != 5'b00111); // sw only instruction that doesn't need to write back
    //assign data_writeReg = 32'd10;
    //assign ctrl_writeReg = 5'd1;
    assign ctrl_writeEnable = (m_w_ir[31:27] != 5'b00111);//assign ctrl_writeEnable = 1'b1;
    /* END CODE */
endmodule
