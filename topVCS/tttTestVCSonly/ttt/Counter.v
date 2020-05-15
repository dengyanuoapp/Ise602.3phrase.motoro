/*****************************************************************************************************
* Description:                 Counter for Demo
                          - When rst==1, then the counter returns to 0
                          - The counter counts from 0 to 19 at every rising edge of clk
                          - After it reaches 19, the next rising edge the counter resets to 0
*
* Author:                      Dengxue Yan
*
* Email:                       Dengxue.Yan@wustl.edu
*
* Rev History:
*       <Author>        <Date>        <Hardware>     <Version>        <Description>
*     Dengxue Yan   2016-09-09 23:00       --           1.00             Create
*****************************************************************************************************/
`timescale 1ns / 1ps

module Counter(
    rst,
    clk,
    c
    );

    input rst;
    input  clk;
    output [4:0] c;
    reg    [4:0] c = 5'h00;
    
    always @ (posedge clk)
    begin
        if (rst)
        begin
            c <= 5'h00;
        end
        else
        begin
            if (c < 5'h13)
            begin
                c <= c + 1;
            end
            else
            begin
                c <= 5'h00;
            end
        end
    end

endmodule