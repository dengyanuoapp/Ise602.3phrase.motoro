module motoro3_step_generator(

    pwmLastStep1                ,
    m3LpwmSplitStep             ,
    m3r_stepSplitMax            ,

    m3stepA                     ,
    m3stepB                     ,
    m3stepC                     ,
    m3cnt                       ,

    m3start                     ,
    m3freqINC                   ,
    m3freqDEC                   ,

    m3cntLast1                  ,
    m3cntLast2                  ,
    m3cntFirst1                 ,
    m3cntFirst2                 ,
    pwmActive1                  ,

    m3r_stepCNT_speedSET        ,

    nRst                        ,
    clk
);


// 0: idle
// 1,2,3,4,5,6:nomal
// 7:force stop
output  wire                pwmLastStep1            ;
output  reg     [1:0]       m3LpwmSplitStep         ;
input   wire    [1:0]       m3r_stepSplitMax        ;

output  reg     [3:0]       m3stepA                 ;
output  reg     [3:0]       m3stepB                 ;
output  reg     [3:0]       m3stepC                 ;
output  reg     [24:0]      m3cnt                   ;
output  wire                m3cntLast1              ;
output  wire                m3cntLast2              ;
output  reg                 m3cntFirst1             ;
output  wire                m3cntFirst2             ;
output  reg                 pwmActive1              ;
input   wire    [24:0]      m3r_stepCNT_speedSET    ;

input   wire                m3start;
input   wire                m3freqINC;
input   wire                m3freqDEC;


input   wire                clk;			// 10MHz
input   wire                nRst;

reg                         m3start_clked1;
wire                        m3start_up1;

reg             [64:0]      roundCNT                ;

assign  m3cntLast1  = ( m3cnt[24:1] == 24'd0 )? 1'd1:1'd0 ;
assign  m3cntLast2  = m3cntLast1 && pwmLastStep1 ;
assign  pwmLastStep1    = ( m3LpwmSplitStep == 2'd0 );

assign  m3cntFirst2 = m3cntFirst1 && (m3LpwmSplitStep == m3r_stepSplitMax );


assign  m3start_up1 = (m3start) && (~m3start_clked1) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked1      <= 0 ;
    end
    else begin
        m3start_clked1      <= m3start      ;
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3cnt               <= m3r_stepCNT_speedSET             ;
        m3cntFirst1         <= 1'b0                             ;
    end
    else begin
        m3cntFirst1         <= 1'b0                             ;
        if ( m3start_up1 == 1 || m3cntLast1 == 1) begin
            m3cnt           <= m3r_stepCNT_speedSET             ;
            m3cntFirst1     <= 1'b1                             ;
        end
        else begin
            if ( m3start == 1 ) begin
                m3cnt       <= m3cnt - 25'd1                    ;
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3LpwmSplitStep                 <= m3r_stepSplitMax ;
    end
    else begin
        //m3LpwmSplitStep                 <= m3LpwmSplitStep  ;
        if ( m3start_up1 == 1 ) begin
            m3LpwmSplitStep             <= m3r_stepSplitMax ;
        end
        else begin
            if ( m3cntLast1 == 1'd1 ) begin
                if ( pwmLastStep1 ) begin
                    m3LpwmSplitStep     <= m3r_stepSplitMax ;
                end
                else begin
                    m3LpwmSplitStep     <= m3LpwmSplitStep - 2'd1 ;
                end
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3stepA                         <= 4'hF             ;
    end
    else begin
        if ( m3start_up1 == 1 ) begin
            m3stepA                     <= 4'd0             ;
        end
        else begin
            if ( m3cntLast1 == 1'd1 && pwmLastStep1 ) begin
                if ( m3stepA== 4'd11 ) begin
                    m3stepA             <= 4'd0             ;
                end
                else begin
                    m3stepA             <= m3stepA+ 4'd1    ;
                end
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        roundCNT            <= 48'd0 ;
    end
    else begin
        if ( m3start ) begin
            if ( m3stepA== 4'd12 && m3cntLast1 == 1'd1 ) begin
                roundCNT    <= roundCNT + 48'd1 ;
            end
        end
        else begin
            roundCNT        <= 48'd0 ;
        end
    end
end

always @( m3stepA ) begin
    case ( m3stepA )
        4'd0    :   begin   m3stepB = 4'd8  ;   m3stepC = 4'd4  ;   pwmActive1 = 1'b1 ; end
        4'd1    :   begin   m3stepB = 4'd9  ;   m3stepC = 4'd5  ;   pwmActive1 = 1'b1 ; end
        4'd2    :   begin   m3stepB = 4'd10 ;   m3stepC = 4'd6  ;   pwmActive1 = 1'b1 ; end
        4'd3    :   begin   m3stepB = 4'd11 ;   m3stepC = 4'd7  ;   pwmActive1 = 1'b1 ; end

        4'd4    :   begin   m3stepB = 4'd0  ;   m3stepC = 4'd8  ;   pwmActive1 = 1'b1 ; end
        4'd5    :   begin   m3stepB = 4'd1  ;   m3stepC = 4'd9  ;   pwmActive1 = 1'b1 ; end
        4'd6    :   begin   m3stepB = 4'd2  ;   m3stepC = 4'd10 ;   pwmActive1 = 1'b1 ; end
        4'd7    :   begin   m3stepB = 4'd3  ;   m3stepC = 4'd11 ;   pwmActive1 = 1'b1 ; end

        4'd8    :   begin   m3stepB = 4'd4  ;   m3stepC = 4'd0  ;   pwmActive1 = 1'b1 ; end
        4'd9    :   begin   m3stepB = 4'd5  ;   m3stepC = 4'd1  ;   pwmActive1 = 1'b1 ; end
        4'd10   :   begin   m3stepB = 4'd6  ;   m3stepC = 4'd2  ;   pwmActive1 = 1'b1 ; end
        4'd11   :   begin   m3stepB = 4'd7  ;   m3stepC = 4'd3  ;   pwmActive1 = 1'b1 ; end

        default :   begin   m3stepB = 4'hE  ;   m3stepC = 4'hE  ;   pwmActive1 = 1'b0 ; end
    endcase

end

endmodule
