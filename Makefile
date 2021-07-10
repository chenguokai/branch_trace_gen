# This file automatically generate branch trace info from checkpoints

workload_path ?= /home51/cgk/BP/NEMU_bptrace/workload
workload_sdcard_img = ${workload_path}/rv-debian-spec-6G-fix-sphinx.img

stats_base_dir ?= outputs
config_dir ?= take_cpt

NEMU_HOME ?= /home51/cgk/BP/NEMU_bptrace

max_insts ?= 100000000

testcases = $(shell find ${workload_path} -mindepth 1  -maxdepth 1 -type d)

testcase_names = $(notdir ${testcases})

testcase_path = $(addsuffix /0/, $(testcases))

testcase_file = $(shell find $(testcase_path) -type f)

virtual_targets = $(patsubst %.gz,%.log, ${testcase_file})

all: $(virtual_targets)

%.log: %.gz
	${NEMU_HOME}/build/riscv64-nemu-interpreter --batch --sdcard-img ${workload_sdcard_img} -D ${stats_base_dir} -w $(notdir $(abspath $(addsuffix /.., $(dir $<)))) -C $(config_dir) -c $< --max-insts $(max_insts)

debug: ${testcases}
	@echo ${testcase_file}
	@echo ${virtual_targets}


