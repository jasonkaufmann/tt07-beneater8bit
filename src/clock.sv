
/*This is a clock with a halt signal, depending on the mode
we will use the internal clock or an external pushbutton clock */

module clock (
    input  wire fastClk, //this clock is 12MHz
    input  wire rst,
    input  wire clock_max_count, //this is the maximum number of cycles before the clock toggles,
    input  wire clock_change_mode,
    output wire slowClk);

    reg [31:0] count = 0;

    reg [31:0] maxCount = 0;

    reg [4:0] clockUpdateCounter = 0; 

    reg slowClkInt = 0;

    //make an edge detector module
    wire rising_edge;
    wire falling_edge;
    
    edge_detector edge_detect(.clk(fastClk), .rst(rst), .a_i(clock_change_mode), .rising_edge_o(rising_edge), .falling_edge_o(falling_edge));

    always @(posedge fastClk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            slowClkInt <= 0;
            maxCount <= 0;
        end else if (rising_edge | falling_edge) begin
            clockUpdateCounter <= 0;
        end else if (!rising_edge & clock_change_mode) begin
            clockUpdateCounter <= clockUpdateCounter + 1;
            maxCount[clockUpdateCounter] <= clock_max_count;
        end else begin
            count <= count + 1; //increment the counter
            if (count == maxCount) begin
                slowClkInt <= ~slowClkInt; //toggle the clock
                count <= 0; //reset the coutner
            end
        end
    end

    assign slowClk = clock_change_mode ? 1'b0 : slowClkInt;

endmodule
