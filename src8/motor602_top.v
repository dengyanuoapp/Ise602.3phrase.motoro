module motor602_top(
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
    m3powerINCi      ,
    m3powerDECi      ,

    nRstI,
    clkHIi,
    clkI

);

output  wire                aHPo ;	
output  wire                aLNo ;	
output  wire                bHPo ;	
output  wire                bLNo ;	
output  wire                cHPo ;	
output  wire                cLNo ;	

input   wire                m3startI;	
input   wire                m3forceStopI;	 
input   wire                m3invRotateI;	 
input   wire                m3freqINCi	;
input   wire                m3freqDECi	;
input   wire                m3powerINCi	;
input   wire                m3powerDECi	;

input   wire                clkHIi;
input   wire                clkI;			// 10MHz
input   wire                nRstI;		

reg   [6:0]                 regclked       ;	

always @ (posedge clkI or negedge nRstI) begin
    if(!nRstI) begin
        regclked              <= 6'd0                ;
    end
    else begin
        regclked       <= { 
        m3startI             ,
        m3forceStopI         ,
        m3invRotateI         ,
        m3freqINCi           ,
        m3freqDECi           ,
        m3powerINCi          ,
        m3powerDECi          } ;
    end
end



motor602_real
r
(
    .aHpO                   ( aHPo                     ),
    .aLpO                   ( aLNo                     ),
    .bHpO                   ( bHPo                     ),
    .bLpO                   ( bLNo                     ),
    .cHpO                   ( cHPo                     ),
    .cLpO                   ( cLNo                     ),

    .m3startI               ( regclked[6]              ),
    .m3forceStopI           ( regclked[5]              ),
    .m3invRotateI           ( regclked[4]              ),
    .m3freqINCi             ( regclked[3]              ),
    .m3freqDECi             ( regclked[2]              ),
    .m3powerINCi            ( regclked[1]              ),
    .m3powerDECi            ( regclked[0]              ),

    .nRstI                  (   nRstI                   ),
    .clkI                   (   clkI                    )
);

endmodule
