module motoro3_step_to_mosdriver(

    xE              ,		
    xForceLow       ,		
    xH1_L0          ,		

    m3step           
);


output  reg                 xE              ;		
output  reg                 xForceLow       ;		
output  reg                 xH1_L0          ;		

input   wire    [3:0]       m3step;	

`define m3mode01
`ifdef m3mode01
always @( m3step ) begin
    case ( m3step )
        4'hF    :   begin   xE = 1'b1 ;     xForceLow = 1'b1 ;      xH1_L0  = 1'b0 ;    end
                                         
        4'd0    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
        4'd1    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
        4'd2    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
        4'd3    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
                                                                   
        4'd4    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
        4'd5    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b1 ;    end
        4'd6    :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b0 ;    end
        4'd7    :   begin   xE = 1'b1 ;     xForceLow = 1'b1 ;      xH1_L0  = 1'b0 ;    end
                                                                   
        4'd8    :   begin   xE = 1'b1 ;     xForceLow = 1'b1 ;      xH1_L0  = 1'b0 ;    end
        4'd9    :   begin   xE = 1'b1 ;     xForceLow = 1'b1 ;      xH1_L0  = 1'b0 ;    end
        4'd10   :   begin   xE = 1'b1 ;     xForceLow = 1'b1 ;      xH1_L0  = 1'b0 ;    end
        4'd11   :   begin   xE = 1'b1 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b0 ;    end
                                                                   
        default :   begin   xE = 1'b0 ;     xForceLow = 1'b0 ;      xH1_L0  = 1'b0 ;    end
    endcase
end
`endif

endmodule
