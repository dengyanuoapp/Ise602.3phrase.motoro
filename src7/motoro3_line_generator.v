module motoro3_line_generator(
    pwmLastStep1                ,
    pwmActive1                  ,

    posSumExtA                  ,	
    posSumExtB                  ,	
    posSumExtC                  ,	

    m3LpwmSplitStep             ,
    lgStep                      ,
    lgHp                        ,
    lgLp                        ,

    m3cnt                       ,
    m3cntLast1                  ,
    m3cntLast2                  ,
    m3cntFirst1                 ,
    m3cntFirst2                 ,

    m3r_power_percent           ,	
    m3r_stepCNT_speedSET        ,	
    m3r_pwmLenWant              ,
    m3r_pwmMinMask              ,
    m3r_stepSplitMax            ,	

    nRst                        ,
    clk

);

input   wire                pwmActive1              ;		
input   wire                pwmLastStep1            ;

output  wire    [15:0]      posSumExtA              ;	
input   wire    [15:0]      posSumExtB              ;	
input   wire    [15:0]      posSumExtC              ;	

output  wire                lgHp                    ;	
output  wire                lgLp                    ;	
                                                   
input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		
                                                   
input   wire    [1:0]       m3LpwmSplitStep         ;	
input   wire    [3:0]       lgStep                  ;	
input   wire    [24:0]      m3cnt                   ;	
input   wire                m3cntLast1              ;
input   wire                m3cntLast2              ;
input   wire                m3cntFirst1             ;		
input   wire                m3cntFirst2             ;		
input   wire    [7:0]       m3r_power_percent       ;	// to control the percent of power , max 255 % , min 1 %.
input   wire    [24:0]      m3r_stepCNT_speedSET    ;	 // to control the speed
input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [1:0]       m3r_stepSplitMax        ;	

wire                        lgEE                    ;		
wire                        lgForceLow              ;		
wire                        lgH1_L0                 ;		
                                                   
wire                        lgPWM                   ;	
wire            [15:0]      pwmLENpos                  ;	


motoro3_line_calc_parameter
lCalc
(
    .pwmLENpos                 ( pwmLENpos                    ),
    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),
    .m3LpwmSplitStep        ( m3LpwmSplitStep           ),
    .lcStep                 ( lgStep                    ) 
);// motoro3_line_calc_parameter 


motoro3_pwm_generator
pwmSG
(
    .pwmLastStep1           ( pwmLastStep1              ),
    .pwmActive1             ( pwmActive1                ),
    .posSumExtA             ( posSumExtA                ),
    .posSumExtB             ( posSumExtB                ),
    .posSumExtC             ( posSumExtC                ),
    .sgStep                 ( lgStep                    ),
    .pwmLENpos                 ( pwmLENpos                    ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),
    .pwm                    ( lgPWM                     ),
    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3cntLast2             ( m3cntLast2                ),
    .m3cntFirst1            ( m3cntFirst1               ),
    .m3cntFirst2            ( m3cntFirst2               ),
    .nRst                   ( nRst                      ),
    .clk                    ( clk                       ) 
);// motoro3_pwm_generator                             
                                                       
motoro3_step_to_mosdriver                              
lMos                                                   
(                                                      
    .xE                     ( lgEE                      ),
    .xForceLow              ( lgForceLow                ),
    .xH1_L0                 ( lgH1_L0                   ),
    .m3step                 ( lgStep                    ) 
); // motoro3_step_to_mosdriver lMos           
                                               
motoro3_mos_driver                             
mD                                             
(                                              
    .mosHp                  ( lgHp              ),
    .mosLp                  ( lgLp              ),
                                               
    .pwm                    ( lgPWM             ),
    .mosEnable              ( lgEE              ),
    .h1_L0                  ( lgH1_L0           ),
    .forceLow               ( lgForceLow        ),
                                               
    .nRst                   ( nRst              ),
    .clk                    ( clk               )  
); // motoro3_mos_driver mD


endmodule
