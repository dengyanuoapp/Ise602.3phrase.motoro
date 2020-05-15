
`ifndef m3speedRoundPerSecondL8 
    `define busWIDTH                        32 
    `define m3pos1_neg0                     8'd1
    `define m3perCent                       8'd10
    `define m3speedRoundPerSecondH8         8'd0
    `ifdef  synthesising 
        `define m3speedRoundPerSecondL8     8'd1
    `endif
    `ifdef  simulating 
        `define m3speedRoundPerSecondL8     8'd100
    `endif
`endif


