`include "motor602_rtl_top.def.inc.v"
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

    reg          [3:0]          step                    ;
    reg          [21:0]         remain                  ;
    reg          [21:0]         remain_next             ;
    wire                        nextStep    = (remain == 22'd1);
    wire                        nextRound   = 
        (nextStep == 1'b1 ) && ((step == 4'd15) || (step == 4'd11)) ;

    assign workingO   = ( m3startI == 1'b0 || step == 4'd15 ) ;


    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            remain            <= `eachSlicePeriodMax        ;
            //remain            <= dstRoundLenI               ;
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
