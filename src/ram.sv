module ram (
     // Inputs
    input               clk,
    input               w_en,
    input               prog_mode,
    input       [3:0]   address,
    input       [3:0]   prog_addr,
    input       [7:0]   w_data,
    input       [7:0]   program_data,
    
    // Outputs
    output  wire [7:0]   r_data );

    // Declare memory
    reg [7:0]  mem [0:15];

    always @ (posedge clk) begin
        if (prog_mode == 1'b1) begin
            mem[prog_addr] <= program_data;
        end else if (w_en == 1'b1) begin
            mem[address] <= w_data;
        end
    end
    assign r_data = mem[address];

endmodule
