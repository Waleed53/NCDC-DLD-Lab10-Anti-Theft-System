// Code your design here
module timeParameters(
	input logic clk, systemReset, reprogram,
  input logic [1:0]timeParamSel,
  input logic [3:0] timeValue,
  input logic [1:0] interval,
  output logic [3:0] value
);
  logic [3:0]T_ARM_DELAY;
  logic [3:0]T_DRIVER_DELAY;
  logic [3:0]T_PASSENGER_DELAY;
  logic [3:0]T_ALARM_ON;
  
  always_ff @(posedge clk or posedge systemReset)begin
    
    case(interval)
        2'b00: value <=T_ARM_DELAY;
        2'b01: value <=T_DRIVER_DELAY;
        2'b10: value <=T_PASSENGER_DELAY;
        2'b11: value <=T_ALARM_ON;
      endcase
    
    if(systemReset) begin
      T_ARM_DELAY <= 6;
      T_DRIVER_DELAY<= 8;
      T_PASSENGER_DELAY <= 15;
      T_ALARM_ON <= 10;
    end
    if(reprogram) begin
      case(timeParamSel)
        2'b00: T_ARM_DELAY <=timeValue;
        2'b01: T_DRIVER_DELAY <=timeValue;
        2'b10: T_PASSENGER_DELAY <=timeValue;
        2'b11: T_ALARM_ON <=timeValue;
      endcase
    end
  end
  
endmodule
