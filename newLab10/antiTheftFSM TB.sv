module antiTheftFsmTb;

    logic clk;
    logic reset;
    logic ignition;
    logic driverDoor;
    logic passengerDoor;
    logic oneHzEnable;
    logic timerExpired;
    logic reprogram;
    logic startTimer;
    logic [1:0] interval;
    logic statusLed;
    logic siren;

    antiTheftFsm dut (
        .clk(clk),
        .reset(reset),
        .ignition(ignition),
        .driverDoor(driverDoor),
        .passengerDoor(passengerDoor),
        .oneHzEnable(oneHzEnable),
        .timerExpired(timerExpired),
        .reprogram(reprogram),
        .startTimer(startTimer),
        .interval(interval),
        .statusLed(statusLed),
        .siren(siren)
    );

    always #5 clk = ~clk;
	int oneHzCounter = 0;
    always @(posedge clk) begin
        if (oneHzCounter == 49) begin
            oneHzEnable <= 1'b1;
            oneHzCounter <= 0;
        end else begin
            oneHzEnable <= 1'b0;
            oneHzCounter <= oneHzCounter + 1;
        end
    end

    initial begin	
      	$dumpfile("dump.vcd"); $dumpvars;
      
        clk = 0;
        reset = 1;
        ignition = 0;
        driverDoor = 0;
        passengerDoor = 0;
        timerExpired = 0;
        reprogram = 0;

        #20;
        reset = 0;
        #100;
        //Basic arming sequence
        ignition = 1;
        #50;
        ignition = 0;
        #50;
        driverDoor = 1;
        #50;
        driverDoor = 0;
        #50;
        timerExpired = 1;
        #10;
        timerExpired = 0;
        
        #100;
        //Driver door trigger and disarm
        driverDoor = 1;
        #50;
        ignition = 1;
        #50;
        driverDoor = 0;
        ignition = 0;
        
        #100;
        //Driver door trigger and alarm
        driverDoor = 1;
        #50;
        //Door is open, timer should expire
        timerExpired = 1;
        #10;
        timerExpired = 0;
        #50;
        //Siren should be ON now
        #100;
        driverDoor = 0;
        #50;
        //Door closed, starting alarm timeout
        timerExpired = 1;
        #10;
        timerExpired = 0;
        
        #100;
        //Passenger door trigger
        passengerDoor = 1;
        #50;
        ignition = 1;
        #50;
        passengerDoor = 0;
        ignition = 0;
        
        #100;
        //LED blinking test
        #500;
      	#1000
        #100;

        #10;
        reprogram = 0;
        
        #200;
        $finish;
    end
endmodule