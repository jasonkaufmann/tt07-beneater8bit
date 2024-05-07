module ram (
     // Inputs
    input               clk,
    input               prog_clk,
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
    
    always @ (posedge prog_clk) begin
        if (prog_mode == 1'b1) begin
            mem[prog_addr] <= program_data;
        end
    end

    always @ (posedge clk) begin

        if (w_en == 1'b1 & prog_mode == 1'b0) begin
            mem[address] <= w_data;
        end
    end

    assign r_data = mem[address];

    // Initialization (if available)
    //initial if (INIT_FILE) begin
    //    $readmemh(INIT_FILE, mem);
    //end

endmodule
