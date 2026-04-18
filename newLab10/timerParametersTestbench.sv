
module timerParametersTestbench();
  logic clk, systemReset, reprogram;
  logic [1:0]timeParamSel;
  logic [3:0] timeValue;
  logic [1:0] interval;
  logic [3:0] value;
  
  timeParameters u(
    .clk(clk), .systemReset(systemReset), .reprogram(reprogram),
    .timeParamSel(timeParamSel),
    .timeValue(timeValue),
    .interval(interval),
    .value(value)
  );
  
  initial begin 
    clk = 0;
    forever #1 clk = ~clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
	$dumpvars;
    #10
    systemReset = 1;
    #10
    systemReset = 0;
    #10 //// testing the output to timer
    interval = 2'b00;
    #10
    interval = 2'b01;
    #10
    interval = 2'b10;
    #10
    interval = 2'b11;
    #10
    //testing reporgramming functionality
    timeParamSel = 3;
    timeValue = 13;
    reprogram = 1;
    #10
    
    $finish;
  end
  
endmodule