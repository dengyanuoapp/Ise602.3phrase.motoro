//
//`ifndef m3speedRoundPerSecondL8 
//    `define busWIDTH                        32 
//    `define m3pos1_neg0                     8'd1
//    `define m3perCent                       8'd10
//    `define m3speedRoundPerSecondH8         8'd0
//    `ifdef  synthesising 
//        `define m3speedRoundPerSecondL8     8'd1
//    `endif
//    `ifdef  simulating 
//        `define m3speedRoundPerSecondL8     8'd100
//    `endif
//`endif

    /*
    *
    * 1Mhz clock, 1us clock period; 
    * max sine wave freqence is 25kHz == 40us = 40 clk
    * min sine wave freqence is 0.25Hz == 4,000,000 us = 4,000,000 clk == 22'd4000000
    *
    * about the increase speed calc :
    * LLL={3/2, 5/4, 9/8, 17/16, 33/32} ; Fmin=40 ; Fmax=4000000 ;
    * Log[ LLL, (Fmax/Fmin) ] == {28.3944, 51.5943, 97.7469, 189.905, 374.141}
    * so, if the inc rate range from 1/2 to 1/32 , the required time from 28 to 374
    */

`ifdef    simulating
    //    +define+simulating , to reduce the VCS debug time.
    //`define   eachSlicePeriodMax      22'd400
    `define   eachSlicePeriodMax      22'd300
    //`define   eachSlicePeriodMax      22'd200
    //`define   eachSlicePeriodMax      22'd100
`else
    `define   eachSlicePeriodMax      22'd4000000
`endif

    /*
    * Total Stotal    == (1.0 * powerLevel ) * len
    * up :   SAup     == ((0.5773502692 + 1) / 2 * powerLevel) * len == 0.7886751346 * Stotal
    *       Sup(xx_)  =  (0.5773502692 + ((( nowStepEndEdge / len ) * ( 1 - 0.5773502692)) / 2)) * Stotal
    * down : SAdown   == ((1 + 0.8660254038) / 2 * powerLevel) * len == 0.9330127019 * Stotal
    *     Sdown(xx_)  =  (1 - ( nowStepEndEdge / len ) * ( 1 - 0.8660254038) ) / 2 * Stotal
    */

