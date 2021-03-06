
`timescale 10ns / 1ns

module motor602_tb(
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
    reg                         m3speedDECr;	 
    reg                         m3speedINCr;	 
    reg                         m3powerINCr;	 
    reg                         m3powerDECr;	 

    wire                        tp01w;	
    wire                        tp02w;	
    wire                        uTxW;	

    wire            [3:0]       led4W;	
    reg                         clkR;			// 50MHz
    reg                         nRstR;		// reset button on the core board

    motor602_rtl_top
    rtlTop(
        .aHPo            (   aHPw             ),
        .aLNo            (   aLNw             ),
        .bHPo            (   bHPw             ),
        .bLNo            (   bLNw             ),
        .cHPo            (   cHPw             ),
        .cLNo            (   cLNw             ),

        .m3startI        (   m3startR        ),
        .m3speedDECi      (   m3speedDECr      ),
        .m3speedINCi      (   m3speedINCr      ),
        .m3powerINCi     (   m3powerINCr      ),
        .m3powerDECi     (   m3powerDECr      ),
        .m3forceStopI    (   m3forceStopR    ),
        .m3invRotateI    (   m3invRotateR    ),

        .tp01o           (   tp01w           ),
        .tp02o           (   tp02w           ),
        .uTxO            (   uTxW            ),

        .led4O           (   led4W           ),

        .nRstI           (   nRstR            ),
        .clk50mhzI       (   clkR             )
    );

    initial begin
        //$fsdbDumpfile("/tmp/verdi.fsdb") ;
        $fsdbDumpfile("verdi.fsdb") ;
        $fsdbDumpvars(0,motor602_tb) ;
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
            #40_000_000       // 200ms
        `endif
        //#10_000_000     // 100ms
        //#100_000_000    // 1s
        $finish;
    end

    initial begin
        #1
        m3speedDECr   = 0 ;
        m3speedINCr   = 0 ;

        #10
        m3speedINCr   = 1 ;
        #23000000
        m3speedINCr   = 0 ;

        #10
        m3speedDECr   = 1 ;
        #23000000
        m3speedDECr   = 0 ;
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
    //assign error92  = (rtlTop.m3t.r.lgA.pwmSG.unknowN1)? 1'b1:1'b0 ;
    assign error92  = 1'b0;



endmodule
