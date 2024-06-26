//top level module
module eightBit (
    input  wire       prog_mode,     // program in the RAM or run the program
    input  wire       clock_change_mode,
    input  wire       clock_max_count,
    input  wire [3:0] addr,          // address in the RAM
    output wire [7:0] data,          // IOs: Output path
    input  wire [7:0] data_in,       // IOs: Input path
    output wire [7:0] uio_oe,        // IOs: Enable path (active high: 0=input, 1=output)
    output wire       output_enable, // enable the output register
    input  wire       fastClk,       // clock
    input  wire       rst            // reset_n - low to reset
);

    wire clk; //clock
    wire hlt, mi, ri, ro, io, ii, ai, ao, sumo, sub, bi, oi, ce, co, j; //control lines
    wire zf, cf; //flags
    wire [7:0] a;
    wire [7:0] b;

    // CHECK IF WE'RE IN PROGRAM MODE //
    assign uio_oe = prog_mode ? 8'b0 : 8'b1; // if prog_mode is high, make uio_oe an input, otherwise make it an output

    // INSTANTIATE THE CLOCK //
    wire slowClk;
    clock mainClock (.rst(rst), .fastClk(fastClk), .slowClk(slowClk), .clock_change_mode(clock_change_mode), .clock_max_count(clock_max_count));
    assign clk = slowClk & !hlt;

    // MAKE THE PROGRAM COUNTER //
    wire [3:0] countOut;
    programCounter pc (.clk(clk), .jump(j), .countEnable(ce), .jumpAddr(data[3:0]), .addr(countOut), .rst(rst));
    assign data = (co ? {4'h0, countOut} : 8'hZZ);

    // MAKE THE DECODER LOGIC //
    wire [7:0] insnOut;
    decoder controlLogic(.insn(insnOut), .clk(clk), .rst(rst), .hlt(hlt), .mi(mi),
    .ri(ri), .ro(ro), .io(io), .ii(ii), .ai(ai), .ao(ao), .sumo(sumo), .sub(sub), 
    .bi(bi), .oi(oi), .ce(ce), .co(co), .j(j), .prog_mode(prog_mode), .cf(cf), .zf(zf));

    // MAKE THE A REGISTER //
    register #(.n(8)) aRegister (.clk(clk), .data(data), .load(ai), .rst(rst), .dataOut(a));
    assign data = (ao ? a : 8'hZZ);

    // MAKE THE B REGISTER //
    register #(.n(8)) bRegister (.clk(clk), .data(data), .load(bi), .rst(rst), .dataOut(b));

    // MAKE THE INSTRUCTION REGISTER //
    register #(.n(8)) insnRegister (.clk(clk), .data(data), .load(ii), .dataOut(insnOut), .rst(rst));
    assign data = (io ? {4'h0, insnOut[3:0]} : 8'hZZ);

    // MAKE THE MEMORY ADDRESS REGISTER //
    wire [3:0] memAddress;
    register #(.n(4)) memAddressRegister (.clk(clk), .data(data[3:0]), .load(mi), .dataOut(memAddress), .rst(rst));

    // MAKE THE RAM //
    wire [7:0] ramOut;
    wire ramClk = prog_mode ? fastClk : clk;
    ram ram (.clk(ramClk), .w_en(ri), .prog_addr(addr), .address(memAddress), .w_data(data), .r_data(ramOut), .prog_mode(prog_mode), .program_data(data_in));

    assign data = (ro ? ramOut : 8'hZZ);

    // MAKE THE ALU //
    wire [7:0] aluOut;
    alu alu (.a(a), .b(b), .sub(sub), .out(aluOut), .zeroFlag(zf), .carryFlag(cf));

    assign data = (sumo ? aluOut : 8'hZZ);

    // SET THE OUTPUT ENABLE //
    assign output_enable = oi;

endmodule
