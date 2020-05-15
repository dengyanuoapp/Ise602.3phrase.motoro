module clkGen_50Mhz_to_10Mhz(
    clk10mhz, // generated : 10Mhz
    nRst,
    clk50mhz

);

output  reg                 clk10mhz ;	
input   wire                nRst;		
input   wire                clk50mhz;

reg     [3:0]               cnt ;	

always @ (negedge clk50mhz or negedge nRst) begin
    if(!nRst) begin
        cnt                 <= 4'd4 ;
        clk10mhz            <= 1'b0 ;
    end
    else begin
        if ( cnt == 4'd0 ) begin
            cnt             <= 4'd4 ;
            clk10mhz        <= 1'b0 ;
        end 
        else begin
            if ( cnt == 4'd2 ) begin
                clk10mhz    <= 1'b1 ;
            end 
            cnt             <= cnt - 4'd1 ;
        end
    end
end

endmodule
