
LM_LICENSE_FILE?=LM_LICENSE_FILE=56789@127.0.0.1



#/e/eda2151/QUANTUS20/quantus20/bin/quantusui
QUANTUS_HOME=/e/eda2151/QUANTUS20/quantus20
OA_UNSUPPORTED_PLAT:=OA_UNSUPPORTED_PLAT=linux_rhel60

INNOVUS_HOME:=/e/eda2141/nowDIR
INNOVUS_HOMEbin1:=$(INNOVUS_HOME)/bin
INNOVUS_HOMEbin2:=$(INNOVUS_HOME)/tools.lnx86/bin

VERDI_HOME:=/e/eda2312/verdi_2018.09

VCS_HOME:=/e/eda2321/VCS_2018.09
#VCS_HOME=/e/eda2321/VCS_2016.06
VCS_ARCH_OVERRIDE=


#other_para01:= -LDFLAGS -Wl,--no-as-needed 
#other_para01:= -cc gcc44 -cpp g++44
# -CFLAGS -no-pie

other_para01:=
ifneq (,$(wildcard /usr/bin/gcc-4.8))
#other_para01+= -cc gcc-4.8 -cpp g++-4.8     
endif

USE64=1
ifeq (,$(USE64))
VCS_64=
#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux64
PATHvcs:=PATH=$(VCS_HOME)/linux/bin:$(PATH):$(VCS_HOME)/bin
else
VCS_64=-full64
#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux
PATHvcs:=PATH=$(VCS_HOME)/linux64/bin:$(PATH):$(VCS_HOME)/bin
endif





export vcsCMDline:=$(VCS_ARCH_OVERRIDE)         \
	$(LM_LICENSE_FILE)                          \
	VCS_HOME=$(VCS_HOME) 			            \
	\
	$(PATHvcs)                                  \
	\
	vcs  		                                \
	\
	$(VCS_64)                                   \
	$(other_para01)                             \
	\
	ttt/Counter_tb.v                            \
	ttt/Counter.v 

export verdivcsCMDline:=                        \
	VERDI_HOME=$(VERDI_HOME)                    \
	$(vcsCMDline) \
	+define+VERDI_HOME=$(VERDI_HOME) -debug_access+all

define show_help_text

c            -->>>    clean 

bvs          -->>>    $(bvs)      -->> by vcs only
rvs          -->>>    $(rvs)      -->> by vcs only
aaa          -->>>    $(aaa)      -->> by vcs only

bvv          -->>>    $(bvv)      -->> by vcs with verdi
rvv          -->>>    $(rvv)      -->> by vcs with verdi
aav          -->>>    $(aav)      -->> by vcs with verdi

inn          -->>>

dcdc         -->>>    $(dcdc)
dcdc2        -->>>    $(dcdc2)  2018.06 , the last version without CTR SIGN=...
dcdc3        -->>>    $(dcdc3)

qut          -->>>    QUANTUS_HOME=/e/eda2151/QUANTUS20/quantus20 , OA_UNSUPPORTED_PLAT:=OA_UNSUPPORTED_PLAT=linux_rhel60

nc           -->>>    ncverilog

endef
export show_help_text

vim:=vim -i /tmp/_viminfo.$(USER)
all:
	@echo "$${show_help_text}"

aaa:=c bvs rvs
aaa:$(aaa)
aav:=c bvv rvv
aav:$(aav)

inn:
	OA_UNSUPPORTED_PLAT=linux_rhel60           \
	OA_HOME=$(INNOVUS_HOME)/share/oa/          \
	PATH=$(INNOVUS_HOMEbin1):$${PATH}          \
	$(INNOVUS_HOMEbin1)/innovus

up gs gc ga:
	cd .. && make $@

######################## test VCS :begin
m: Makefile
	@echo
	$(vim) $<
	@echo

c clean:
	rm -fr                                                      \
		allegro.jrl                                             \
		allegro.jrl,1                                           \
		license_use.log                                         \
		qrc.log                                                 \
		xcelium.d/                                              \
		xmverilog.history                                       \
		xmverilog.log                                           \
		xmvlog.log                                              \
		xmsim.log                                              \
		innovus.log  innovus.log[0-9]*                          \
		innovus.logv innovus.logv[0-9]*                         \
		novas_dump.log                                          \
		verdi.fsdb                                              \
		Counter.vcd                                             \
		command.log                                             \
		filenames.log                                           \
		simv                                                    \
		simv.daidir/                                            \
		csrc/                                                   \
		stack.info.*/                                           \
		ucli.key                               

bvs:=build_verilog_sim
bvs $(bvs):
	$(vcsCMDline) || (echo "$${vcsCMDline} : run with error  818381881 " ; exit 33 )

bvv:=build_verilog_sim_verdi
bvv $(bvv):
	$(verdivcsCMDline) || (echo "$${verdivcsCMDline} : run with error 818381882 " ; exit 33 )

rvs:=run_verilog_sim
rvs $(rvs):
	./simv 

rvv:=run_verilog_sim_verdi
rvv $(rvv):
	VERDI_HOME=$(VERDI_HOME)                    \
	./simv 
######################## test VCS :end


######################## dcdc dcdc2 dcdc3 :begin
dcdc  :=/e/eda2331/DC_201603
dcdc2 :=/e/eda2331/syn_vO-2018.06-SP1/
dcdc3 :=/e/eda2331/DC_201903/syn/P-2019.03-SP4/

DC_HOME?=$(dcdc)
dcdc2:dcdc
dcdc3:dcdc
dcdc2: DC_HOME=$(dcdc2)
dcdc3: DC_HOME=$(dcdc3)

PATHdc=PATH=$(DC_HOME)/bin:$(DC_HOME)/linux64/bin:$(PATH)
dcdc_CMD = \
	$(LM_LICENSE_FILE)                          \
	$(PATHdc) \
	$(DC_HOME)/bin/dc_shell-t
#	$(DC_HOME)/bin/design_vision-xg
#	$(DC_HOME)/bin/dc_shell
#	$(DC_HOME)/bin/dc_shell-xg-t
#	$(DC_HOME)/bin/design_vision-xg
#	$(DC_HOME)/bin/design_vision

dcdc :
	$(dcdc_CMD)
######################## dcdc dcdc2 dcdc3 : end

######################## qut : begin
qut_CMD:=\
	$(LM_LICENSE_FILE)                          \
	$(OA_UNSUPPORTED_PLAT)                      \
	$(QUANTUS_HOME)/bin/quantusui
qut:          
	$(qut_CMD)
######################## qut : end

VRST_HOME=/e/eda2161/xce19.09
######################## nc : begin
nc_CMD_path:=\
	$(LM_LICENSE_FILE)                          			\
	VRST_HOME=$(VRST_HOME)   								\
	PATH=$(VRST_HOME)/bin:$(VRST_HOME)/tools/bin:$${PATH}   

nc_CMD_build:=$(nc_CMD_path) \
	xmvlog        \
	ttt/Counter_tb.v   \
	ttt/Counter.v

nc_CMD_sim:=$(nc_CMD_path)\
	xmsim        \
	Counter_tb

nc:
	mkdir -p /tmp/simvision/
	[ -L ~/.simvision ] || ln -s /tmp/simvision/ ~/.simvision
	$(nc_CMD_build)
	$(nc_CMD_sim)
######################## nc : end

