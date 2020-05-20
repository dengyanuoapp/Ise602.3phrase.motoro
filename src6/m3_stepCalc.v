`include "motor602_rtl_top.def.inc.v"
module m3_stepCalc (
    m3startI                        ,
    m3forceStopI                    ,
    m3invRotateI                    ,
    m3speedDECi                     ,
    m3speedINCi                     ,
    m3powerINCi                     ,
    m3powerDECi                     ,

    nextCalc_1o                     ,
    workingO                        ,
    dstRoundLenI                    ,

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
    output  wire                nextCalc_1o     ;
    input   wire                clkI            ;
    input   wire                nRstI           ;

    input   wire        [31:0]  dstRoundLenI       ;

    reg          [3:0]          step                    ;
    reg          [21:0]         remain                  ;
    reg          [21:0]         remain_next             ;
    wire    nextStep_1  = (remain == 22'd1);
    wire    nextRound   = (nextStep_1 == 1'b1 ) && ((step == 4'd15) || (step == 4'd11)) ;
    assign  nextCalc_1o = (nextStep_1 && (step == 4'd10)) ;

    assign workingO   = ( m3startI && (step != 4'd15 )) ;


    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            remain            <= `eachSlicePeriodMax        ;
            //remain            <= dstRoundLenI               ;
        end
        else begin
            if ( ! m3startI ) begin
                remain        <= `eachSlicePeriodMax        ;
            end
            else begin
                if ( nextStep_1 ) begin
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
            if ( ! m3startI ) begin
                step            <= 4'hF                 ;
            end
            else begin
                if ( nextStep_1 == 1'b1 ) begin
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
