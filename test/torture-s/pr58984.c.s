	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58984.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push14=, 0
	i32.load	$push0=, e($pop14)
	i32.const	$push13=, 1
	i32.gt_s	$push1=, $pop0, $pop13
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.i
	i32.const	$push16=, 0
	i32.load	$1=, c($pop16)
	i32.load	$push2=, 0($1)
	i32.const	$push15=, 1
	i32.xor 	$push3=, $pop2, $pop15
	i32.store	$discard=, 0($1), $pop3
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	block
	block
	i32.const	$push19=, 0
	i32.load	$push5=, a($pop19)
	i32.const	$push18=, 0
	i32.const	$push17=, 1
	i32.store	$push4=, m($pop18), $pop17
	i32.ne  	$push6=, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label2
# BB#3:                                 # %bar.exit
	i32.const	$push7=, 0
	i32.const	$push23=, 0
	i32.store	$push22=, e($pop7), $pop23
	tee_local	$push21=, $1=, $pop22
	i32.load	$0=, c($pop21)
	i32.load	$push8=, 0($0)
	i32.const	$push9=, 1
	i32.xor 	$push10=, $pop8, $pop9
	i32.store	$discard=, 0($0), $pop10
	i32.load	$0=, a($1)
	i32.load	$push11=, m($1)
	i32.const	$push20=, 1
	i32.or  	$push12=, $pop11, $pop20
	i32.store	$discard=, m($1), $pop12
	br_if   	1, $0           # 1: down to label1
# BB#4:                                 # %if.end11
	return  	$1
.LBB0_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then10
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


	.ident	"clang version 3.9.0 "
