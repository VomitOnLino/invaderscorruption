	.reference	___bb_blitz_blitz
	.reference	___bb_random_random
	.reference	___bb_standardio_standardio
	.reference	_bah_random_Rand
	.reference	_bah_random_Rand64
	.reference	_bah_random_Rnd
	.reference	_bah_random_RndDouble
	.reference	_bah_random_RndFloat
	.reference	_bah_random_SeedRnd
	.reference	_bbStringClass
	.reference	_bbStringFromDouble
	.reference	_bbStringFromFloat
	.reference	_bbStringFromInt
	.reference	_bbStringFromLong
	.reference	_brl_standardio_Print
	.globl	__bb_main
	.text	
__bb_main:
	push	%ebp
	mov	%esp,%ebp
	sub	$8,%esp
	push	%ebx
	sub	$28,%esp
	cmpl	$0,_30
	je	_31
	mov	$0,%eax
	add	$28,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
_31:
	movl	$1,_30
	call	___bb_blitz_blitz
	call	___bb_standardio_standardio
	call	___bb_random_random
	movl	$_3,(%esp)
	call	_brl_standardio_Print
	mov	$0,%ebx
	jmp	_23
_6:
	movl	$100,4(%esp)
	movl	$1,(%esp)
	call	_bah_random_Rand
	movl	%eax,(%esp)
	call	_bbStringFromInt
	movl	%eax,(%esp)
	call	_brl_standardio_Print
_4:
	add	$1,%ebx
_23:
	cmp	$20,%ebx
	jl	_6
_5:
	movl	$_7,(%esp)
	call	_brl_standardio_Print
	movl	$0,(%esp)
	call	_bah_random_SeedRnd
	mov	$0,%ebx
	jmp	_25
_10:
	movl	$0,16(%esp)
	movl	$1,12(%esp)
	movl	$1048575,8(%esp)
	movl	$-1,4(%esp)
	lea	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bah_random_Rand64
	movl	-4(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringFromLong
	movl	%eax,(%esp)
	call	_brl_standardio_Print
_8:
	add	$1,%ebx
_25:
	cmp	$20,%ebx
	jl	_10
_9:
	movl	$_11,(%esp)
	call	_brl_standardio_Print
	movl	$0,(%esp)
	call	_bah_random_SeedRnd
	mov	$0,%ebx
	jmp	_27
_14:
	call	_bah_random_RndFloat
	fstps	(%esp)
	call	_bbStringFromFloat
	movl	%eax,(%esp)
	call	_brl_standardio_Print
_12:
	add	$1,%ebx
_27:
	cmp	$20,%ebx
	jl	_14
_13:
	movl	$_15,(%esp)
	call	_brl_standardio_Print
	mov	$0,%ebx
	jmp	_29
_18:
	call	_bah_random_RndDouble
	fstpl	(%esp)
	call	_bbStringFromDouble
	movl	%eax,(%esp)
	call	_brl_standardio_Print
_16:
	add	$1,%ebx
_29:
	cmp	$20,%ebx
	jl	_18
_17:
	movl	$_19,(%esp)
	call	_brl_standardio_Print
	fldz
	fstpl	8(%esp)
	fld1
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstpl	(%esp)
	call	_bbStringFromDouble
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	fldz
	fstpl	8(%esp)
	fldl	_32
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstpl	(%esp)
	call	_bbStringFromDouble
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	fldl	_33
	fstpl	8(%esp)
	fldl	_34
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstpl	(%esp)
	call	_bbStringFromDouble
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	mov	$0,%eax
	jmp	_20
_20:
	add	$28,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
	.data	
	.align	4
_30:
	.long	0
	.align	4
_3:
	.long	_bbStringClass
	.long	2147483647
	.long	4
	.short	73,110,116,10
	.align	4
_7:
	.long	_bbStringClass
	.long	2147483647
	.long	5
	.short	76,111,110,103,10
	.align	4
_11:
	.long	_bbStringClass
	.long	2147483647
	.long	6
	.short	70,108,111,97,116,10
	.align	4
_15:
	.long	_bbStringClass
	.long	2147483647
	.long	7
	.short	68,111,117,98,108,101,10
	.align	4
_19:
	.long	_bbStringClass
	.long	2147483647
	.long	4
	.short	82,110,100,10
	.align	8
_32:
	.long	0x0,0x40140000
	.align	8
_33:
	.long	0x0,0x40240000
	.align	8
_34:
	.long	0x0,0x40180000
