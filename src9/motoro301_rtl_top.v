`include "motoro301_rtl_top.def.inc.v"

module motoro301_rtl_top(
    aHP,
    aLN,
    bHP,
    bLN,
    cHP,
    cLN,

    m3start         ,
    m3forceStop     ,
    m3invRotate     ,
    m3freqINC       ,
    m3freqDEC       ,

    tp01,
    tp02,
    uTx,

    led4,
    nReset,
    clk50mhz

);

output  wire                aHP ;	
output  wire                aLN ;	
output  wire                bHP ;	
output  wire                bLN ;	
output  wire                cHP ;	
output  wire                cLN ;	
input   wire                m3start;	
input   wire                m3forceStop;	 
input   wire                m3invRotate;	 
input   wire                m3freqINC;	 
input   wire                m3freqDEC;	 

output  wire                tp01;	
output  wire                tp02;	
output  wire                uTx;	

output  wire    [3:0]       led4;	
input   wire                clk50mhz;			// 50MHz
input   wire                nReset;		// reset button on the core board

wire                        clkUtx ;
wire                        clk1Mhz;			// 1MHz
wire    [`busWIDTH:1]            busDefault ;


//assign {tp01 , tp02 } = { nReset , ~nReset };
assign {tp01 , tp02 } = { clkUtx , ~clkUtx };

led4
ledTop(
    .led            (   led4        ),

    .nRst           (   nReset      ),
    .clk            (   clk50mhz    )
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

    .uTx            (   uTx             ),
    .clkUtx         (   clkUtx          ),

    .nRst           (   nReset          ),
    .clk10mhz       (   clk1Mhz         )
);

motoro3_top
m3t
(
    .aHP            (   aHP             ),
    .aLN            (   aLN             ),
    .bHP            (   bHP             ),
    .bLN            (   bLN             ),
    .cHP            (   cHP             ),
    .cLN            (   cLN             ),
                                       
    .m3start        (   m3start         ),
    .m3freqINC      (   m3freqINC       ),
    .m3freqDEC      (   m3freqDEC       ),
    .m3forceStop    (   m3forceStop     ),
    .m3invRotate    (   m3invRotate     ),

    .nRst           (   nReset          ),
    .clkHI          (   clk50mhz        ),
    .clk            (   clk1Mhz         )
);

clkGen_50Mhz_to_1Mhz
cgM3
(
    .nRst           (   nReset          ),
    .clk1mhzO       (   clk1Mhz         ),
    .clk50mhzI      (   clk50mhz        )
);

endmodule
