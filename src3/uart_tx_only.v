
module uart_tx_only(
    uTx,

    txBusy,
    txData8,
    txStart,


    nRst,
    clk
);

output                          uTx;	// RS232

output                          txBusy;	//
input   [7:0]                   txData8;	//
input                           txStart;		//,,

input                           nRst;		//
input                           clk;		// clk_bps_r,

assign uTx = 1'b1 ;


endmodule
