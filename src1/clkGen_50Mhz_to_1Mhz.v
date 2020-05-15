module clkGen_50Mhz_to_1Mhz(
    clk1mhzO, // generated : 1Mhz
    nRst,
    clk50mhzI

);

output  reg                 clk1mhzO ;	
input   wire                nRst;		
input   wire                clk50mhzI;

reg     [3:0]               cnt ;	

always @ (negedge clk50mhzI or negedge nRst) begin
    if(!nRst) begin
        cnt                 <= 4'd4 ;
        clk1mhzO            <= 1'b0 ;
    end
    else begin
        if ( cnt == 4'd0 ) begin
            cnt             <= 4'd4 ;
            clk1mhzO        <= 1'b0 ;
        end 
        else begin
            if ( cnt == 4'd2 ) begin
                clk1mhzO    <= 1'b1 ;
            end 
            cnt             <= cnt - 4'd1 ;
        end
    end
end

endmodule
