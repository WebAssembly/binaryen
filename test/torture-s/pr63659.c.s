	.text
	.file	"pr63659.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push8=, 0
	i32.load	$push0=, a($pop8)
	i32.eqz 	$push21=, $pop0
	br_if   	0, $pop21       # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	a($pop10), $pop9
.LBB0_2:                                # %while.end
	end_block                       # label0:
	i32.const	$push13=, 0
	i32.load8_s	$push2=, c($pop13)
	i32.const	$push12=, 0
	i32.load	$push1=, h($pop12)
	i32.shr_s	$0=, $pop2, $pop1
	i32.const	$push11=, 0
	i32.store	g($pop11), $0
	i32.const	$1=, 255
	block   	
	i32.eqz 	$push22=, $0
	br_if   	0, $pop22       # 0: down to label1
# %bb.3:                                # %cond.false
	i32.const	$push3=, -1
	i32.rem_s	$1=, $pop3, $0
.LBB0_4:                                # %cond.end
	end_block                       # label1:
	i32.const	$push19=, 0
	i32.load	$push5=, d($pop19)
	i32.const	$push18=, 255
	i32.and 	$push4=, $1, $pop18
	i32.store	0($pop5), $pop4
	i32.const	$push17=, 0
	i32.store8	e($pop17), $1
	i32.const	$push16=, 0
	i32.store8	f($pop16), $1
	block   	
	i32.const	$push15=, 0
	i32.load	$push6=, b($pop15)
	i32.const	$push14=, 255
	i32.ne  	$push7=, $pop6, $pop14
	br_if   	0, $pop7        # 0: down to label2
# %bb.5:                                # %if.end23
	i32.const	$push20=, 0
	return  	$pop20
.LBB0_6:                                # %if.then22
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	b
	.size	d, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
