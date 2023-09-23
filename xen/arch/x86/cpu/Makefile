obj-y += mcheck/
obj-y += microcode/
obj-y += mtrr/

obj-y += amd.o
obj-y += centaur.o
obj-y += common.o
obj-y += hygon.o
obj-y += intel.o
obj-y += intel_cacheinfo.o
obj-y += mwait-idle.o
obj-y += shanghai.o
obj-y += vpmu.o vpmu_amd.o vpmu_intel.o

ifeq ($(CONFIG_COVERAGE),y)
ifeq ($(CONFIG_CC_IS_CLANG),y)
    COV_FLAGS := -fprofile-instr-generate -fcoverage-mapping
else
    COV_FLAGS := -fprofile-arcs -ftest-coverage
endif
_c_flags += $(COV_FLAGS)
endif
