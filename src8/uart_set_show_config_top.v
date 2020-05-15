`include "motoro301_rtl_top.def.inc.v"

module uart_set_show_config_top(
    busDefault,
    busNow,

    uTx,
    clkUtx ,

    nRst,
    clk10mhz

);
//parameter busWIDTH      = 8;
//parameter busADDRwidth  = 1;

input   wire    [`busWIDTH:1]            busDefault ;
output  wire    [`busWIDTH:1]            busNow ;
input   wire                            clk10mhz;	// 10MHz
input   wire                            nRst;		// reset button on the core board
                           
output  wire                            clkUtx;	
output  wire                            uTx;	

wire            [7:0]                   txData8;	
wire                                    txBusy;		

assign txData8  =   'h08;
//assign busNow   =   0 ;
assign busNow   =   busDefault ;

uart_clkgen_10mhz_115200		
ucg01(	
    .clk10mhz(clk10mhz),	//
    .nRst(nRst),
    .clkUtx(clkUtx)
);

uart_tx_only
tx01(		
    .uTx(uTx),

    .txBusy(txBusy),
    .txData8(txData8),
    .txStart(1'b0),

    .nRst(nRst),
    .clk(clkUtx)
);

endmodule
