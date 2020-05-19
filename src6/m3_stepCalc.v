module m3_stepCalc (
    m3startI                        ,
    m3forceStopI                    ,
    m3invRotateI                    ,
    m3speedDECi                     ,
    m3speedINCi                     ,
    m3powerINCi                     ,
    m3powerDECi                     ,

    workingO                        ,
    dstRoundLenI                       ,

    clkI                            ,
    nRstI
);
    input   wire                m3startI        ;
    input   wire                m3forceStopI    ;
    input   wire                m3invRotateI    ;
    input   wire                m3speedDECi     ;
    input   wire                m3speedINCi     ;
    input   wire                m3powerINCi     ;
    input   wire                m3powerDECi     ;

    output  wire                workingO        ;
    input   wire                clkI            ;
    input   wire                nRstI           ;

    input   wire        [31:0]  dstRoundLenI       ;

    /*
    *
    * 1Mhz clock, 1us clock period; 
    * max sine wave freqence is 25kHz == 40us = 40 clk
    * min sine wave freqence is 0.25Hz == 4,000,000 us = 4,000,000 clk == 22'd4000000
    *
    * about the increase speed calc :
    * LLL={3/2, 5/4, 9/8, 17/16, 33/32} ; Fmin=40 ; Fmax=4000000 ;
    * Log[ LLL, (Fmax/Fmin) ] == {28.3944, 51.5943, 97.7469, 189.905, 374.141}
    * so, if the inc rate range from 1/2 to 1/32 , the required time from 28 to 374
    */
    `ifdef    simulating
        //    +define+simulating , to reduce the VCS debug time.
        //`define   clkPeriodMax      22'd400
        `define   clkPeriodMax      22'd300
        //`define   clkPeriodMax      22'd200
        //`define   clkPeriodMax      22'd100
    `else
        `define   clkPeriodMax      22'd4000000
    `endif
    `define   clkPeriodMin          22'd40
    `define   powerMax              10'd1000
    `define   powerInit             10'd100
    `define   roundMax              4'd3
    /*
    * Total Stotal    == (1.0 * powerLevel ) * len
    * up :   SAup     == ((0.5773502692 + 1) / 2 * powerLevel) * len == 0.7886751346 * Stotal
    *       Sup(xx_)  =  (0.5773502692 + ((( nowStepEndEdge / len ) * ( 1 - 0.5773502692)) / 2)) * Stotal
    * down : SAdown   == ((1 + 0.8660254038) / 2 * powerLevel) * len == 0.9330127019 * Stotal
    *     Sdown(xx_)  =  (1 - ( nowStepEndEdge / len ) * ( 1 - 0.8660254038) ) / 2 * Stotal
    */

    reg          [3:0]          step                    ;
    reg          [21:0]         remain                  ;
    reg          [21:0]         remain_next             ;
    wire                        nextStep    = (remain == 22'd1);
    wire                        nextRound   = 
        (nextStep == 1'b1 ) && ((step == 4'd15) || (step == 4'd11)) ;
    reg          [3:0]          sm                      ;
    reg          [3:0]          sm_next                 ;
    reg                         roundLast               ;
    reg          [3:0]          roundCnt1round          ;

    assign workingO   = ( m3startI == 1'b0 || step == 4'd15 ) ;


    parameter    SM_101_powerCalc_init      = 4'd0      ;
    parameter    SM_101_powerCalc_load_1    = 4'd1      ;
    parameter    SM_101_powerCalc_end       = 4'hF      ;

    always @( * ) begin
        sm_next             = sm                        ;
        case ( sm ) 
            SM_101_powerCalc_init :
                sm_next     = SM_101_powerCalc_load_1   ;
            SM_101_powerCalc_load_1 :
                sm_next     = SM_101_powerCalc_end      ;
        endcase
        if ( nextStep == 1'b1 && step == 4'd10 ) begin
            sm_next         = SM_101_powerCalc_init     ;
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            sm                  <= SM_101_powerCalc_init          ;
        end
        else begin
            if ( ! workingO ) begin
                sm              <= SM_101_powerCalc_init          ;
            end
            else begin
                sm              <= sm_next                        ;
            end
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            remain            <= dstRoundLenI               ;
        end
        else begin
            if ( ! workingO ) begin
                remain        <= dstRoundLenI               ;
            end
            else begin
                if ( nextStep == 1'b1 ) begin
                    remain    <= dstRoundLenI               ;
                end
                else begin
                    remain    <= remain    - 22'd1  ;
                end
            end
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            step                <= 4'hF                 ;
        end
        else begin
            if ( ! workingO ) begin
                step            <= 4'hF                 ;
            end
            else begin
                if ( nextStep == 1'b1 ) begin
                    if ( step == 4'd11 ) begin
                        step    <= 4'd0                 ;
                    end
                    else begin
                        step    <= step    + 4'd1       ;
                    end
                end
            end
        end
    end

endmodule
