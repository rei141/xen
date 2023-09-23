obj-y += svm/
obj-y += vmx/
obj-y += viridian/

obj-y += asid.o
obj-y += dm.o
obj-bin-y += dom0_build.init.o
obj-y += domain.o
obj-y += emulate.o
obj-$(CONFIG_GRANT_TABLE) += grant_table.o
obj-y += hpet.o
obj-y += hvm.o
obj-y += hypercall.o
obj-y += intercept.o
obj-y += io.o
obj-y += ioreq.o
obj-y += irq.o
obj-y += monitor.o
obj-y += mtrr.o
obj-y += nestedhvm.o
obj-y += pmtimer.o
obj-y += quirks.o
obj-y += rtc.o
obj-y += save.o
obj-y += stdvga.o
obj-y += vioapic.o
obj-y += vlapic.o
obj-y += vm_event.o
obj-y += vmsi.o
obj-y += vpic.o
obj-y += vpt.o
$(info non-init-objects are $(non-init-objects))

non-init-objects = $(filter-out %.init.o, $(obj-y) $(obj-bin-y) $(extra-y))
$(info non-init-objects are $(non-init-objects))

ifeq ($(CONFIG_COVERAGE),y)
ifeq ($(CONFIG_CC_IS_CLANG),y)
    COV_FLAGS := -fprofile-instr-generate -fcoverage-mapping
else
    COV_FLAGS := -fprofile-arcs -ftest-coverage
endif


obj-y: _c_flags += $(COV_FLAGS)

# CFLAGS-y += $(COV_FLAGS)
$(info _c_flags are $(_c_flags))
$(info CFLAGS are $(CFLAGS-y))
$(info COV_FLAGS are $(COV_FLAGS))
$(info non-init-objects are $(non-init-objects))
endif

$(non-init-objects):
    $(info Building $@ with CFLAGS-y = $(CFLAGS-y))
