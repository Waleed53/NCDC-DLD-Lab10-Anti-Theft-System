`timescale 1ns/1ps

module freqDivTb;

    logic clk;
    logic out;
    logic [1:0] count;

    freq_div u (
        .clk(clk),
        .out(out),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        repeat (16) @(posedge clk);

        $finish;
    end

endmodule
