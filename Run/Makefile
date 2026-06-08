CMD = vcs -full64 -sverilog -R -debug_access+all -ntb_opts uvm-1.2 -f files.f -l apb_debug.log
COV = -cm line+tgl+cond+assert+fsm+branch
COV_DISPLAY = verdi -cov -covdir simv.vdb
WAVEFORM_DVE = ./simv -gui=dve
WAVEFORM_VERDI = ./simv -gui=verdi
CLEAR = rm -rf csrc DVEfiles flex* simv* ucli.key novas* vc_hdrs* inter.vpd tr_db*


DESIGN_PATH= /home/dvft1104/final_apb_uvm/design/apb_slave_design.sv
TOP_PATH= /home/dvft1104/final_apb_uvm/verification/tb/apb_top.sv

run :
	${CMD}
wave_dve :
	${WAVEFORM_DVE}
wave_verdi :
	${WAVEFORM_VERDI}
clear :
	${CLEAR}
cov :
	${COV}
cov_display :
	${COV_DISPLAY}
