module motoro3_calc_sine_len_against_to_step(
    m3r_stepSplitMax            ,	
    m3LpwmSplitStep             ,	
    lcStep                      ,
    slLen                
);

input   wire    [1:0]       m3r_stepSplitMax        ;	
input   wire    [1:0]       m3LpwmSplitStep         ;	
input   wire    [3:0]       lcStep                  ;	
output  reg     [15:0]      slLen                   ;	
reg             [15:0]      pi6                     ;	
reg             [15:0]      pi12                    ;	
reg             [15:0]      pi24                    ;	

`define XX11    begin   pi6 = 16'd17560 ; pi12 = 16'd8628   ; pi24 = 16'd4295   ;   end
`define XX12    begin   pi6 = 16'd17560 ; pi12 = 16'd25296  ; pi24 = 16'd12813  ;   end
`define XX13    begin   pi6 = 16'd17560 ; pi12 = 16'd8628   ; pi24 = 16'd21111  ;   end
`define XX14    begin   pi6 = 16'd17560 ; pi12 = 16'd25296  ; pi24 = 16'd29048  ;   end
                                                                   
`define XX21    begin   pi6 = 16'd47976 ; pi12 = 16'd40240  ; pi24 = 16'd36488  ;   end
`define XX22    begin   pi6 = 16'd47976 ; pi12 = 16'd52442  ; pi24 = 16'd43304  ;   end
`define XX23    begin   pi6 = 16'd47976 ; pi12 = 16'd40240  ; pi24 = 16'd49378  ;   end
`define XX24    begin   pi6 = 16'd47976 ; pi12 = 16'd52442  ; pi24 = 16'd54608  ;   end
                                                                  
`define XX31    begin   pi6 = 16'd65535 ; pi12 = 16'd61070  ; pi24 = 16'd58904  ;   end
`define XX32    begin   pi6 = 16'd65535 ; pi12 = 16'd65535  ; pi24 = 16'd62191  ;   end
`define XX33    begin   pi6 = 16'd65535 ; pi12 = 16'd61070  ; pi24 = 16'd64415  ;   end
`define XX34    begin   pi6 = 16'd65535 ; pi12 = 16'd65535  ; pi24 = 16'd65535  ;   end

always @( lcStep or m3LpwmSplitStep ) begin
    case ( { lcStep, m3LpwmSplitStep } )
                                         
        {4'd0   , 2'd3  } , {4'd5   , 2'd0  } , {4'd6   , 2'd3  } , {4'd11  , 2'd0  }   :   `XX11
        {4'd0   , 2'd2  } , {4'd5   , 2'd1  } , {4'd6   , 2'd2  } , {4'd11  , 2'd1  }   :   `XX12
        {4'd0   , 2'd1  } , {4'd5   , 2'd2  } , {4'd6   , 2'd1  } , {4'd11  , 2'd2  }   :   `XX13
        {4'd0   , 2'd0  } , {4'd5   , 2'd3  } , {4'd6   , 2'd0  } , {4'd11  , 2'd3  }   :   `XX14
                                                                                                                                   
        {4'd1   , 2'd3  } , {4'd4   , 2'd0  } , {4'd7   , 2'd3  } , {4'd10  , 2'd0  }   :   `XX21
        {4'd1   , 2'd2  } , {4'd4   , 2'd1  } , {4'd7   , 2'd2  } , {4'd10  , 2'd1  }   :   `XX22
        {4'd1   , 2'd1  } , {4'd4   , 2'd2  } , {4'd7   , 2'd1  } , {4'd10  , 2'd2  }   :   `XX23
        {4'd1   , 2'd0  } , {4'd4   , 2'd3  } , {4'd7   , 2'd0  } , {4'd10  , 2'd3  }   :   `XX24
                                                                                                                                  
        {4'd2   , 2'd3  } , {4'd3   , 2'd0  } , {4'd8   , 2'd3  } , {4'd9   , 2'd0  }   :   `XX31
        {4'd2   , 2'd2  } , {4'd3   , 2'd1  } , {4'd8   , 2'd2  } , {4'd9   , 2'd1  }   :   `XX32
        {4'd2   , 2'd1  } , {4'd3   , 2'd2  } , {4'd8   , 2'd1  } , {4'd9   , 2'd2  }   :   `XX33
        {4'd2   , 2'd0  } , {4'd3   , 2'd3  } , {4'd8   , 2'd0  } , {4'd9   , 2'd3  }   :   `XX34
                                                                   
        default :   begin   pi6 = 16'd0     ; pi12 = 16'd0      ; pi24 = 16'd0      ;   end
    endcase
end

//assign slLen    = pi24 ;
always @( m3r_stepSplitMax or pi6 or pi12 or pi24 ) begin
    case ( m3r_stepSplitMax )
        2'd0    :   slLen   = pi6   ;
        2'd1    :   slLen   = pi12  ;
        default :   slLen   = pi24  ;
    endcase
end

endmodule
