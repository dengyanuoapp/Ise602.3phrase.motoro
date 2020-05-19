module m3_speedIncDecCalc (
    nextRound_1I                      ,
    workingI                        ,
    m3invRotateI                    ,
    m3forceStopI                    ,
    m3speedDECi                     ,
    m3speedINCi                     ,

    clk100hzO                       ,
    clkI                            ,
    nRstI
);
    input   wire                nextRound_1I      ;
    input   wire                workingI        ;
    input   wire                m3forceStopI    ;
    input   wire                m3invRotateI    ;
    input   wire                m3speedDECi     ;
    input   wire                m3speedINCi     ;

    output  wire                clk100hzO       ;
    input   wire                clkI            ;
    input   wire                nRstI           ;

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

    `define   roundMax              4'd3

    reg          [31:0]         roundLen                ;
    reg                         roundLast               ;
    reg          [3:0]          roundCnt1round          ;

    `ifdef  simulating
        `define      clk100hzMax    14'd9998
    `else
        //`define      clk100hzMax    14'd98
        `define      clk100hzMax    14'd9998
    `endif
    reg          [14:0]         clk100hzCNT ;

    assign clk100hzO    = clk100hzCNT[14] ;
    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            clk100hzCNT         <= `clk100hzMax         ;
        end
        else begin
            if ( workingI == 1'b0 ) begin
                clk100hzCNT     <= `clk100hzMax         ;
            end
            else begin
                if ( clk100hzO ) begin
                    clk100hzCNT <= `clk100hzMax         ;
                end
                else begin
                    clk100hzCNT <= clk100hzCNT - 15'd1  ;
                end
            end
        end
    end

    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            roundLen                                <= `clkPeriodMax        ;
            roundCnt1round                          <= `roundMax            ;
            roundLast                               <= 1'b0                 ;
        end
        else begin
            if ( workingI == 1'b0 ) begin
                roundLen                            <= `clkPeriodMax        ;
                roundCnt1round                      <= `roundMax            ;
                roundLast                           <= 1'b0                 ;
            end
            else begin
                if ( nextRound_1I == 1'b1 ) begin
                    if ( m3speedINCi == 1'b1 ) begin
                        if ( roundLast == 1'b0 ) begin // ok , it is INCing
                            if ( roundCnt1round == 4'd0 ) begin // 1/16 --> inc freq 6.25%
                                roundCnt1round      <= `roundMax            ;
                                if ( roundLen - roundLen[31:4] > `clkPeriodMin ) begin // reach max freq(min period)
                                    roundLen        <= roundLen - roundLen[31:4] ;
                                end
                                else begin
                                    roundLen        <= `clkPeriodMin        ;
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
                                    if ( roundLen + roundLen[31:4] > `clkPeriodMax ) begin // reach min freq(max period)
                                        roundLen    <= `clkPeriodMax        ;
                                    end
                                    else begin
                                        roundLen    <= roundLen + roundLen[31:4] ; 
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
