/*
 *  linux/arch/arm/lib/findbit.S
 *
 *  Copyright (C) 1995-2000 Russell King
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * 16th March 2001 - John Ripley <jripley@sonicblue.com>
 *   Fixed so that "size" is an exclusive not an inclusive quantity.
 *   All users of these functions expect exclusive sizes, and may
 *   also call with zero size.
 * Reworked by rmk.
 */
#include "assembler.h"
                .text

/*
 * Purpose  : Find a 'zero' bit
 * Prototype: int find_first_zero_bit(void *addr, unsigned int maxbit);
 */
FUNC(_find_first_zero_bit_le)
		teq	r1, #0	
		beq	3f
		mov	r2, #0
1:
 ARM(		ldrb	r3, [r0, r2, lsr #3]	)
 THUMB(		lsr	r3, r2, #3		)
 THUMB(		ldrb	r3, [r0, r3]		)
		eors	r3, r3, #0xff		@ invert bits
		bne	.L_found		@ any now set - found zero bit
		add	r2, r2, #8		@ next bit pointer
2:		cmp	r2, r1			@ any more?
		blo	1b
3:		mov	r0, r1			@ no free bits
		mov	pc, lr
END(_find_first_zero_bit_le)

/*
 * Purpose  : Find next 'zero' bit
 * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
 */
FUNC(_find_next_zero_bit_le)
		cmp	r1, r2
		bls	3b
		ands	ip, r2, #7
		beq	1b			@ If new byte, goto old routine
 ARM(		ldrb	r3, [r0, r2, lsr #3]	)
 THUMB(		lsr	r3, r2, #3		)
 THUMB(		ldrb	r3, [r0, r3]		)
		eor	r3, r3, #0xff		@ now looking for a 1 bit
		movs	r3, r3, lsr ip		@ shift off unused bits
		bne	.L_found
		orr	r2, r2, #7		@ if zero, then no bits here
		add	r2, r2, #1		@ align bit pointer
		b	2b			@ loop for next bit
END(_find_next_zero_bit_le)

/*
 * Purpose  : Find a 'one' bit
 * Prototype: int find_first_bit(const unsigned long *addr, unsigned int maxbit);
 */
FUNC(_find_first_bit_le)
		teq	r1, #0	
		beq	3f
		mov	r2, #0
1:
 ARM(		ldrb	r3, [r0, r2, lsr #3]	)
 THUMB(		lsr	r3, r2, #3		)
 THUMB(		ldrb	r3, [r0, r3]		)
		movs	r3, r3
		bne	.L_found		@ any now set - found zero bit
		add	r2, r2, #8		@ next bit pointer
2:		cmp	r2, r1			@ any more?
		blo	1b
3:		mov	r0, r1			@ no free bits
		mov	pc, lr
END(_find_first_bit_le)

/*
 * Purpose  : Find next 'one' bit
 * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
 */
FUNC(_find_next_bit_le)
		cmp	r1, r2
		bls	3b
		ands	ip, r2, #7
		beq	1b			@ If new byte, goto old routine
 ARM(		ldrb	r3, [r0, r2, lsr #3]	)
 THUMB(		lsr	r3, r2, #3		)
 THUMB(		ldrb	r3, [r0, r3]		)
		movs	r3, r3, lsr ip		@ shift off unused bits
		bne	.L_found
		orr	r2, r2, #7		@ if zero, then no bits here
		add	r2, r2, #1		@ align bit pointer
		b	2b			@ loop for next bit
END(_find_next_bit_le)

#ifdef __ARMEB__

FUNC(_find_first_zero_bit_be)
		teq	r1, #0
		beq	3f
		mov	r2, #0
1:		eor	r3, r2, #0x18		@ big endian byte ordering
 ARM(		ldrb	r3, [r0, r3, lsr #3]	)
 THUMB(		lsr	r3, #3			)
 THUMB(		ldrb	r3, [r0, r3]		)
		eors	r3, r3, #0xff		@ invert bits
		bne	.L_found		@ any now set - found zero bit
		add	r2, r2, #8		@ next bit pointer
2:		cmp	r2, r1			@ any more?
		blo	1b
3:		mov	r0, r1			@ no free bits
		mov	pc, lr
END(_find_first_zero_bit_be)

FUNC(_find_next_zero_bit_be)
		cmp	r1, r2
		bls	3b
		ands	ip, r2, #7
		beq	1b			@ If new byte, goto old routine
		eor	r3, r2, #0x18		@ big endian byte ordering
 ARM(		ldrb	r3, [r0, r3, lsr #3]	)
 THUMB(		lsr	r3, #3			)
 THUMB(		ldrb	r3, [r0, r3]		)
		eor	r3, r3, #0xff		@ now looking for a 1 bit
		movs	r3, r3, lsr ip		@ shift off unused bits
		bne	.L_found
		orr	r2, r2, #7		@ if zero, then no bits here
		add	r2, r2, #1		@ align bit pointer
		b	2b			@ loop for next bit
END(_find_next_zero_bit_be)

FUNC(_find_first_bit_be)
		teq	r1, #0
		beq	3f
		mov	r2, #0
1:		eor	r3, r2, #0x18		@ big endian byte ordering
 ARM(		ldrb	r3, [r0, r3, lsr #3]	)
 THUMB(		lsr	r3, #3			)
 THUMB(		ldrb	r3, [r0, r3]		)
		movs	r3, r3
		bne	.L_found		@ any now set - found zero bit
		add	r2, r2, #8		@ next bit pointer
2:		cmp	r2, r1			@ any more?
		blo	1b
3:		mov	r0, r1			@ no free bits
		mov	pc, lr
END(_find_first_bit_be)

FUNC(_find_next_bit_be)
		cmp	r1, r2
		bls	3b
		ands	ip, r2, #7
		beq	1b			@ If new byte, goto old routine
		eor	r3, r2, #0x18		@ big endian byte ordering
 ARM(		ldrb	r3, [r0, r3, lsr #3]	)
 THUMB(		lsr	r3, #3			)
 THUMB(		ldrb	r3, [r0, r3]		)
		movs	r3, r3, lsr ip		@ shift off unused bits
		bne	.L_found
		orr	r2, r2, #7		@ if zero, then no bits here
		add	r2, r2, #1		@ align bit pointer
		b	2b			@ loop for next bit
END(_find_next_bit_be)

#endif

/*
 * One or more bits in the LSB of r3 are assumed to be set.
 */
.L_found:
#if __LINUX_ARM_ARCH__ >= 5
		rsb	r0, r3, #0
		and	r3, r3, r0
		clz	r3, r3
		rsb	r3, r3, #31
		add	r0, r2, r3
#else
		tst	r3, #0x0f
		addeq	r2, r2, #4
		movne	r3, r3, lsl #4
		tst	r3, #0x30
		addeq	r2, r2, #2
		movne	r3, r3, lsl #2
		tst	r3, #0x40
		addeq	r2, r2, #1
		mov	r0, r2
#endif
		cmp	r1, r0			@ Clamp to maxbit
		movlo	r0, r1
		mov	pc, lr

