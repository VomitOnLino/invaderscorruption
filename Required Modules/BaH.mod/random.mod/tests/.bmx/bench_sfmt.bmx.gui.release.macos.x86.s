	.reference	___bb_blitz_blitz
	.reference	___bb_random_random
	.reference	___bb_standardio_standardio
	.reference	_bah_random_Rand
	.reference	_bah_random_Rnd
	.reference	_bah_random_RndDouble
	.reference	_bah_random_RndFloat
	.reference	_bah_random_SeedRnd
	.reference	_bbIntToLong
	.reference	_bbLongSub
	.reference	_bbMilliSecs
	.reference	_bbStringClass
	.reference	_bbStringConcat
	.reference	_bbStringFromLong
	.reference	_brl_standardio_Print
	.globl	__bb_main
	.text	
__bb_main:
	push	%ebp
	mov	%esp,%ebp
	sub	$72,%esp
	push	%ebx
	sub	$28,%esp
	cmpl	$0,_34
	je	_35
	mov	$0,%eax
	add	$28,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
_35:
	movl	$1,_34
	call	___bb_blitz_blitz
	call	___bb_standardio_standardio
	call	___bb_random_random
	movl	$100,(%esp)
	call	_bah_random_SeedRnd
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	mov	$0,%ebx
	jmp	_23
_5:
	movl	$1,4(%esp)
	movl	$0,(%esp)
	call	_bah_random_Rand
	movl	$50,4(%esp)
	movl	$1,(%esp)
	call	_bah_random_Rand
	movl	$10000,4(%esp)
	movl	$200,(%esp)
	call	_bah_random_Rand
_3:
	add	$1,%ebx
_23:
	cmp	$100000,%ebx
	jl	_5
_4:
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-16(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	movl	-4(%ebp),%eax
	movl	%eax,16(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,12(%esp)
	movl	-12(%ebp),%eax
	movl	%eax,8(%esp)
	movl	-16(%ebp),%eax
	movl	%eax,4(%esp)
	lea	-24(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbLongSub
	movl	-20(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-24(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringFromLong
	movl	%eax,4(%esp)
	movl	$_6,(%esp)
	call	_bbStringConcat
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	movl	$100,(%esp)
	call	_bah_random_SeedRnd
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	mov	$0,%ebx
	jmp	_26
_9:
	fldz
	fstpl	8(%esp)
	fld1
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstp	%st(0)
	fldl	_36
	fstpl	8(%esp)
	fld1
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstp	%st(0)
	fldl	_37
	fstpl	8(%esp)
	fldl	_38
	fstpl	(%esp)
	call	_bah_random_Rnd
	fstp	%st(0)
_7:
	add	$1,%ebx
_26:
	cmp	$100000,%ebx
	jl	_9
_8:
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-32(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	movl	-4(%ebp),%eax
	movl	%eax,16(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,12(%esp)
	movl	-28(%ebp),%eax
	movl	%eax,8(%esp)
	movl	-32(%ebp),%eax
	movl	%eax,4(%esp)
	lea	-40(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbLongSub
	movl	-36(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-40(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringFromLong
	movl	%eax,4(%esp)
	movl	$_10,(%esp)
	call	_bbStringConcat
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	movl	$100,(%esp)
	call	_bah_random_SeedRnd
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	mov	$0,%ebx
	jmp	_29
_13:
	call	_bah_random_RndFloat
	fstp	%st(0)
_11:
	add	$1,%ebx
_29:
	cmp	$100000,%ebx
	jl	_13
_12:
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-48(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	movl	-4(%ebp),%eax
	movl	%eax,16(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,12(%esp)
	movl	-44(%ebp),%eax
	movl	%eax,8(%esp)
	movl	-48(%ebp),%eax
	movl	%eax,4(%esp)
	lea	-56(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbLongSub
	movl	-52(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-56(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringFromLong
	movl	%eax,4(%esp)
	movl	$_14,(%esp)
	call	_bbStringConcat
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	movl	$100,(%esp)
	call	_bah_random_SeedRnd
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	mov	$0,%ebx
	jmp	_32
_17:
	call	_bah_random_RndDouble
	fstp	%st(0)
_15:
	add	$1,%ebx
_32:
	cmp	$100000,%ebx
	jl	_17
_16:
	call	_bbMilliSecs
	movl	%eax,4(%esp)
	lea	-64(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbIntToLong
	movl	-4(%ebp),%eax
	movl	%eax,16(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,12(%esp)
	movl	-60(%ebp),%eax
	movl	%eax,8(%esp)
	movl	-64(%ebp),%eax
	movl	%eax,4(%esp)
	lea	-72(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbLongSub
	movl	-68(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-72(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringFromLong
	movl	%eax,4(%esp)
	movl	$_18,(%esp)
	call	_bbStringConcat
	movl	%eax,(%esp)
	call	_brl_standardio_Print
	mov	$0,%eax
	jmp	_19
_19:
	add	$28,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
	.data	
	.align	4
_34:
	.long	0
	.align	4
_6:
	.long	_bbStringClass
	.long	2147483647
	.long	14
	.short	84,105,109,101,32,82,97,110,100,40,41,32,61,32
	.align	8
_36:
	.long	0x0,0x40490000
	.align	8
_37:
	.long	0x0,0x40c38800
	.align	8
_38:
	.long	0x0,0x40690000
	.align	4
_10:
	.long	_bbStringClass
	.long	2147483647
	.long	13
	.short	84,105,109,101,32,82,110,100,40,41,32,61,32
	.align	4
_14:
	.long	_bbStringClass
	.long	2147483647
	.long	18
	.short	84,105,109,101,32,82,110,100,70,108,111,97,116,40,41,32
	.short	61,32
	.align	4
_18:
	.long	_bbStringClass
	.long	2147483647
	.long	19
	.short	84,105,109,101,32,82,110,100,68,111,117,98,108,101,40,41
	.short	32,61,32
