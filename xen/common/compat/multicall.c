/******************************************************************************
 * multicall.c
 */

EMIT_FILE;

#include <xen/types.h>
#include <xen/hypercall.h>
#include <xen/trace.h>

#define COMPAT
typedef int ret_t;
#undef do_multicall_call

static inline void xlat_multicall_entry(struct mc_state *mcs)
{
    unsigned int i;
    typeof(mcs->compat_call.args[0]) args[ARRAY_SIZE(mcs->call.args)];

    for ( i = 0; i < ARRAY_SIZE(args); i++ )
        args[i] = mcs->call.args[i];

    memcpy(mcs->compat_call.args, args, sizeof(args));
}

#define multicall_entry      compat_multicall_entry
#define multicall_entry_t    multicall_entry_compat_t
#define do_multicall_call    compat_multicall_call
#define call                 compat_call
#define do_multicall(l, n)   compat_multicall(_##l, n)
#define _XEN_GUEST_HANDLE(t) XEN_GUEST_HANDLE(t)
#define _XEN_GUEST_HANDLE_PARAM(t) XEN_GUEST_HANDLE(t)

static void __trace_multicall_call(multicall_entry_t *call)
{
    xen_ulong_t args[ARRAY_SIZE(call->args)];
    unsigned int i;

    for ( i = 0; i < ARRAY_SIZE(args); i++ )
        args[i] = call->args[i];

    __trace_hypercall(TRC_PV_HYPERCALL_SUBCALL, call->op, args);
}

#include "../multicall.c"

/*
 * Local variables:
 * mode: C
 * c-file-style: "BSD"
 * c-basic-offset: 4
 * tab-width: 4
 * indent-tabs-mode: nil
 * End:
 */
