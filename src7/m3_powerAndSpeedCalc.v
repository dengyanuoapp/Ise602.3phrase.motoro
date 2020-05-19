module m3_powerAndSpeedCalc (
    m3startI                        ,
    m3forceStopI                    ,
    m3invRotateI                    ,
    m3speedDECi                     ,
    m3speedINCi                     ,
    m3powerINCi                     ,
    m3powerDECi                     ,

    clk100hzO                       ,
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

    output  wire                clk100hzO       ;
    input   wire                clkI            ;
    input   wire                nRstI           ;

    wire                        workingW        ;

    clkGen_1Mhz_to_100Hz
    cg100(
        .workingI       ( workingW      ),
        .clk100hzO      ( clk100hzO     ),
        .clkI           ( clkI          ),
        .nRstI          ( nRstI         )
    );

    m3_speedIncDecCalc
    spCalc(
    .nextRound_1I       ( 1'b0          ),
    .workingI           ( workingW      ),
    .m3invRotateI       ( m3invRotateI  ),
    .m3forceStopI       ( m3forceStopI  ),
    .m3speedDECi        ( m3speedDECi   ),
    .m3speedINCi        ( m3speedINCi   ),
    .clk100hzO          ( clk100hzO     ),
    .clkI               ( clkI          ),
    .nRstI              ( nRstI         )
    );

    m3_roundCalc
    rCalc(
        .m3startI       ( m3startI           ),
        .m3forceStopI   ( m3forceStopI       ),
        .m3invRotateI   ( m3invRotateI       ),
        .m3speedDECi    ( m3speedDECi        ),
        .m3speedINCi    ( m3speedINCi        ),
        .m3powerINCi    ( m3powerINCi        ),
        .m3powerDECi    ( m3powerDECi        ),
        .clk100hzO      ( clk100hzO          ),
        .clkI           ( clkI               ),
        .nRstI          ( nRstI              )
    );

    `ifdef    simulating
        reg          [31:0]          Sum_full           ;
        reg          [31:0]          Sum_up             ;
        reg          [31:0]          Sum_down           ;
        always @( posedge clkI or negedge nRstI ) begin
            if ( ! nRstI ) begin
                Sum_full            <= 4'h0             ;
            end
            else begin
                if ( ! workingW ) begin
                    Sum_full        <= 31'h0            ;
                    Sum_up          <= 31'h0            ;
                    Sum_down        <= 31'h0            ;
                end
                else begin
                    if ( (0 == Sum_full) || (1 == remain) ) begin
                        Sum_full    <= `clkPeriodMax * `powerMax             ;
                    end
                end
            end
        end
    `endif

endmodule
