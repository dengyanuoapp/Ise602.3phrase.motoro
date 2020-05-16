module motor602_real(
    aHpO,
    aLpO,
    bHpO,
    bLpO,
    cHpO,
    cLpO,

    m3startI        ,
    m3forceStopI    ,
    m3invRotateI    ,
    m3freqINCi      ,
    m3freqDECi      ,
    m3powerINCi     ,
    m3powerDECi     ,

    nRstI,
    clkI

);

output  wire                aHpO                     ;	
output  wire                aLpO                     ;	
output  wire                bHpO                     ;	
output  wire                bLpO                     ;	
output  wire                cHpO                     ;	
output  wire                cLpO                     ;	

input   wire                m3startI                 ;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3forceStopI             ;	 
input   wire                m3invRotateI             ;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire                m3freqINCi               ;	 
input   wire                m3freqDECi               ;	 
input   wire                m3powerINCi              ;	 
input   wire                m3powerDECi              ;	 

input   wire                clkI                     ;			// 1MHz
input   wire                nRstI                    ;		

motor3_irs2007s_driver
irsA(
    .HinO            ( aHpO ),
    .nLinO           ( aLpO ),
    .down1_up2i      ( 2'd0 )
);
motor3_irs2007s_driver
irsB(
    .HinO            ( bHpO ),
    .nLinO           ( bLpO ),
    .down1_up2i      ( 2'd0 )
);
motor3_irs2007s_driver
irsC(
    .HinO            ( cHpO ),
    .nLinO           ( cLpO ),
    .down1_up2i      ( 2'd0 )
);
                                                   


endmodule
