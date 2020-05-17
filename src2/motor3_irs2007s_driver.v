module motor3_irs2007s_driver(


		HinO            ,
		nLinO           ,

		down1_up2i      ,
		nRstI           ,
		clkI             
		);

output  reg                 HinO            ;		
output  reg                 nLinO           ;		

input   wire                clkI            ;		
input   wire                nRstI           ;		

input   wire[1:0]           down1_up2i      ;		

always @ ( posedge clkI or negedge nRstI  ) begin
if ( ! nRstI ) begin
HinO            <= 1'b0 ;
nLinO           <= 1'b1 ;
end
else begin
HinO            <= 1'b0 ;
nLinO           <= 1'b1 ;
if ( down1_up2i == 2'd1 ) begin
nLinO       <= 1'b0 ;
end 
else begin
if ( down1_up2i == 2'd2 ) begin
HinO    <= 1'b1 ;
end 
end 
end 
end

endmodule
