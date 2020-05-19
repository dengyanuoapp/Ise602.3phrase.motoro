topModule:=motor602_tb
DEV01:=xc3s500e-pq208-4

CFGmakeRun:=Makefile.run.synopsysVERDI.mk

VERDItb:=motor602_tb
VERDIrtlTop:=$(VERDItb)/rtlTop
VERDIm3top:=$(VERDIrtlTop)/m3top
VERDIm3r:=$(VERDIm3top)/r
VERDIcalc:=$(VERDIm3r)/calc
VERDIcg100:=$(VERDIcalc)/cg100
VERDIspCalc:=$(VERDIcalc)/spCalc

waveAddLine:= wvAddAllSignals -win $$_nWave2

VERICOMdefine:= +define+simulating=1

define waveAddLine

wvRenameGroup 	-win $$_nWave2 	G1		TbMrMosCmp
wvAddSignal 	-win $$_nWave2 	-group 	{TbMrMosCmp {/$(VERDIm3r)/aHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{TbMrMosCmp {/$(VERDIm3r)/aLpO}}
wvAddSignal 	-win $$_nWave2  -group 	{TbMrMosCmp {/$(VERDItb)/aHPw}}
wvAddSignal 	-win $$_nWave2  -group 	{TbMrMosCmp {/$(VERDItb)/aLNw}}
wvAddSignal 	-win $$_nWave2  -group 	{TbMrMosCmp {/$(VERDItb)/bHPw}}
wvAddSignal 	-win $$_nWave2  -group 	{TbMrMosCmp {/$(VERDItb)/bLNw}}
wvAddSignal 	-win $$_nWave2 	-group 	{TbMrMosCmp {/$(VERDIm3r)/bHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{TbMrMosCmp {/$(VERDIm3r)/bLpO}}

wvRenameGroup 	-win $$_nWave2 	G2 		 TbError9
wvAddSignal 	-win $$_nWave2 	-group 	{TbError9 {/$(VERDIm3r)/aHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{TbError9 {/$(VERDIm3r)/aLpO}}
wvAddSignal     -win $$_nWave2  -group 	{TbError9 {/$(VERDItb)/error91}}
wvAddSignal     -win $$_nWave2  -group 	{TbError9 {/$(VERDItb)/error92}}

wvRenameGroup   -win $$_nWave2  G3 		TbTestpoint1
wvAddSignal     -win $$_nWave2  -group {TbTestpoint1 {/$(VERDItb)/clkR}}
wvAddSignal     -win $$_nWave2  -group {TbTestpoint1 {/$(VERDItb)/nRstR}}
wvAddSignal     -win $$_nWave2  -group {TbTestpoint1 {/$(VERDItb)/tp01w}}
wvAddSignal     -win $$_nWave2  -group {TbTestpoint1 {/$(VERDItb)/tp02w}}
wvAddSignal     -win $$_nWave2  -group {TbTestpoint1 {/$(VERDItb)/led4W}}

wvRenameGroup   -win $$_nWave2  G4 		TbAbcHLw1
wvAddSignal     -win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/error91}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/aHPw}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/aLNw}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/bHPw}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/bLNw}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/cHPw}}
wvAddSignal 	-win $$_nWave2  -group {TbAbcHLw1 {/$(VERDItb)/cLNw}}

wvRenameGroup 	-win $$_nWave2 	G5 		 RtlClk01
wvAddSignal 	-win $$_nWave2 	-group 	{RtlClk01 {/$(VERDIrtlTop)/nRstI}}
wvAddSignal 	-win $$_nWave2 	-group 	{RtlClk01 {/$(VERDIrtlTop)/clk50mhzI}}
wvAddSignal 	-win $$_nWave2 	-group 	{RtlClk01 {/$(VERDIrtlTop)/clk1MhzW}}

wvRenameGroup 	-win $$_nWave2 	G6 		 MrPortAll
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/aHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/aLpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/bHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/bLpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/cHpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/cLpO}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3startI}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3forceStopI}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3invRotateI}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3speedDECi}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3speedINCi}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3powerINCi}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/m3powerDECi}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/clkI}}
wvAddSignal 	-win $$_nWave2 	-group 	{MrPortAll {/$(VERDIm3r)/nRstI}}

wvRenameGroup 	-win $$_nWave2 	G7 		 roundLen
wvAddSignal 	-win $$_nWave2 	-group 	{roundLen {/$(VERDIcalc)/roundLen}}
wvAddSignal 	-win $$_nWave2 	-group 	{roundLen {/$(VERDIcalc)/roundLast}}
wvAddSignal 	-win $$_nWave2 	-group 	{roundLen {/$(VERDIcalc)/roundCnt1round}}
wvAddSignal 	-win $$_nWave2 	-group 	{roundLen {/$(VERDIcg100)/clk100hzCNT}}
wvAddSignal 	-win $$_nWave2 	-group 	{roundLen {/$(VERDIcg100)/clk100hzO}}

wvRenameGroup 	-win $$_nWave2 	G8 		 Calc01
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/clkI}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/step}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/remain}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/nextStep}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/nextRound}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/sm}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/sm_next}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/Sum_full}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/Sum_up}}
wvAddSignal 	-win $$_nWave2 	-group 	{Calc01 {/$(VERDIcalc)/Sum_down}}

wvRenameGroup 	-win $$_nWave2 	G9 		 spCalc
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/nextRound_1I}}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/workingI    }}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/m3invRotateI}}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/m3forceStopI}}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/m3speedDECi }}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/m3speedINCi }}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/clk100hzO   }}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/clkI        }}
wvAddSignal 	-win $$_nWave2 	-group 	{spCalc {/$(VERDIspCalc)/nRstI       }}

wvSelectAll
wvSetRadix 		-win $$_nWave2 	-format UDec
wvDeselectAll


wvCollapseGroup	TbTestpoint1
wvCollapseGroup	TbAbcHLw1
wvCollapseGroup	RtlClk01
wvCollapseGroup	MrPortAll
wvCollapseGroup	TbMrMosCmp
wvCollapseGroup	TbError9
wvCollapseGroup	roundLen
#wvCollapseGroup	Calc01
#wvCollapseGroup	spCalc


endef

### wvResizeWindow -win $$_nWave2 20 28 1800 980
### wvSetRadix 		-format UDec {(Calc01 3)}
