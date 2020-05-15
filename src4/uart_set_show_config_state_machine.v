`include "motoro301_rtl_top.def.inc.v"
module uart_set_show_config_state_machine(
    busDefault,
    busNow,

    uTx,
    clkUtx ,

    nRst,
    clk10mhz

);

input   wire    [`busWIDTH:0]       busDefault ;
output  wire    [`busWIDTH:0]       busNow ;
input   wire                clk10mhz;			// 50MHz
input   wire                nRst;		// reset button on the core board
                           
output  wire                clkUtx;	
output  wire                uTx;	

wire            [7:0]       txData8;	
wire                        txBusy;		

assign txData8  =   'h08;
assign busNow   =   0 ;

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
