topModule:=motor602_rtl_top
topClk:=clk50mhzI

#topModule:=led4
#topClk:=clk

DEV01:=xc3s500e-pq208-4

CFGmakeRun:=Makefile.run.synopsysDC.mk

#ttUCF:=ip2uart_top.ucf

excludeSIMfileLists:= srcSYN/src9/motor602_top.v

#DCdefine:= +define+simulating=1
#DCdefine:= -define simulating=1
DCdefine:= -define synthesising=1

