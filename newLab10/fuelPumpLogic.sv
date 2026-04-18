module fuelPumpLogic(
	input logic clk, systemReset, brake, hidSwt,igntSwt,
  	output logic power
);
  logic [1:0]cstate;
  logic [1:0]nstate;
  // 00 is off
  // 01 is wait
  // and 10 is on
  // state register that stores state(to create flip flop)
  always_ff@(posedge clk or posedge systemReset)begin
    if(systemReset)begin
      cstate <= 2'b00;
    end
    else begin
      	cstate<=nstate;
      end
  end
  
  
  
  // next state logic
  always_comb begin
    case(cstate)
      2'b00: begin // for OFF state
        if(igntSwt == 1)
          nstate = 2'b01;
        else
          nstate = 2'b00; // remain the same if ignition not on
      end
      2'b01: begin // for WAIT state
        if(igntSwt == 0) // go back to OFF if ignition goes OFF
          nstate = 2'b00;
        else begin if(hidSwt && brake)
          nstate = 2'b10; //turn ON if both switches pressed
        end
      end
      2'b10: begin
        if(igntSwt == 0)// turn OFF if ingnition goes off
          nstate = 2'b00;
        else
          nstate = 2'b10;
      end
    endcase
    
  end
  
  
  always_comb begin
    case (cstate)
      2'b00: power = 0;
      2'b01: power = 0;
      2'b10: power = 1;
    endcase
  end
endmodule
