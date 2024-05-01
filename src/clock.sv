
/*This is a clock with a halt signal, depending on the mode
we will use the internal clock or an external pushbutton clock */

module clock (
    input wire fastClk, //this clock is 12MHz
    input wire [31:0] clockDivider, //this is the maximum number of cycles before the clock toggles
    output reg slowClk = 0);

/*the slow clock should go every second
and once enter cycle is two transitions so LOW --> HIGH --> LOW */
localparam maxCount = 1000; 
//clock will be divided by 12MHz/1000 = 12,000Hz

reg [31:0] count = 0;

always @(posedge fastClk) begin
    count = count + 1; //increment the counter
    if (count == maxCount) begin
        slowClk = ~slowClk; //toggle the clock
        count = 0; //reset the coutner
    end
end

endmodule