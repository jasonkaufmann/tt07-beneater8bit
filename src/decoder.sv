module decoder (
    // Inputs
    input wire [7:0] insn,
    input wire clk,
    input wire rst,
    input wire prog_mode,

    // Outputs
    output reg hlt,
    output reg mi,
    output reg ri,
    output reg ro,
    output reg io,
    output reg ii,
    output reg ai,
    output reg ao,
    output reg sumo,
    output reg sub,
    output reg bi,
    output reg oi,
    output reg ce, 
    output reg co,
    output reg j
);

    reg [2:0] microClk = 0;
    wire [3:0] opcode = insn[7:4]; // Extract the opcode from the instruction

    // Microcode clock and opcode control
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            microClk <= 0;
            {hlt, mi, ri, ro, io, ii, ai, ao, sumo, sub, bi, oi, ce, co, j} <= 15'b0;
        end else if (prog_mode) begin
            hlt <= 1;
        end else begin
            // Increment microClk or reset to 0 if it reaches the end of cycle
            microClk <= (microClk == 3'b101) ? 0 : microClk + 1;

            case (opcode)
                4'b0001: begin  // LDA: Load A from memory
                    case (microClk)
                        3'b000: {mi, io} <= 2'b11;  // Set memory address, output from IR
                        3'b001: {ro, ai} <= 2'b11;  // Set RAM to output, load A register
                        3'b010: {mi, co} <= 2'b11;  // Prepare for next instruction
                        default: ;
                    endcase
                end
                4'b0010: begin  // ADD: Add memory to A
                    case (microClk)
                        3'b000: {mi, io} <= 2'b11;
                        3'b001: {ro, bi} <= 2'b11;
                        3'b010: {ai, sumo} <= 2'b11;
                        3'b011: {mi, co} <= 2'b11;  // Prepare for next instruction
                        default: ;
                    endcase
                end
                4'b0011: begin  // SUB: Subtract memory from A
                    case (microClk)
                        3'b000: {mi, io} <= 2'b11;
                        3'b001: {ro, bi} <= 2'b11;
                        3'b010: {ai, sumo, sub} <= 3'b111;
                        3'b011: {mi, co} <= 2'b11;
                        default: ;
                    endcase
                end
                4'b0100: begin  // STA: Store A into memory
                    case (microClk)
                        3'b000: {mi, io} <= 2'b11;  // Set memory address from IR
                        3'b001: {ao, ri} <= 2'b11;  // Set A register out, RAM data in
                        3'b010: {mi, co} <= 2'b11;  // Prepare for next instruction
                        default: ;
                    endcase
                end
                4'b0101: begin  // LDI: Load immediate into A
                    case (microClk)
                        3'b000: {ii, ai} <= 2'b11;  // Set immediate to A register
                        3'b001: {mi, co} <= 2'b11;  // Prepare for next instruction
                        default: ;
                    endcase
                end
                4'b0110: begin  // JMP: Jump to address
                    case (microClk)
                        3'b000: {io, j} <= 2'b11;  // Set instruction to jump
                        3'b001: {mi, co} <= 2'b11;  // Reset the microClk
                        default: ;
                    endcase
                end
                4'b1110: begin  // OUT: Output from A to output device
                    case (microClk)
                        3'b000: {mi, co} <= 2'b11;  // Prepare memory address from IR, enable counter
                        3'b001: {ro, ii, ce} <= 3'b111;  // Set RAM to output, load IR, enable PC
                        3'b010: {ao, oi} <= 2'b11;  // Activate A register output to Output interface
                        3'b011: {mi, co} <= 2'b11;  // Reset microClk for the next instruction
                        default: ;
                    endcase
                end
                4'b1111: begin  // HLT: Halt the machine
                    hlt <= 1;  // Set halt immediately on opcode fetch
                end
                default: begin
                    if (microClk == 3'b101) {  // Reset signals at the end of cycle
                        {mi, co} <= 2'b11;  // Default action to prepare for next instruction
                    }
                end
            endcase
        end   
    end
endmodule
