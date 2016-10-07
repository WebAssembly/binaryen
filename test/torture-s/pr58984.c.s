	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58984.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push13=, 0
	i32.load	$push0=, e($pop13)
	i32.const	$push12=, 1
	i32.gt_s	$push1=, $pop0, $pop12
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.i
	i32.const	$push17=, 0
	i32.load	$push16=, c($pop17)
	tee_local	$push15=, $0=, $pop16
	i32.load	$push2=, 0($0)
	i32.const	$push14=, 1
	i32.xor 	$push3=, $pop2, $pop14
	i32.store	0($pop15), $pop3
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.store	m($pop21), $pop20
	block   	
	i32.const	$push19=, 0
	i32.load	$push4=, a($pop19)
	i32.const	$push18=, 1
	i32.ne  	$push5=, $pop4, $pop18
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %bar.exit
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.store	e($pop30), $pop29
	i32.const	$push28=, 0
	i32.load	$push27=, c($pop28)
	tee_local	$push26=, $0=, $pop27
	i32.load	$push6=, 0($0)
	i32.const	$push7=, 1
	i32.xor 	$push8=, $pop6, $pop7
	i32.store	0($pop26), $pop8
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push9=, m($pop24)
	i32.const	$push23=, 1
	i32.or  	$push10=, $pop9, $pop23
	i32.store	m($pop25), $pop10
	i32.const	$push22=, 0
	i32.load	$push11=, a($pop22)
	br_if   	0, $pop11       # 0: down to label1
# BB#4:                                 # %if.end11
	i32.const	$push31=, 0
	return  	$pop31
.LBB0_5:                                # %if.then10
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	a
	.size	c, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	m                       # @m
	.type	m,@object
	.section	.bss.m,"aw",@nobits
	.globl	m
	.p2align	2
m:
	.int32	0                       # 0x0
	.size	m, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
