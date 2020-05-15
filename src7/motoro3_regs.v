module motoro3_regs(
    m3r_stepCNT_speedSET    ,	
    m3r_power_percent       ,	
    m3r_pwmLenWant          ,	
    m3r_pwmMinMask          ,	
    m3r_stepSplitMax        ,	

    nRst,
    clk
);


output  wire    [24:0]      m3r_stepCNT_speedSET    ;	 // to control the speed
output  wire    [7:0]       m3r_power_percent       ;	// to control the percent of power , max 255 % , min 1 %.
output  wire    [11:0]      m3r_pwmLenWant          ;	
output  wire    [11:0]      m3r_pwmMinMask          ;	
output  wire    [1:0]       m3r_stepSplitMax        ;	

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		


//( per pwmSTEP 511clk, 51us )
`ifndef m3cnt_reload1_now 
`ifdef synthesising
//`define m3cnt_reload1_now    25'd166_667          // 0.8s
//`define m3cnt_reload1_now    25'd666_666          // 3.2s
`define m3cnt_reload1_now    25'd1_666_667        // 8s
`endif
`ifdef simulating
`define m3cnt_reload1_now    25'd16_667   // 1_666.7us * 12 == 20_000 us == 20ms == 50Hz , 16667/511==32pwmSTEP
//`define m3cnt_reload1_now    25'd166_667
`endif
`endif

`ifndef m3cnt_reload1_now 
always begin
$error( "you should define synthesising/simulatingVERIDI , or m3cnt_reload1_now, then run again" );
$finish;
end
`endif

//assign m3r_stepCNT_speedSET = { 1'd0, m3freq , 6'd0 };
//assign m3r_stepCNT_speedSET = 25'd1_667      ; // 6*1_667        == 1,000.2 us       == 1000Hz
//assign m3r_stepCNT_speedSET = 25'd16_667     ; // 6*16_667       == 10,000.2 us      == 100Hz
//assign m3r_stepCNT_speedSET = 25'd166_667    ; // 6*166_667      == 100,000.2 us     == 10Hz
//assign m3r_stepCNT_speedSET = 25'd333_333    ; // 6*333_333      == 200,000.4 us     == 5Hz
//assign m3r_stepCNT_speedSET = 25'd666_666    ; // 6*666_666      == 400,000.8 us     == 2.5Hz
//assign m3r_stepCNT_speedSET = 25'd1_666_667  ; // 6*1_666_667    == 1,000,000.2 us   == 1Hz
assign m3r_stepCNT_speedSET = `m3cnt_reload1_now ;

assign m3r_power_percent    = 8'h10 ;





// clk freq : 10Mhz , 100ns , 0.1us
// max period   : 0xfff : 4095 * 0.1us == 410us --> 2.44kHz
// min MOS open : 0x10  : 16   * 0.1us == 1.6us  (min set to 16: mosDriver2003/2007 raise/failing time 150ns )
// min MOS open : 0x20  : 32   * 0.1us == 3.2us  (min set to 32: mosDriver2003/2007 raise/failing time 150ns )

//`define pwmTest      12'h10 //   16(0x10) of 511(0x1ff) * 0.1us == 1.6us // test , failed , MOS can not work. none wave in the MOSFET
//--------- `define pwmTest      12'h20 //   32(0x20) of 511(0x1ff) * 0.1us == 3.1us // so , this is the min can be used.
//`define pwmTest      12'h40 //   64(0x40) of 511(0x1ff) * 0.1us == 6.4us
//`define pwmTest      12'h80 // 
//`define pwmTest      12'h100 // 
//`define pwmTest      12'h110 //  half of 511(0x1ff) * 0.1us == 26us
//`define pwmTest      5'h10 // 1.56us // lost... the FPGA output lost... so, the MOSFET must be lost.

assign  m3r_pwmLenWant      = 12'd512   ;
assign  m3r_pwmMinMask      = 12'd32    ;

//assign  m3r_stepSplitMax    = 2'd0      ;
//assign  m3r_stepSplitMax    = 2'd1      ;
assign  m3r_stepSplitMax    = 2'd3      ;


endmodule
