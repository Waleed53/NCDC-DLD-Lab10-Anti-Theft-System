module antiTheftFsm (
    input logic clk,
    input logic reset,
    input logic ignition,
    input logic driverDoor,
    input logic passengerDoor,
    input logic oneHzEnable,
    input logic timerExpired,
    input logic reprogram,
    output logic startTimer,
    output logic [1:0] interval,
    output logic statusLed,
    output logic siren
);

    typedef enum logic [2:0] {
        disarmed = 3'b000,
        waitForDoors = 3'b001,
        armDelay = 3'b010,
        armed = 3'b011,
        driverTriggered = 3'b100,
        passengerTriggered = 3'b101,
        soundAlarm = 3'b110,
        alarmTimeout = 3'b111
    } stateType;

    stateType currentState, nextState;
    
    logic [1:0] blinkCounter;
    logic blinkLed;
    logic anyDoorOpen;
    
    assign anyDoorOpen = driverDoor | passengerDoor;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            blinkCounter <= 2'b00;
            blinkLed <= 1'b0;
        end else if (oneHzEnable) begin
            if (blinkCounter == 2'b01) begin
                blinkCounter <= 2'b00;
                blinkLed <= ~blinkLed;
            end else begin
                blinkCounter <= blinkCounter + 1'b1;
            end
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset || reprogram)
            currentState <= armed;
        else
            currentState <= nextState;
    end

    always_comb begin
        nextState = currentState;
        
        case (currentState)
            disarmed: begin
                if (~ignition)
                    nextState = waitForDoors;
            end
            
            waitForDoors: begin
                if (driverDoor && ~passengerDoor)
                    nextState = armDelay;
                else if (anyDoorOpen)
                    nextState = waitForDoors;
                else if (~anyDoorOpen)
                    nextState = armDelay;
            end
            
            armDelay: begin
                if (anyDoorOpen)
                    nextState = waitForDoors;
                else if (timerExpired)
                    nextState = armed;
            end
            
            armed: begin
                if (ignition)
                    nextState = disarmed;
                else if (driverDoor)
                    nextState = driverTriggered;
                else if (passengerDoor)
                    nextState = passengerTriggered;
            end
            
            driverTriggered: begin
                if (ignition)
                    nextState = disarmed;
                else if (timerExpired && anyDoorOpen)
                    nextState = soundAlarm;
                else if (timerExpired && ~anyDoorOpen)
                    nextState = alarmTimeout;
            end
            
            passengerTriggered: begin
                if (ignition)
                    nextState = disarmed;
                else if (timerExpired && anyDoorOpen)
                    nextState = soundAlarm;
                else if (timerExpired && ~anyDoorOpen)
                    nextState = alarmTimeout;
            end
            
            soundAlarm: begin
                if (ignition)
                    nextState = disarmed;
                else if (~anyDoorOpen)
                    nextState = alarmTimeout;
            end
            
            alarmTimeout: begin
                if (ignition)
                    nextState = disarmed;
                else if (anyDoorOpen)
                    nextState = soundAlarm;
                else if (timerExpired)
                    nextState = armed;
            end
            
            default: nextState = armed;
        endcase
    end

    always_comb begin
        startTimer = 1'b0;
        interval = 2'b00;
        statusLed = 1'b0;
        siren = 1'b0;
        
        case (currentState)
            disarmed: begin
            end
            
            waitForDoors: begin
            end
            
            armDelay: begin
                startTimer = 1'b1;
                interval = 2'b00;
            end
            
            armed: begin
                statusLed = blinkLed;
            end
            
            driverTriggered: begin
                startTimer = 1'b1;
                interval = 2'b01;
                statusLed = 1'b1;
            end
            
            passengerTriggered: begin
                startTimer = 1'b1;
                interval = 2'b10;
                statusLed = 1'b1;
            end
            
            soundAlarm: begin
                statusLed = 1'b1;
                siren = 1'b1;
            end
            
            alarmTimeout: begin
                startTimer = 1'b1;
                interval = 2'b11;
                statusLed = 1'b1;
                siren = 1'b1;
            end
            
            default: begin
                statusLed = blinkLed;
            end
        endcase
    end

endmodule