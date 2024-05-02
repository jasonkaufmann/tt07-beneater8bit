 // An edge detector

module edge_detector (
  input     wire    clk,
  input     wire    rst,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

    logic a_ff;

    always_ff @(posedge clk or posedge rst)
      if (rst)
        a_ff <= 1'b0;
      else
        a_ff <= a_i;

    // Rising edge when delayed signal is 0 but current is 1
    assign rising_edge_o = ~a_ff & a_i;

    // Falling edge when delayed signal is 1 but current is 0
    assign falling_edge_o = a_ff & ~a_i;

endmodule
