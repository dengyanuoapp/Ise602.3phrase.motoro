module motoro3_pwm_generator(
    pwmLastStep1                ,
    pwmActive1                  ,

    posSumExtA                  ,	
    posSumExtB                  ,	
    posSumExtC                  ,	

    sgStep                      ,
    pwmLENpos                   ,
                               
    m3r_pwmLenWant              ,
    m3r_pwmMinMask              ,
    m3r_stepSplitMax            ,	
    pwm                         ,		
                               
    m3cnt                       ,
    m3cntLast1                  ,
    m3cntLast2                  ,
    m3cntFirst1                 ,
    m3cntFirst2                 ,
                               
    nRst                        ,
    clk

);

input   wire                pwmLastStep1            ;
input   wire                pwmActive1              ;		

output  wire    [15:0]      posSumExtA              ;	
input   wire    [15:0]      posSumExtB              ;	
input   wire    [15:0]      posSumExtC              ;	

input   wire    [3:0]       sgStep                  ;	
input   wire    [15:0]      pwmLENpos               ;	

input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [1:0]       m3r_stepSplitMax        ;	
output  wire                pwm                     ;		

input   wire                m3cntLast1              ;		
input   wire                m3cntLast2              ;		
input   wire                m3cntFirst1             ;		
input   wire                m3cntFirst2             ;		
input   wire    [24:0]      m3cnt                   ;	

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		

reg             [15:0]      pwmLENpos_clked1        ;	

reg             [11:0]      pwmCNT                  ;	
wire                        pwmCNTreload1           ;
wire                        pwmCNTreload3           ;

reg             [15:0]      pwmPOScnt               ;	

reg             [15:0]      posRemain1              ;	
wire            [15:0]      calcSum1                ;	
wire            [15:0]      calcSum2                ;	
wire            [15:0]      calcSum3                ;	
wire            [15:0]      calcSum4                ;	
wire            [15:0]      calcSum5                ;	
wire            [15:0]      calcSum6                ;	
reg             [15:0]      calcSumX                ;	

wire            [7:0]       posST1                  ;
reg             [3:0]       posLoad1                ;
reg             [3:0]       remainLoad1             ;
reg             [1:0]       unknowN1                ;

reg             [15:0]      posACCwant1             ;	
reg             [15:0]      posACCwant2             ;	
reg             [15:0]      posACCwant3             ;	
reg             [15:0]      posACCwant4             ;	
reg             [15:0]      posACCreal1             ;	
reg             [15:0]      posACCreal2             ;	
reg             [15:0]      posACCreal3             ;	
reg             [15:0]      posACCreal4             ;	

wire            [15:0]      pwmMinNow               ;	
reg             [15:0]      posLost1                ;	
wire            [15:0]      posLost2                ;	
reg             [15:0]      posLost3                ;	
wire            [15:0]      posLost4                ;	
reg             [15:0]      posStep                 ;	
reg                         pwmH1L0                 ;	

reg                         m3cntLast3              ;		
reg                         m3cntFirst3             ;		

wire                        sR_Step11C              = ( sgStep == 4'd11 ) ;
wire                        sR_Step6B               = ( sgStep == 4'd6  ) ;
wire                        sR_lastCheckMinX        = ( calcSum5    >= pwmMinNow )   ;// 1 : Remain1 + 3 * POSlen     >= posMIN
wire                        sR_minCheckMinX         = ( calcSum1    >= pwmMinNow )   ;
wire                        sR_minCheckExtXb        = ( sR_Step6B  && ( posSumExtB >= calcSum1) ) ;
wire                        sR_minCheckExtXc        = ( sR_Step11C && ( posSumExtC >= calcSum1) ) ;
wire                        sR_minCheckExtX         = sR_minCheckExtXb | sR_minCheckExtXc ;
wire                        sR_lastPeriod           = ( pwmLastStep1 && (m3cnt < {m3r_pwmLenWant, 1'b0} ))    ;
wire                        sR_runing0_noRun1       = ( sgStep >= 4'd12 )   ;

wire                        pwmLastStep2            = sR_lastPeriod ;

// // // clk freq : 10Mhz , 100ns , 0.1us
// // // max period   : 0xfff : 4095 * 0.1us == 410us --> 2.44kHz
// // // min MOS open : 0x10  : 16   * 0.1us == 1.6us  (min set to 16: mosDriver2003/2007 raise/failing time 150ns )
// // // min MOS open : 0x20  : 32   * 0.1us == 3.2us  (min set to 32: mosDriver2003/2007 raise/failing time 150ns )
// // 
// // //`define pwmTest      12'h10 //   16(0x10) of 511(0x1ff) * 0.1us == 1.6us // test , failed , MOS can not work. none wave in the MOSFET
// // `define pwmTest      12'h20 //   32(0x20) of 511(0x1ff) * 0.1us == 3.1us // so , this is the min can be used.
// // //`define pwmTest      12'h40 //   64(0x40) of 511(0x1ff) * 0.1us == 6.4us
// // //`define pwmTest      12'h80 // 
// // //`define pwmTest      12'h100 // 
// // //`define pwmTest      12'h110 //  half of 511(0x1ff) * 0.1us == 26us
// // //`define pwmTest      5'h10 // 1.56us // lost... the FPGA output lost... so, the MOSFET must be lost.

assign pwmCNTreload1 = (pwmCNT == 16'd1 ) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNT                  <= m3r_pwmLenWant ;
    end
    else begin
        if ( ! pwmActive1 ) begin
            pwmCNT              <= m3r_pwmLenWant ;
        end
        else begin
            if ( m3cntLast1 ) begin
                pwmCNT          <= m3r_pwmLenWant ;
            end
            else begin
                if ( pwmCNTreload1 ) begin
                    pwmCNT      <= m3r_pwmLenWant ;
                end
                else begin
                    pwmCNT      <= pwmCNT  - 9'd1 ;
                end
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCreal1             <= 12'd0 ;
    end
    else begin
        if ( m3cntLast2 == 1'd1 ) begin
            posACCreal1         <= 16'd0    ;
        end
        else begin
            if ( pwm == 1'd1 ) begin
                posACCreal1     <=  posACCreal1+ 16'd1 ;
            end
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant2             <= 16'd0    ;
        posACCreal2             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            posACCwant2         <= posACCwant1 ;
            posACCreal2         <= posACCreal1 ;
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant3             <= 16'd0    ;
        posACCreal3             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            case ( sgStep )
                4'd0, 4'd3, 4'd6, 4'd9  : posACCwant3         <= posACCwant1 ;
                default                 : posACCwant3         <= posACCwant3 + posACCwant1 ;
            endcase
            case ( sgStep )
                4'd0, 4'd3, 4'd6, 4'd9  : posACCreal3         <= posACCreal1 ;
                default                 : posACCreal3         <= posACCreal3 + posACCreal1 ;
            endcase
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant4             <= 16'd0    ;
        posACCreal4             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            case ( sgStep )
                4'd0, 4'd6              : posACCwant4         <= posACCwant1 ;
                default                 : posACCwant4         <= posACCwant4 + posACCwant1 ;
            endcase
            case ( sgStep )
                4'd0, 4'd6              : posACCreal4         <= posACCreal1 ;
                default                 : posACCreal4         <= posACCreal4 + posACCreal1 ;
            endcase
        end
    end
end

//assign pwmMinNow    = (m3r_pwmLenWant[11] == 1'b1 ) ? ({4'd0,m3r_pwmMinMask}) : (16'h8000);
//assign pwmMinNow    = ({4'd0,m3r_pwmMinMask}) ;
assign pwmMinNow    = 12'd256;
//assign pwmMinNow    = 12'd32;
//assign pwmMinNow    = 12'd16;


// 100: 4 : load MaxPWM
// 010: 2 : load posEXT
// 001: 1 : load Remain + pos
// 000: 0 : not load
assign posST1 = {
    1'b0,
    sR_lastCheckMinX,           // 1 : calcSum1 + 2 * POSlen     >= posMIN
    sR_minCheckMinX,            // 1 : calcSum1      >= posMIN
    sR_minCheckExtX ,           // 1 : posSumExt    >= calcSum1

    sR_Step11C ,                // 1 : during PWM step 11, pull up by C
    sR_Step6B ,                 // 1 : during PWM step 6,  pull up by B
    sR_lastPeriod ,             // 1 : during last 2nd PWM period
    sR_runing0_noRun1           // 1 : no runing
} ;


assign calcSum1 = posRemain1    + pwmLENpos ;
assign calcSum2 = posRemain1    + pwmLENpos_clked1 ;
assign calcSum3 = calcSum1      + pwmLENpos ;
assign calcSum4 = 0             - pwmLENpos ;
assign calcSum5 = calcSum3      + pwmLENpos ;
assign calcSum6 = 16'h8000 ;
`define remainLoadAddPos    4'd1
`define remainLoadZero1     4'd3
`define remainLoadSum1      4'd5
`define remainLoadSum2      4'd7
`define remainLoadSum3      4'd9
`define remainLoadSum4      4'd11
`define remainLoadSum6      4'd13
`define remainLoadDonTouch  4'd14
`define remainLoadInit      4'd15
always @( calcSum1 or pwmMinNow or sgStep or posSumExtB or posSumExtC or m3cnt or calcSum2 or pwmActive1 ) begin
    remainLoad1 <= `remainLoadDonTouch ;
    unknowN1[0] <= 1'b1 ;
    if ( pwmCNTreload1 ) begin
        case ( posST1 ) 
            8'd20 /*0x14*/,
            8'd64 /*0x40*/,
            8'd68 /*0x44*/,
            8'd116 /*0x74*/,
            8'd4          ,
            8'd0          : begin unknowN1[0] <= 1'b0 ;    remainLoad1 <= `remainLoadAddPos ;   end

            8'd100/*0x64*/,
            8'd96 /*0x60*/: begin unknowN1[0] <= 1'b0 ;    remainLoad1 <= `remainLoadSum4  ;   end /* load and reset the CNT */

            8'd2          ,
            8'd22 /*0x16*/,
            8'd66 /*0x42*/: begin unknowN1[0] <= 1'b0 ;    remainLoad1 <= `remainLoadSum6  ;   end /* load and reset the CNT */
            //default :   begin end
        endcase
    end
    if ( m3cntFirst1 ) begin    unknowN1[0] <= 1'b0 ;   remainLoad1 <=  `remainLoadSum2     ; end
    if ( m3cntFirst2 ) begin    unknowN1[0] <= 1'b0 ;   remainLoad1 <=  `remainLoadZero1    ; end
    if ( !pwmActive1 ) begin    unknowN1[0] <= 1'b0 ;   remainLoad1 <= `remainLoadInit      ; end
end

`define posLoadPosSum1          4'd1
`define posLoadPosSum2          4'd2
`define posLoadPosSum3          4'd3
`define posLoadPosSum5          4'd4
`define posLoadDonTouch         4'd5
`define posLoadDec1             4'd6
`define posLoadZero             4'd15
always @( calcSum1 or pwmMinNow or sgStep or posSumExtB or posSumExtC or m3cnt 
    or calcSum2 or pwmActive1 or pwmPOScnt or posST1 or pwmCNTreload1 or m3cntLast2 ) begin
    posLoad1    <= `posLoadDonTouch ;
    unknowN1[1] <= 1'b1 ;
    if ( pwmPOScnt )        begin       posLoad1    <= `posLoadDec1 ;       unknowN1[1] <= 1'b0 ;   end
    if ( pwmCNTreload1 )    begin
        case ( posST1 ) 
            8'd100/*0x64*/,
            8'd96 /*0x60*/: begin       posLoad1    <= `posLoadPosSum3 ;    unknowN1[1] <= 1'b0 ;   end /* load and reset the CNT */

            8'd2          ,
            8'd22 /*0x16*/,
            8'd66 /*0x42*/: begin       posLoad1    <= `posLoadPosSum5 ;    unknowN1[1] <= 1'b0 ;   end /* load the last remainS */
            //default :   begin end
        endcase
    end
    if ( m3cntLast2 )       begin       posLoad1    <= `posLoadZero ;       unknowN1[1] <= 1'b0 ;   end   
    if ( !pwmActive1 )      begin       posLoad1    <= `posLoadZero ;       unknowN1[1] <= 1'b0 ;   end
end
always @( remainLoad1 or calcSum1 or calcSum2 ) begin
    case ( remainLoad1 )
        `remainLoadInit     : calcSumX   =   16'hFFFF   ;
        `remainLoadAddPos   : calcSumX   =   calcSum1   ;
        `remainLoadZero1    : calcSumX   =   16'd0      ;
        default             : calcSumX   =   16'd0      ;
    endcase
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant1             <= 16'd0    ;
    end
    else begin
        if ( ! pwmActive1 ) begin
            posACCwant1             <= 16'd0    ;
        end
        else if ( m3cntFirst2 ) begin
            posACCwant1         <= pwmLENpos;
        end
        else if ( m3cntFirst1 ) begin
            posACCwant1         <=  posACCwant1 + pwmLENpos;
        end
        else if ( pwmCNTreload1 ) begin
            posACCwant1         <=  posACCwant1 + pwmLENpos;
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posRemain1              <= 16'd0 ;
    end
    else begin
        case ( remainLoad1 ) 
            `remainLoadZero1    :   posRemain1              <= 16'd0        ;   
            `remainLoadSum1     :   posRemain1              <= calcSum1     ;   
            `remainLoadSum2     :   posRemain1              <= calcSum2     ;   
            `remainLoadSum3     :   posRemain1              <= calcSum3     ;   
            `remainLoadSum4     :   posRemain1              <= calcSum4     ;   
            `remainLoadSum6     :   posRemain1              <= calcSum6     ;   
            `remainLoadAddPos   :   posRemain1              <= calcSum1     ;   
        endcase
        if ( ! pwmActive1 )         posRemain1              <= 16'd0        ;   
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmLENpos_clked1              <= 16'd0 ;
    end
    else begin
        if ( m3cntFirst1 )          pwmLENpos_clked1              <= pwmLENpos    ;    
        if ( ! pwmActive1 )         pwmLENpos_clked1              <= 16'd0        ;   
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmPOScnt                   <= 16'd0 ;
    end
    else begin
        case ( posLoad1 )
            `posLoadZero    :       pwmPOScnt       <=  16'd0               ;     
            `posLoadDec1    :       pwmPOScnt       <=  pwmPOScnt - 16'd1   ;     
            `posLoadPosSum1 :       pwmPOScnt       <=  calcSum1            ;
            `posLoadPosSum2 :       pwmPOScnt       <=  calcSum2            ;
            `posLoadPosSum3 :       pwmPOScnt       <=  calcSum3            ;
            `posLoadPosSum5 :       pwmPOScnt       <=  calcSum5            ;
        endcase
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posLost1                <= 16'd0 ;
        posLost3                <= 16'd0 ;
    end
    else begin
        if ( m3cntFirst2 ) begin
            posLost1        <= posACCwant2 - posACCreal2 ;
            posLost3        <= posACCwant4 - posACCreal4 ;
        end
    end
end
assign posLost2 = (posLost1[15])?(posLost1^16'hFFFF):posLost1;
assign posLost4 = (posLost3[15])?(posLost3^16'hFFFF):posLost3;

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posStep                 <= 16'hFF ;
    end
    else begin
        if ( m3cntLast2 ) begin
            posStep         <= sgStep ;
        end
    end
end

always @( sgStep ) begin
    case ( sgStep )
        4'd0 , 4'd1 , 4'd2 , 4'd3 , 4'd4 , 4'd5    :    begin   pwmH1L0 = 1'b1 ; end
        default :                                       begin   pwmH1L0 = 1'b0 ; end
    endcase
end
always @( sgStep or m3cntLast2 ) begin
    case ( sgStep )
        4'd5 , 4'd11    :   begin   m3cntLast3 = m3cntLast2 ; end
        default :           begin   m3cntLast3 = 1'b0 ; end
    endcase
end
always @( sgStep or m3cntFirst2 ) begin
    case ( sgStep )
        4'd0 , 4'd6    :    begin   m3cntFirst3 = m3cntFirst2  ; end
        default :           begin   m3cntFirst3 = 1'b0 ; end
    endcase
end

assign posSumExtA   = calcSum1   ;

wire                        pwm01 ;
assign pwm01    = (pwmPOScnt)? 1'b1 : 1'b0 ;
assign pwm      = pwm01 ;


endmodule
