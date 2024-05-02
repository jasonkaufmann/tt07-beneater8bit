module ram (
     // Inputs
    input               clk,
    input               rst,
    input               w_en,
    input               prog_mode,
    input       [3:0]   address,
    input       [3:0]   prog_addr,
    input       [7:0]   w_data,
    
    // Outputs
    output  reg [7:0]   r_data );

    // Declare memory
    reg [7:0]  mem [0:15];

    reg write_state;

    //make an edge detector module
    //wire rising_edge;
    //wire falling_edge;

    //edge_detector edge_detect(.clk(clk), .rst(rst), .a_i(prog_mode), .rising_edge_o(rising_edge), .falling_edge_o(falling_edge));
    
    always_ff @ (posedge clk or negedge rst) begin

        r_data <= mem[address];

        if (prog_mode == 1'b1) begin
            mem[prog_addr] <= w_data;
        end
        else if (w_en == 1'b1) begin
            mem[address] <= w_data;
        end
    end

    // Initialization (if available)
    //initial if (INIT_FILE) begin
    //    $readmemh(INIT_FILE, mem);
    //end

endmodule
