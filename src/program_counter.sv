module programCounter (
    input clk,
    input jump,
    input countEnable,
    input [3:0] jumpAddr,

    output reg [3:0] addr = 0
);

    always @ (posedge clk) begin
        if(countEnable == 1'b1) begin
            addr <= addr + 1;
        end
        else if (jump == 1'b1) begin
            addr <= jumpAddr;
        end
    end

endmodule
