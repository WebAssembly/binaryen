	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57877.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push15=, 0
	i32.load	$push14=, g($pop15)
	tee_local	$push13=, $4=, $pop14
	i32.const	$push12=, 1
	i32.lt_s	$push0=, $pop13, $pop12
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %entry.foo.exit_crit_edge
	i32.const	$push16=, 0
	i32.load	$5=, e($pop16)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body.lr.ph.i
	end_block                       # label1:
	i32.const	$push19=, 0
	i64.load32_s	$0=, f($pop19)
	i32.const	$push1=, -1
	i32.add 	$4=, $4, $pop1
	i32.const	$push18=, 0
	i32.load	$2=, a($pop18)
	i32.const	$push17=, 0
	i32.load	$1=, c($pop17)
.LBB0_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push33=, 0
	i32.load	$push32=, 0($1)
	tee_local	$push31=, $3=, $pop32
	i32.store	h($pop33), $pop31
	i32.const	$push30=, 0
	i32.const	$push29=, 2
	i32.add 	$push2=, $4, $pop29
	i32.store	g($pop30), $pop2
	i32.const	$push28=, 0
	i32.const	$push27=, 16
	i32.shl 	$push3=, $3, $pop27
	i32.const	$push26=, 16
	i32.shr_s	$push4=, $pop3, $pop26
	i32.eq  	$push5=, $pop4, $2
	i64.extend_u/i32	$push6=, $pop5
	i64.lt_u	$push25=, $pop6, $0
	tee_local	$push24=, $5=, $pop25
	i32.store	e($pop28), $pop24
	i32.const	$push23=, 1
	i32.add 	$push22=, $4, $pop23
	tee_local	$push21=, $4=, $pop22
	i32.const	$push20=, 0
	i32.lt_s	$push7=, $pop21, $pop20
	br_if   	0, $pop7        # 0: up to label2
# BB#4:                                 # %for.cond.for.end_crit_edge.i
	end_loop
	i32.const	$push8=, 0
	i32.store16	d($pop8), $3
.LBB0_5:                                # %foo.exit
	end_block                       # label0:
	block   	
	i32.const	$push9=, 1
	i32.ne  	$push10=, $5, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#6:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_7:                                # %if.then
	end_block                       # label3:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
