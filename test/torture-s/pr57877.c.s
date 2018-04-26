	.text
	.file	"pr57877.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$4=, g($pop13)
	block   	
	block   	
	i32.const	$push12=, 1
	i32.lt_s	$push1=, $4, $pop12
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry.foo.exit_crit_edge
	i32.const	$push14=, 0
	i32.load	$5=, e($pop14)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body.lr.ph.i
	end_block                       # label1:
	i32.const	$push17=, 0
	i64.load32_s	$0=, f($pop17)
	i32.const	$push2=, -1
	i32.add 	$4=, $4, $pop2
	i32.const	$push16=, 0
	i32.load	$2=, a($pop16)
	i32.const	$push15=, 0
	i32.load	$1=, c($pop15)
.LBB0_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$3=, 0($1)
	i32.const	$push25=, 0
	i32.store	h($pop25), $3
	i32.const	$push24=, 0
	i32.const	$push23=, 2
	i32.add 	$push3=, $4, $pop23
	i32.store	g($pop24), $pop3
	i32.const	$push22=, 16
	i32.shl 	$push4=, $3, $pop22
	i32.const	$push21=, 16
	i32.shr_s	$push5=, $pop4, $pop21
	i32.eq  	$push6=, $pop5, $2
	i64.extend_u/i32	$push0=, $pop6
	i64.lt_u	$5=, $pop0, $0
	i32.const	$push20=, 0
	i32.store	e($pop20), $5
	i32.const	$push19=, 1
	i32.add 	$4=, $4, $pop19
	i32.const	$push18=, 0
	i32.lt_s	$push7=, $4, $pop18
	br_if   	0, $pop7        # 0: up to label2
# %bb.4:                                # %for.cond.for.end_crit_edge.i
	end_loop
	i32.const	$push8=, 0
	i32.store16	d($pop8), $3
.LBB0_5:                                # %foo.exit
	end_block                       # label0:
	block   	
	i32.const	$push9=, 1
	i32.ne  	$push10=, $5, $pop9
	br_if   	0, $pop10       # 0: down to label3
# %bb.6:                                # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_7:                                # %if.then
	end_block                       # label3:
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

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	b
	.size	c, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	6                       # 0x6
	.size	f, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	1
d:
	.int16	0                       # 0x0
	.size	d, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
