module motoro3_real(
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
                                                   
wire            [1:0]       m3LpwmSplitStep          ;	
wire            [3:0]       m3LstepA                ;	
wire            [3:0]       m3LstepB                ;	
wire            [3:0]       m3LstepC                ;	
wire            [24:0]      m3cnt                   ;	
wire                        m3cntLast1              ;
wire                        m3cntLast2              ;
wire                        m3cntFirst1             ;
wire                        m3cntFirst2             ;
wire            [24:0]      m3r_stepCNT_speedSET    ;	
wire            [7:0]       m3r_power_percent       ;	
wire            [11:0]      m3r_pwmLenWant          ;	
wire            [11:0]      m3r_pwmMinMask          ;	
wire            [1:0]       m3r_stepSplitMax        ;	
wire            [15:0]      posSumExtAA             ;	
wire            [15:0]      posSumExtBB             ;	
wire            [15:0]      posSumExtCC             ;	
wire                        pwmActive1              ;
wire                        pwmLastStep1            ;

motoro3_regs
m3reg
(
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),

    .nRst                   ( nRstI                     ),
    .clk                    ( clkI                      )
);// motoro3_state_machine

motoro3_step_generator
sg
(
    .pwmActive1             ( pwmActive1                ),
    .pwmLastStep1           ( pwmLastStep1              ),

    .m3LpwmSplitStep        ( m3LpwmSplitStep           ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),

    .m3stepA                ( m3LstepA                  ),
    .m3stepB                ( m3LstepB                  ),
    .m3stepC                ( m3LstepC                  ),
                                                       
    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3cntLast2             ( m3cntLast2                ),
    .m3cntFirst1            ( m3cntFirst1               ),
    .m3cntFirst2            ( m3cntFirst2               ),
    .m3start                ( m3startI                  ),
    .m3freqINC              ( m3freqINCi                ),
    .m3freqDEC              ( m3freqDECi                ),

    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),

    .nRst                   ( nRstI                     ),
    .clk                    ( clkI                      )
);// motoro3_state_machine

motoro3_line_generator
lgA
(
    .pwmActive1             ( pwmActive1                ),
    .pwmLastStep1           ( pwmLastStep1              ),

    .posSumExtA             ( posSumExtAA               ),
    .posSumExtB             ( posSumExtBB               ),
    .posSumExtC             ( posSumExtCC               ),
    .m3LpwmSplitStep        ( m3LpwmSplitStep           ),
    .lgStep                 ( m3LstepA                  ),
    .lgHp                   ( aHpO                       ),
    .lgLp                   ( aLpO                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3cntLast2             ( m3cntLast2                ),
    .m3cntFirst1            ( m3cntFirst1               ),
    .m3cntFirst2            ( m3cntFirst2               ),

    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),

    .nRst                   ( nRstI                     ),
    .clk                    ( clkI                      )  
);// motoro3_line_generator lgA
motoro3_line_generator
lgB
(
    .pwmActive1             ( pwmActive1                ),
    .pwmLastStep1           ( pwmLastStep1              ),

    .posSumExtA             ( posSumExtBB               ),
    .posSumExtB             ( posSumExtCC               ),
    .posSumExtC             ( posSumExtAA               ),
    .m3LpwmSplitStep        ( m3LpwmSplitStep           ),
    .lgStep                 ( m3LstepB                  ),
    .lgHp                   ( bHpO                       ),
    .lgLp                   ( bLpO                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3cntLast2             ( m3cntLast2                ),
    .m3cntFirst1            ( m3cntFirst1               ),
    .m3cntFirst2            ( m3cntFirst2               ),

    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),

    .nRst                   ( nRstI                     ),
    .clk                    ( clkI                      )  
);// motoro3_line_generator lgB
motoro3_line_generator
lgC
(
    .pwmActive1             ( pwmActive1                ),
    .pwmLastStep1           ( pwmLastStep1              ),

    .posSumExtA             ( posSumExtCC               ),
    .posSumExtB             ( posSumExtAA               ),
    .posSumExtC             ( posSumExtBB               ),
    .m3LpwmSplitStep        ( m3LpwmSplitStep           ),
    .lgStep                 ( m3LstepC                  ),
    .lgHp                   ( cHpO                       ),
    .lgLp                   ( cLpO                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3cntLast2             ( m3cntLast2                ),
    .m3cntFirst1            ( m3cntFirst1               ),
    .m3cntFirst2            ( m3cntFirst2               ),

    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),

    .nRst                   ( nRstI                     ),
    .clk                    ( clkI                      )  
);// motoro3_line_generator lgC

endmodule
