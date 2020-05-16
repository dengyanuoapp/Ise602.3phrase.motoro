`include "motoro301_rtl_top.def.inc.v"

module motoro301_rtl_top(
    aHPo,
    aLNo,
    bHPo,
    bLNo,
    cHPo,
    cLNo,

    m3startI         ,
    m3forceStopI     ,
    m3invRotateI     ,
    m3freqINCi       ,
    m3freqDECi       ,

    tp01o,
    tp02o,
    uTxO,

    led4O,
    nResetI,
    clk50mhzI

);

output  wire                aHPo ;	
output  wire                aLNo ;	
output  wire                bHPo ;	
output  wire                bLNo ;	
output  wire                cHPo ;	
output  wire                cLNo ;	
input   wire                m3startI;	
input   wire                m3forceStopI;	 
input   wire                m3invRotateI;	 
input   wire                m3freqINCi;	 
input   wire                m3freqDECi;	 

output  wire                tp01o;	
output  wire                tp02o;	
output  wire                uTxO;	

output  wire    [3:0]       led4O;	
input   wire                clk50mhzI;			// 50MHz
input   wire                nResetI;		// reset button on the core board

wire                        clkUtxW ;
wire                        clk1MhzW;			// 1MHz
wire    [`busWIDTH:1]            busDefault ;


//assign {tp01o , tp02o } = { nResetI , ~nResetI };
assign {tp01o , tp02o } = { clkUtxW , ~clkUtxW };

led4
ledTop(
    .led            (   led4O        ),

    .nRst           (   nResetI      ),
    .clk            (   clk50mhzI    )
);

uart_set_show_config_top
usTop(
    .busDefault     ( { 
        `m3pos1_neg0 , 
        `m3perCent , 
        `m3speedRoundPerSecondH8 , 
        `m3speedRoundPerSecondL8 
    } ),
    .busNow         (                   ),

    .uTx             (   uTxO             ),
    .clkUtx         (   clkUtxW          ),

    .nRst           (   nResetI          ),
    .clk10mhz       (   clk1MhzW         )
);

motoro3_top
m3t
(
    .aHPo            (   aHPo             ),
    .aLNo            (   aLNo             ),
    .bHPo            (   bHPo             ),
    .bLNo            (   bLNo             ),
    .cHPo            (   cHPo             ),
    .cLNo            (   cLNo             ),
                                       
    .m3startI        (   m3startI         ),
    .m3freqINCi      (   m3freqINCi       ),
    .m3freqDECi      (   m3freqDECi       ),
    .m3forceStopI    (   m3forceStopI     ),
    .m3invRotateI    (   m3invRotateI     ),

    .nRstI           (   nResetI          ),
    .clkHIi          (   clk50mhzI        ),
    .clkI           (   clk1MhzW         )
);

clkGen_50Mhz_to_1Mhz
cgM3
(
    .nRstI           (   nResetI          ),
    .clk1mhzO       (   clk1MhzW         ),
    .clk50mhzI      (   clk50mhzI        )
);

endmodule
