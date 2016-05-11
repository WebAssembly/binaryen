	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57877.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push15=, 0
	i32.load	$push14=, g($pop15)
	tee_local	$push13=, $5=, $pop14
	i32.const	$push12=, 1
	i32.lt_s	$push0=, $pop13, $pop12
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %entry.foo.exit_crit_edge
	i32.const	$push16=, 0
	i32.load	$4=, e($pop16)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body.lr.ph.i
	end_block                       # label1:
	i32.const	$push19=, 0
	i64.load32_s	$1=, f($pop19)
	i32.const	$push18=, 0
	i32.load	$2=, c($pop18)
	i32.const	$push17=, 0
	i32.load	$3=, a($pop17)
	i32.const	$push1=, -1
	i32.add 	$5=, $5, $pop1
.LBB0_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$4=, 0($2)
	i32.const	$push29=, 0
	i32.const	$push28=, 2
	i32.add 	$push6=, $5, $pop28
	i32.store	$discard=, g($pop29), $pop6
	i32.const	$push27=, 0
	i32.store	$0=, h($pop27), $4
	i32.const	$push26=, 0
	i32.const	$push25=, 16
	i32.shl 	$push2=, $4, $pop25
	i32.const	$push24=, 16
	i32.shr_s	$push3=, $pop2, $pop24
	i32.eq  	$push4=, $pop3, $3
	i64.extend_u/i32	$push5=, $pop4
	i64.lt_u	$push23=, $pop5, $1
	tee_local	$push22=, $4=, $pop23
	i32.store	$discard=, e($pop26), $pop22
	i32.const	$push21=, 1
	i32.add 	$5=, $5, $pop21
	i32.const	$push20=, 0
	i32.lt_s	$push7=, $5, $pop20
	br_if   	0, $pop7        # 0: up to label2
# BB#4:                                 # %for.cond.for.end_crit_edge.i
	end_loop                        # label3:
	i32.const	$push8=, 0
	i32.store16	$discard=, d($pop8), $0
.LBB0_5:                                # %foo.exit
	end_block                       # label0:
	block
	i32.const	$push9=, 1
	i32.ne  	$push10=, $4, $pop9
	br_if   	0, $pop10       # 0: down to label4
# BB#6:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_7:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
