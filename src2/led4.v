`define time1S 32'd12500000
module led4(
    input wire nRstI,
    input wire clkI,
    output reg [3:0]led4O
);
reg clk2;
reg [31:0] counter;    
    
always@(posedge clkI, negedge nRstI) begin
    if(!nRstI) begin
        counter     <= `time1S ;
        clk2        <= 32'd0;
    end
    else begin
        if (counter == 32'd0) begin
            counter <= `time1S ;
            clk2    <= ~clk2;
        end
        else begin
            counter <= counter - 32'd1;
        end
    end
end

always@(posedge clk2, negedge nRstI) begin
    if(!nRstI) begin
        led4O <= 4'd0;
    end
    //i<=0;
    else begin
        //led4O <= led4O + 4'd1 ;
        //{led4O[0],led4O[1],led4O[2],led4O[3]} <= {led4O[0],led4O[1],led4O[2],led4O[3]} + 4'd1 ;
//`define aaa12 1
//`define aaa23 1
//`define aaa34 1
`define aaa14   1

`ifdef aaa12
        {led4O[0],led4O[1]} <= {led4O[0],led4O[1]} + 2'd1 ;
        led4O[2] <= 1'b1 ;
        led4O[3] <= 1'b1 ;
`endif
`ifdef aaa23
        {led4O[2],led4O[1]} <= {led4O[2],led4O[1]} + 2'd1 ;
        led4O[0] <= 1'b1 ;
        led4O[3] <= 1'b1 ;
`endif
`ifdef aaa34
        {led4O[2],led4O[3]} <= {led4O[2],led4O[3]} + 2'd1 ;
        led4O[0] <= 1'b1 ;
        led4O[1] <= 1'b1 ;
`endif
`ifdef aaa14
        {led4O[0],led4O[3]} <= {led4O[0],led4O[3]} + 2'd1 ;
        led4O[1] <= 1'b1 ;
        led4O[2] <= 1'b1 ;
`endif
    end
end
    
endmodule
