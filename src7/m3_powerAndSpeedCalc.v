module m3_powerAndSpeedCalc (
    m3startI                        ,
    m3forceStopI                    ,
    m3invRotateI                    ,
    m3freqINCi	                    ,
    m3freqDECi	                    ,
    m3powerINCi	                    ,
    m3powerDECi	                    ,

    clkI                            ,
    nRstI
);
input   wire                m3startI    ;
input   wire                m3forceStopI;
input   wire                m3invRotateI;
input   wire                m3freqINCi	;
input   wire                m3freqDECi	;
input   wire                m3powerINCi	;
input   wire                m3powerDECi	;

input wire                  clkI        ;
input wire                  nRstI       ;

reg          [3:0]          step        ;

always @( posedge clkI or negedge nRstI ) begin
    if ( ! nRstI ) begin
        step        <= 4'd0                  ;
    end
    else begin
        if ( 1 == 1 ) begin
            if ( step == 4'd12 ) begin
                step    <= 4'd1              ;
            end
            else begin
                step    <= step    + 4'd1    ;
            end
        end
    end
end

endmodule
