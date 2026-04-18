
module freq_div (
    input logic clk,
    output logic out, [1:0]count
);
    initial begin
        count = 0; 
    end

    always@(posedge clk) begin
    count <= count+1;
        if(count == 2'b00)begin
            out <= 1;
        end else if (count == 2'b10) begin
            out <= 0;
        end
        if(count == 2'b11)begin
            out <= 0;
            count<=2'b00;
        end
    end
endmodule



