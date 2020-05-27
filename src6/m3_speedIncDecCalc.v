`include "motor602_rtl_top.def.inc.v"
module m3_speedIncDecCalc (
    nextCalc_1I                     ,
    workingI                        ,
    m3invRotateI                    ,
    m3forceStopI                    ,
    m3speedDECi                     ,
    m3speedINCi                     ,

    dstRoundLenO                    ,

    clk100hzI                       ,
    clkI                            ,
    nRstI
);
    input   wire                nextCalc_1I     ;
    input   wire                workingI        ;
    input   wire                m3forceStopI    ;
    input   wire                m3invRotateI    ;
    input   wire                m3speedDECi     ;
    input   wire                m3speedINCi     ;

    input   wire                clk100hzI       ;
    input   wire                clkI            ;
    input   wire                nRstI           ;
    output  reg  [31:0]         dstRoundLenO    ;

    `define   clkPeriodMin          22'd40

    `define   roundMax              4'd3

    reg                         roundLast               ;
    reg          [3:0]          roundCnt1round          ;

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            dstRoundLenO                            <= `eachSlicePeriodMax        ;
        end
        else begin
            if ( workingI == 1'b0 ) begin
                dstRoundLenO                        <= `eachSlicePeriodMax        ;
            end
            else begin
                if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc freq 6.25%
                    if ( m3speedINCi == 1'b1 ) begin
                        if ( dstRoundLenO- dstRoundLenO[31:4] > `clkPeriodMin ) begin // reach max freq(min period)
                            dstRoundLenO       <= dstRoundLenO- dstRoundLenO[31:4] ;
                        end
                        else begin
                            dstRoundLenO       <= `clkPeriodMin        ;
                        end
                    end
                    else begin
                        if ( m3speedDECi == 1'b1 ) begin
                            if ( dstRoundLenO + dstRoundLenO[31:4] > `eachSlicePeriodMax ) begin // reach min freq(max period)
                                dstRoundLenO   <= `eachSlicePeriodMax        ;
                            end
                            else begin
                                dstRoundLenO   <= dstRoundLenO+ dstRoundLenO[31:4] ; 
                            end
                        end
                    end
                end
            end
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            dstRoundLenO                            <= `eachSlicePeriodMax        ;
            roundCnt1round                          <= `roundMax            ;
            roundLast                               <= 1'b0                 ;
        end
        else begin
            if ( workingI == 1'b0 ) begin
                dstRoundLenO                        <= `eachSlicePeriodMax        ;
                roundCnt1round                      <= `roundMax            ;
                roundLast                           <= 1'b0                 ;
            end
            else begin
                if ( nextCalc_1I  == 1'b1 ) begin
                    if ( m3speedINCi == 1'b1 ) begin
                        if ( roundLast == 1'b0 ) begin // ok , it is INCing
                            if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc freq 6.25%
                                roundCnt1round      <= `roundMax            ;
                                if ( dstRoundLenO- dstRoundLenO[31:4] > `clkPeriodMin ) begin // reach max freq(min period)
                                    dstRoundLenO       <= dstRoundLenO- dstRoundLenO[31:4] ;
                                end
                                else begin
                                    dstRoundLenO       <= `clkPeriodMin        ;
                                end
                            end
                            else begin
                                roundCnt1round      <= roundCnt1round - 4'd1      ;
                            end
                        end
                        else begin // transmit from DECing to INCing. reset counter.
                            roundCnt1round          <= `roundMax            ; 
                            roundLast               <= 1'b0                 ;
                        end
                    end 
                    else begin
                        if ( m3speedDECi == 1'b1 ) begin
                            if ( roundLast == 1'b1 ) begin // ok , it is DECing
                                if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc 6.25%, dec freq 6.25%
                                    roundCnt1round  <= `roundMax            ;
                                    if ( dstRoundLenO + dstRoundLenO[31:4] > `eachSlicePeriodMax ) begin // reach min freq(max period)
                                        dstRoundLenO   <= `eachSlicePeriodMax        ;
                                    end
                                    else begin
                                        dstRoundLenO   <= dstRoundLenO+ dstRoundLenO[31:4] ; 
                                    end
                                end
                                else begin
                                    roundCnt1round  <= roundCnt1round - 4'd1      ;
                                end
                            end
                            else begin // transmit from INCing to DECing . reset counter.
                                roundCnt1round      <= `roundMax            ; 
                                roundLast           <= 1'b1                 ; 
                            end
                        end 
                        else begin // not INCing , not DECing. reset counter.
                            roundCnt1round          <= `roundMax            ; 
                        end
                    end
                end
            end
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            dstRoundLenO                            <= `eachSlicePeriodMax        ;
            roundCnt1round                          <= `roundMax            ;
            roundLast                               <= 1'b0                 ;
        end
        else begin
            if ( workingI == 1'b0 ) begin
                dstRoundLenO                        <= `eachSlicePeriodMax        ;
                roundCnt1round                      <= `roundMax            ;
                roundLast                           <= 1'b0                 ;
            end
            else begin
                if ( nextCalc_1I  == 1'b1 ) begin
                    if ( m3speedINCi == 1'b1 ) begin
                        if ( roundLast == 1'b0 ) begin // ok , it is INCing
                            if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc freq 6.25%
                                roundCnt1round      <= `roundMax            ;
                                if ( dstRoundLenO- dstRoundLenO[31:4] > `clkPeriodMin ) begin // reach max freq(min period)
                                    dstRoundLenO       <= dstRoundLenO- dstRoundLenO[31:4] ;
                                end
                                else begin
                                    dstRoundLenO       <= `clkPeriodMin        ;
                                end
                            end
                            else begin
                                roundCnt1round      <= roundCnt1round - 4'd1      ;
                            end
                        end
                        else begin // transmit from DECing to INCing. reset counter.
                            roundCnt1round          <= `roundMax            ; 
                            roundLast               <= 1'b0                 ;
                        end
                    end 
                    else begin
                        if ( m3speedDECi == 1'b1 ) begin
                            if ( roundLast == 1'b1 ) begin // ok , it is DECing
                                if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc 6.25%, dec freq 6.25%
                                    roundCnt1round  <= `roundMax            ;
                                    if ( dstRoundLenO + dstRoundLenO[31:4] > `eachSlicePeriodMax ) begin // reach min freq(max period)
                                        dstRoundLenO   <= `eachSlicePeriodMax        ;
                                    end
                                    else begin
                                        dstRoundLenO   <= dstRoundLenO+ dstRoundLenO[31:4] ; 
                                    end
                                end
                                else begin
                                    roundCnt1round  <= roundCnt1round - 4'd1      ;
                                end
                            end
                            else begin // transmit from INCing to DECing . reset counter.
                                roundCnt1round      <= `roundMax            ; 
                                roundLast           <= 1'b1                 ; 
                            end
                        end 
                        else begin // not INCing , not DECing. reset counter.
                            roundCnt1round          <= `roundMax            ; 
                        end
                    end
                end
            end
        end
    end

endmodule
