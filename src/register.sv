//This is an n- bit register with load, output enable, and asynchronous clear signals

module register #(parameter n = 8) (
    input clk,
    input [n-1:0] data,
    input load,
    input rst,
    output reg [n-1:0] dataOut);

    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            dataOut <= 0;
        end
        else if (load == 1) begin
            dataOut <= data;
        end
    end
endmodule
