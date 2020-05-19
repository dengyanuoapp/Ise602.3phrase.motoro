module clkGen_1Mhz_to_100Hz (
    workingI                        ,

    clk100hzO                       ,
    clkI                            ,
    nRstI
);
    input   wire                workingI        ;
    output  wire                clk100hzO       ;
    input   wire                clkI            ;
    input   wire                nRstI           ;

    `ifdef  simulating
        `define      clk100hzMax    14'd9998
    `else
        //`define      clk100hzMax    14'd98
        `define      clk100hzMax    14'd9998
    `endif
    reg          [14:0]         clk100hzCNT ;

    assign clk100hzO    = clk100hzCNT[14] ;
    always @( posedge clkI or negedge nRstI ) begin
        if ( ! nRstI ) begin
            clk100hzCNT         <= `clk100hzMax         ;
        end
        else begin
            if ( ! workingI ) begin
                clk100hzCNT     <= `clk100hzMax         ;
            end
            else begin
                if ( clk100hzO ) begin
                    clk100hzCNT <= `clk100hzMax         ;
                end
                else begin
                    clk100hzCNT <= clk100hzCNT - 15'd1  ;
                end
            end
        end
    end

endmodule
