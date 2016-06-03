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
	i32.const	$push16=, 0
	i32.load	$push15=, g($pop16)
	tee_local	$push14=, $4=, $pop15
	i32.const	$push13=, 1
	i32.lt_s	$push1=, $pop14, $pop13
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry.foo.exit_crit_edge
	i32.const	$push17=, 0
	i32.load	$5=, e($pop17)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body.lr.ph.i
	end_block                       # label1:
	i32.const	$push20=, 0
	i64.load32_s	$1=, f($pop20)
	i32.const	$push2=, -1
	i32.add 	$4=, $4, $pop2
	i32.const	$push19=, 0
	i32.load	$3=, a($pop19)
	i32.const	$push18=, 0
	i32.load	$2=, c($pop18)
.LBB0_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push32=, 0
	i32.load	$push0=, 0($2)
	i32.store	$0=, h($pop32), $pop0
	i32.const	$push31=, 0
	i32.const	$push30=, 2
	i32.add 	$push3=, $4, $pop30
	i32.store	$drop=, g($pop31), $pop3
	i32.const	$push29=, 0
	i32.const	$push28=, 16
	i32.shl 	$push4=, $0, $pop28
	i32.const	$push27=, 16
	i32.shr_s	$push5=, $pop4, $pop27
	i32.eq  	$push6=, $pop5, $3
	i64.extend_u/i32	$push7=, $pop6
	i64.lt_u	$push26=, $pop7, $1
	tee_local	$push25=, $5=, $pop26
	i32.store	$drop=, e($pop29), $pop25
	i32.const	$push24=, 1
	i32.add 	$push23=, $4, $pop24
	tee_local	$push22=, $4=, $pop23
	i32.const	$push21=, 0
	i32.lt_s	$push8=, $pop22, $pop21
	br_if   	0, $pop8        # 0: up to label2
# BB#4:                                 # %for.cond.for.end_crit_edge.i
	end_loop                        # label3:
	i32.const	$push9=, 0
	i32.store16	$drop=, d($pop9), $0
.LBB0_5:                                # %foo.exit
	end_block                       # label0:
	block
	i32.const	$push10=, 1
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label4
# BB#6:                                 # %if.end
	i32.const	$push12=, 0
	return  	$pop12
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
	.functype	abort, void
