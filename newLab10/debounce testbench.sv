`timescale 1ns / 1ps

module debounceTb;

    logic resetIn;
    logic clockIn;
    logic noisyIn;

    logic cleanOut;

    debounce u (
        .reset_in(resetIn),
        .clock_in(clockIn),
        .noisy_in(noisyIn),
        .clean_out(cleanOut)
    );

    initial begin
        clockIn = 0;
        forever #5 clockIn = ~clockIn;
    end

    initial begin
      	$dumpfile("dump.vcd");
    $dumpvars(0, debounceTb);
        resetIn = 1;
        noisyIn = 0;

        repeat (5) @(posedge clockIn);
        resetIn = 0;

        repeat (10) begin
            @(posedge clockIn);
            noisyIn = ~noisyIn; 
        end

        noisyIn = 1;

      repeat (1000005) @(posedge clockIn); 

        noisyIn = 0;

      repeat (1000005) @(posedge clockIn);

        $finish;
    end

endmodule
