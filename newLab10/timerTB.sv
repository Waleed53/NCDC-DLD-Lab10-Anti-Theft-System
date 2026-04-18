module timerTb();
  logic clk, startTimer;
  logic [3:0]value;
  logic expired, Hz1en;
  
  timer u(
    .clk(clk), .startTimer(startTimer), .value(value),
    .expired(expired),.Hz1en(Hz1en)
  );
  initial begin 
    clk = 0;
    forever #1 clk = ~clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
	$dumpvars;
    #1
    startTimer = 0;
    value = 0;
    #10
    value = 3;
    #10
    startTimer = 1;
    #10
    startTimer = 0;
    #10 //// testing transition to WAIT state
    #10
    #10
    #10
    #10
    #10
    #10
    #10
    #10
    #10
    #10
    
    $finish;
  end
  
endmodule