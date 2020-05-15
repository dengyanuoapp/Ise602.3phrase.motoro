`define time1S 32'd12500000
module led4(
    input nRst,
    input clk,
    output reg [3:0]led
);
reg clk2;
reg [31:0] counter;    
    
always@(posedge clk, negedge nRst) begin
    if(!nRst) begin
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

always@(posedge clk2, negedge nRst) begin
    if(!nRst) begin
        led <= 4'd0;
    end
    //i<=0;
    else begin
        //led <= led + 4'd1 ;
        //{led[0],led[1],led[2],led[3]} <= {led[0],led[1],led[2],led[3]} + 4'd1 ;
//`define aaa12 1
//`define aaa23 1
//`define aaa34 1
`define aaa14   1

`ifdef aaa12
        {led[0],led[1]} <= {led[0],led[1]} + 2'd1 ;
        led[2] <= 1'b1 ;
        led[3] <= 1'b1 ;
`endif
`ifdef aaa23
        {led[2],led[1]} <= {led[2],led[1]} + 2'd1 ;
        led[0] <= 1'b1 ;
        led[3] <= 1'b1 ;
`endif
`ifdef aaa34
        {led[2],led[3]} <= {led[2],led[3]} + 2'd1 ;
        led[0] <= 1'b1 ;
        led[1] <= 1'b1 ;
`endif
`ifdef aaa14
        {led[0],led[3]} <= {led[0],led[3]} + 2'd1 ;
        led[1] <= 1'b1 ;
        led[2] <= 1'b1 ;
`endif
    end
end
    
endmodule
