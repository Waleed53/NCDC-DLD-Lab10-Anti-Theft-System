module timer (
  input logic clk,
  input logic startTimer, 
  input logic [3:0] value,
  output logic expired,
  output logic Hz1en
);

  logic halt;
  logic [3:0] count;
  logic [24:0] Hzcount;
  
  always_ff @(posedge clk) begin
    // Timer start
    if (startTimer) begin
      Hzcount  <= 0;
      Hz1en    <= 0;
      count    <= value;
      expired  <= 0;
      halt     <= 0;
    end else begin
      if (Hzcount == 10 - 1) begin // CHANGE for FPGA, low for sim
        Hzcount <= 0;
        Hz1en   <= 1; 
      end else begin
        Hzcount <= Hzcount + 1;
        Hz1en   <= 0;
      end

      // Timer countdown 
      if (Hz1en && !halt) begin
        if (count > 0)
          count <= count - 1;

        if (count == 1) begin 
          expired <= 1;
          halt    <= 1;
        end
      end
    end
  end

endmodule
