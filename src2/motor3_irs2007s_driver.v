module motor3_irs2007s_driver(


    HinO            ,
    nLinO           ,

    down1_up2i       
);

output  reg                 HinO            ;		
output  reg                 nLinO           ;		

input   wire[1:0]           down1_up2i      ;		

always @ ( down1_up2i ) begin
    HinO            = 1'b0 ;
    nLinO           = 1'b1 ;
    if ( down1_up2i == 2'd1 ) begin
        nLinO       = 1'b0 ;
    end 
    if ( down1_up2i == 2'd2 ) begin
        HinO        = 1'b1 ;
    end 
end

endmodule
