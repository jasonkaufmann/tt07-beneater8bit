 // An edge detector

module edge_detector (
  input     wire    clk,
  input     wire    rst,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

    reg a_ff;

    always @(posedge clk or negedge rst) begin
      if (!rst) begin 
        a_ff <= 1'b0;
      end else begin
        a_ff <= a_i;
      end
    end

    // Rising edge when delayed signal is 0 but current is 1
    assign rising_edge_o = ~a_ff & a_i;

    // Falling edge when delayed signal is 1 but current is 0
    assign falling_edge_o = a_ff & ~a_i;

endmodule
