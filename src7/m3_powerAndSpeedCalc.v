module m3_powerAndSpeedCalc (
		m3startI                        ,
		m3forceStopI                    ,
		m3invRotateI                    ,
		m3freqINCi			    ,
		m3freqDECi			    ,
		m3powerINCi			    ,
		m3powerDECi			    ,

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
`define   clkPeriodMax      22'd400
`else
`define   clkPeriodMax      22'd4000000
`endif
`define   clkPeriodMin      22'd40

reg          [3:0]          step        ;


always @( posedge clkI or negedge nRstI ) begin
if ( ! nRstI ) begin
//step        <= 4'd0                  ;
step            <= 4'hF                  ;
end
else begin
if ( m3startI == 1'b0 ) begin
step        <= 4'hF                  ;
end
else begin
if ( step == 4'd11 ) begin
step    <= 4'd0              ;
end
else begin
step    <= step    + 4'd1    ;
end
end
end
end

endmodule
