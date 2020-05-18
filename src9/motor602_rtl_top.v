`include "motor602_rtl_top.def.inc.v"

module motor602_rtl_top(
    aHPo,
    aLNo,
    bHPo,
    bLNo,
    cHPo,
    cLNo,

    m3startI         ,
    m3forceStopI     ,
    m3invRotateI     ,
    m3speedDECi       ,
    m3speedINCi       ,
    m3powerINCi       ,
    m3powerDECi       ,

    tp01o,
    tp02o,
    uTxO,

    led4O,
    nRstI  ,
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
    input   wire                m3speedDECi;	 
    input   wire                m3speedINCi;	 
    input   wire                m3powerINCi;	 
    input   wire                m3powerDECi;	 

    output  wire                tp01o;	
    output  wire                tp02o;	
    output  wire                uTxO;	

    output  wire    [3:0]       led4O;	
    input   wire                clk50mhzI;			// 50MHz
    input   wire                nRstI  ;		// reset button on the core board

    wire                        clkUtxW ;
    wire                        clk1MhzW;			// 1MHz
    wire    [`busWIDTH:1]            busDefault ;


    //assign {tp01o , tp02o } = { nRstI   , ~nRstI   };
    assign {tp01o , tp02o } = { clkUtxW , ~clkUtxW };

    led4
    loopLedOnTestBoard(
        .led4O          (   led4O        ),

        .nRstI          (   nRstI        ),
        .clkI           (   clk50mhzI    )
    );
    assign uTxO = 1'b0 ;
    assign clkUtxW  = 0 ;

    motor602_top
    m3top
    (
        .aHPo            (   aHPo             ),
        .aLNo            (   aLNo             ),
        .bHPo            (   bHPo             ),
        .bLNo            (   bLNo             ),
        .cHPo            (   cHPo             ),
        .cLNo            (   cLNo             ),

        .m3startI        (   m3startI         ),
        .m3speedDECi      (   m3speedDECi       ),
        .m3speedINCi      (   m3speedINCi       ),
        .m3powerINCi     (   m3powerINCi      ),
        .m3powerDECi     (   m3powerDECi      ),
        .m3forceStopI    (   m3forceStopI     ),
        .m3invRotateI    (   m3invRotateI     ),

        .nRstI           (   nRstI            ),
        .clkHIi          (   clk50mhzI        ),
        .clkI            (   clk1MhzW         )
    );

    clkGen_50Mhz_to_1Mhz
    ckGen
    (
        .nRstI           (   nRstI            ),
        .clk1mhzO       (   clk1MhzW         ),
        .clk50mhzI      (   clk50mhzI        )
    );

endmodule
