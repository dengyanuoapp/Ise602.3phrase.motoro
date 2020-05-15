module motoro3_mos_driver(


    mosHp           ,
    mosLp           ,

    pwm             ,
    mosEnable       ,		
    h1_L0           ,		
    forceLow        ,

    nRst,
    clk

);

output  reg                 mosHp           ;		
output  reg                 mosLp           ;		

input   wire                pwm             ;		
input   wire                mosEnable       ;		
input   wire                h1_L0           ;		
input   wire                forceLow        ;		

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        mosHp                   <= 1'b0 ;
        mosLp                   <= 1'b0 ;
    end
    else begin
        if ( mosEnable == 1'b1 ) begin
            if ( forceLow == 1'b1 ) begin
                mosHp           <= 1'b0 ;
                mosLp           <= 1'b1 ;
            end
            else begin
                if ( h1_L0 == 1'b1 ) begin
                    mosLp       <= 1'b0 ;
               
                    mosHp       <= 1'b1 ;
                    if ( mosLp == 1'b1 )    begin mosHp <= 1'b0 ; end  // prevent mosP & mosN pass-through
                    if ( pwm == 1'b0 )      begin mosHp <= 1'b0 ; end 
                end
                else begin
                    mosHp       <= 1'b0 ;
               
                    mosLp       <= 1'b1 ;
                    if ( mosHp == 1'b1 ) begin mosLp <= 1'b0 ; end   // prevent mosP & mosN pass-through
                    if ( pwm == 1'b0 )   begin mosLp <= 1'b0 ; end 
                end
            end
        end
        else begin
                mosHp           <= 1'b0 ;
                mosLp           <= 1'b0 ;
        end
    end
end

endmodule
