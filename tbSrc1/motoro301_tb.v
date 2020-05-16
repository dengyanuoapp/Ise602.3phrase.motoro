
`timescale 10ns / 1ns

module motoro301_tb(
);

wire                        aHPw ;	
wire                        aLNw ;	
wire                        bHPw ;	
wire                        bLNw ;	
wire                        cHPw ;	
wire                        cLNw ;	
reg                         m3startR;	
reg                         m3forceStopR;	 
reg                         m3invRotateR;	 
reg                         m3freqINCr;	 
reg                         m3freqDECr;	 
reg                         m3powerINCr;	 
reg                         m3powerDECr;	 

wire                        tp01w;	
wire                        tp02w;	
wire                        uTxW;	

wire            [3:0]       led4W;	
reg                         clkR;			// 50MHz
reg                         nRstR;		// reset button on the core board

motoro301_rtl_top
rtlTop(
    .aHPo            (   aHPw             ),
    .aLNo            (   aLNw             ),
    .bHPo            (   bHPw             ),
    .bLNo            (   bLNw             ),
    .cHPo            (   cHPw             ),
    .cLNo            (   cLNw             ),
                                       
    .m3startI        (   m3startR        ),
    .m3freqINCi      (   m3freqINCr      ),
    .m3freqDECi      (   m3freqDECr      ),
    .m3powerINCi     (   m3powerINCr      ),
    .m3powerDECi     (   m3powerDECr      ),
    .m3forceStopI    (   m3forceStopR    ),
    .m3invRotateI    (   m3invRotateR    ),

    .tp01o           (   tp01w           ),
    .tp02o           (   tp02w           ),
    .uTxO            (   uTxW            ),
                   
    .led4O           (   led4W           ),
                   
    .nResetI         (   nRstR            ),
    .clk50mhzI       (   clkR             )
);

initial begin
    $fsdbDumpfile("verdi.fsdb") ;
    $fsdbDumpvars(0,motoro301_tb) ;
end

initial
begin

//    $dumpfile("Counter.vcd");
//    $dumpvars(0, Counter_tb);

    #1
    clkR = 0;
    nRstR = 1;

    #1
    nRstR = 0;

    m3startR = 0;	
    m3forceStopR = 0 ;	 
    m3invRotateR = 0 ;	 
    m3freqINCr   = 0 ;
    m3freqDECr   = 0 ;
    m3powerINCr   = 0 ;
    m3powerDECr   = 0 ;

    #1
    nRstR = 1;

    #10
    m3startR = 1;	

    #1_200_000      // 12ms
    #1_200_000      // 12ms
//    #7_200_000      // 12ms
    #9_600_000      // 12ms
`ifdef simulating
    #20_000_000       // 200ms
`endif
    //#10_000_000     // 100ms
    //#100_000_000    // 1s
    $finish;
end

always begin
    #1 clkR = !clkR ;
end

assign error01  = ({aHPw,bHPw,cHPw}==3'b000) ;
assign error11  = ({aLNw,bLNw,cLNw}==3'b100) ;
assign error12  = ({aLNw,bLNw,cLNw}==3'b010) ;
assign error13  = ({aLNw,bLNw,cLNw}==3'b001) ;
assign error14  = ({aLNw,bLNw,cLNw}==3'b000) ;
assign error19  = error11 | error12 | error13 | error14 ;
assign error91  = error01 & error19 ;
//assign error92  = (/motoro301_tb/rtl/m3t/r/lgA/pwmSG/unknowN1)? 1'b1:1'b0 ;
assign error92  = (rtlTop.m3t.r.lgA.pwmSG.unknowN1)? 1'b1:1'b0 ;



endmodule
