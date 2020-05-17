
module uart_clkgen_10mhz_115200(
		clkUtx,

		nRst,
		clk10mhz
		);

input   wire                clk10mhz;	// 50MHz
input   wire                nRst;	//
output  reg                 clkUtx;	// clkUtx 

/*
   parameter		10000000/115200 ==  86.8 == 87
 */

//
`define		uTxHalf1		8'd43	//115200
`define		uTxHalf2		8'd44	//115200

reg         [7:0]                   cnt;		

//----------------------------------------------------------
reg[2:0] uart_ctrl;	// uart
//----------------------------------------------------------

always @ (posedge clk10mhz or negedge nRst) begin
if(!nRst) begin
cnt                 <= `uTxHalf1 ;
clkUtx              <=  1'b0 ;
end
else begin
if (cnt[7:1] == 7'd0 ) begin
if ( clkUtx == 1'b1 ) begin
cnt         <= `uTxHalf1 ;
clkUtx      <=  1'b0 ;
end
else begin
cnt         <= `uTxHalf2 ;
clkUtx      <=  1'b1 ;
end
end
else begin
cnt             <= cnt - 8'd1 ;
end
end
end


endmodule
