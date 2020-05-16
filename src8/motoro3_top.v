module motoro3_top(
    aHPo,
    aLNo,
    bHPo,
    bLNo,
    cHPo,
    cLNo,

    m3startI        ,
    m3forceStopI    ,
    m3invRotateI    ,
    m3freqINCi      ,
    m3freqDECi      ,

    nRstI,
    clkHIi,
    clkI

);

output  reg                 aHPo ;	
output  reg                 aLNo ;	
output  reg                 bHPo ;	
output  reg                 bLNo ;	
output  reg                 cHPo ;	
output  reg                 cLNo ;	

input   wire                m3startI;	
input   wire                m3forceStopI;	 
input   wire                m3invRotateI;	 
input   wire                m3freqINCi	;
input   wire                m3freqDECi	;

input   wire                clkHIi;
input   wire                clkI;			// 10MHz
input   wire                nRstI;		

reg                         m3start_clked1       ;	
reg                         m3forceStop_clked1   ;	 
reg                         m3invRotate_clked1   ;	 
reg                         m3freqINC_clked1;	 
reg                         m3freqDEC_clked1;	 

wire                        aH_ii       ;	
wire                        aL_ii       ;	
wire                        bH_ii       ;	
wire                        bL_ii       ;	
wire                        cH_ii       ;	
wire                        cL_ii       ;	

always @ (posedge clkI or negedge nRstI) begin
    if(!nRstI) begin
        m3start_clked1              <= 0                ;
        m3freqINC_clked1            <= 0                ;
        m3freqDEC_clked1            <= 0                ;
        m3forceStop_clked1          <= 0                ;
        m3invRotate_clked1          <= 0                ;
    end
    else begin
        m3start_clked1              <= m3startI          ;
        m3forceStop_clked1          <= m3forceStopI      ;
        m3invRotate_clked1          <= m3invRotateI      ;
        m3freqINC_clked1            <= m3freqINCi       ;
        m3freqDEC_clked1            <= m3freqDECi       ;

        if ( m3freqINCi== 1'b1 ) begin
            m3freqDEC_clked1        <= 1'b0             ;
        end
    end
end

`define LOWmosINV    ^ 1'b1
//`define LOWmosINV    

`define Aenable     1'b1
`define Benable     1'b1
`define Cenable     1'b1

always @ (posedge clkI or negedge nRstI) begin
    if(!nRstI) begin
        aHPo                         <= 0                ;
        bHPo                         <= 0                ;
        cHPo                         <= 0                ;
        aLNo                         <= 0 `LOWmosINV     ;
        bLNo                         <= 0 `LOWmosINV     ;
        cLNo                         <= 0 `LOWmosINV     ;
    end
    else begin
        aHPo                         <= ( aH_ii & `Aenable )       ;
        bHPo                         <= ( bH_ii & `Benable )       ;
        cHPo                         <= ( cH_ii & `Cenable )       ;

        aLNo                         <= ( aL_ii & `Aenable )  `LOWmosINV          ;
        bLNo                         <= ( bL_ii & `Benable )  `LOWmosINV          ;
        cLNo                         <= ( cL_ii & `Cenable )  `LOWmosINV          ;
    end
end


motoro3_real
r
(
    .aHp                    (   aH_ii                   ),
    .aLp                    (   aL_ii                   ),
    .bHp                    (   bH_ii                   ),
    .bLp                    (   bL_ii                   ),
    .cHp                    (   cH_ii                   ),
    .cLp                    (   cL_ii                   ),
                                               
    .m3start                (   m3start_clked1          ),
    .m3freqINC              (   m3freqINC_clked1        ),
    .m3freqDEC              (   m3freqDEC_clked1        ),
    .m3forceStop            (   m3forceStop_clked1      ),
    .m3invRotate            (   m3invRotate_clked1      ),
                           
    .nRst                   (   nRstI                   ),
    .clk                    (   clkI                    )
);

endmodule
