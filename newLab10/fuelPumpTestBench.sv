

module fuelPumpTestBench();
  logic clk, systemReset, brake, hidSwt,igntSwt, power;
  
  fuelPumpLogic u(
    .clk(clk), .systemReset(systemReset), .brake(brake), .hidSwt(hidSwt), .igntSwt(igntSwt), .power(power)
  );
  
  initial begin 
    clk = 0;
    forever #1 clk = ~clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
	$dumpvars;
    #10
    brake = 0;
    hidSwt = 0;
    igntSwt = 0;
    systemReset = 1;
    #10
    systemReset = 0;
    #10 //// testing transition to WAIT state
    #10
    igntSwt = 0;
    #10
    igntSwt = 1;
    #10
    hidSwt = 1;
    #10
    brake = 1;
    #10 // test turning OFF of fuel power
    #10
    #10
    brake = 0;
    #10
    hidSwt = 0;
    #10
    igntSwt = 0;
    #10
    
    $finish;
  end
  
endmodule