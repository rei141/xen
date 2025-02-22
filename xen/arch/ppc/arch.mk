########################################
# Power-specific definitions

ppc-march-$(CONFIG_POWER_ISA_3_00) := power9

CFLAGS += -m64 -mlittle-endian -mcpu=$(ppc-march-y)
CFLAGS += -mstrict-align -mcmodel=medium -mabi=elfv2 -fPIC -mno-altivec -mno-vsx -msoft-float

LDFLAGS += -m elf64lppc

# TODO: Drop override when more of the build is working
override ALL_OBJS-y = arch/$(SRCARCH)/built_in.o common/libfdt/built_in.o lib/built_in.o
