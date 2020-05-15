module motoro3_top(
    aHP,
    aLN,
    bHP,
    bLN,
    cHP,
    cLN,

    m3start         ,
    m3forceStop     ,
    m3invRotate     ,
    m3freqINC       ,
    m3freqDEC       ,

    nRst,
    clkHI,
    clk

);

output  reg                 aHP ;	
output  reg                 aLN ;	
output  reg                 bHP ;	
output  reg                 bLN ;	
output  reg                 cHP ;	
output  reg                 cLN ;	

input   wire                m3start;	
input   wire                m3forceStop;	 
input   wire                m3invRotate;	 
input   wire                m3freqINC;	 
input   wire                m3freqDEC;	 

input   wire                clkHI;
input   wire                clk;			// 10MHz
input   wire                nRst;		

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

always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked1              <= 0                ;
        m3freqINC_clked1            <= 0                ;
        m3freqDEC_clked1            <= 0                ;
        m3forceStop_clked1          <= 0                ;
        m3invRotate_clked1          <= 0                ;
    end
    else begin
        m3start_clked1              <= m3start          ;
        m3forceStop_clked1          <= m3forceStop      ;
        m3invRotate_clked1          <= m3invRotate      ;
        m3freqINC_clked1            <= m3freqINC        ;
        m3freqDEC_clked1            <= m3freqDEC        ;

        if ( m3freqINC == 1'b1 ) begin
            m3freqDEC_clked1        <= 1'b0             ;
        end
    end
end

`define LOWmosINV    ^ 1'b1
//`define LOWmosINV    

`define Aenable     1'b1
`define Benable     1'b1
`define Cenable     1'b1

always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        aHP                         <= 0                ;
        bHP                         <= 0                ;
        cHP                         <= 0                ;
        aLN                         <= 0 `LOWmosINV     ;
        bLN                         <= 0 `LOWmosINV     ;
        cLN                         <= 0 `LOWmosINV     ;
    end
    else begin
        aHP                         <= ( aH_ii & `Aenable )       ;
        bHP                         <= ( bH_ii & `Benable )       ;
        cHP                         <= ( cH_ii & `Cenable )       ;

        aLN                         <= ( aL_ii & `Aenable )  `LOWmosINV          ;
        bLN                         <= ( bL_ii & `Benable )  `LOWmosINV          ;
        cLN                         <= ( cL_ii & `Cenable )  `LOWmosINV          ;
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
                           
    .nRst                   (   nRst                    ),
    .clk                    (   clk                     )
);

endmodule
