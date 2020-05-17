module clkGen_50Mhz_to_1Mhz(
		clk1mhzO, // generated : 1Mhz
		nRstI,
		clk50mhzI

		);

output  reg                 clk1mhzO ;	
input   wire                nRstI;		
input   wire                clk50mhzI;

//  4 == 3'b100
// 24 == 5'b11000
// 23 == 5'b10111
// 49 == 6'b110001
`define CLOCK_max       6'd23
`define CLOCK_zero      6'd0
`define CLOCK_one       6'd1
`define CLOCK_mBit      5
reg     [5:0]               cnt ;	
always @ (negedge clk50mhzI or negedge nRstI) begin
if(!nRstI) begin
cnt                 <= `CLOCK_max ;
clk1mhzO            <= 1'b0 ;
end
else begin
if ( 1'b1 == cnt[`CLOCK_mBit] ) begin
cnt             <= `CLOCK_max ;
clk1mhzO        <=  ~clk1mhzO ;
end 
else begin
cnt             <= cnt - `CLOCK_one ;
end
end
end

endmodule
