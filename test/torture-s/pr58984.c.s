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
	i32.load	$push1=, e($pop14)
	i32.const	$push13=, 1
	i32.gt_s	$push2=, $pop1, $pop13
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.i
	i32.const	$push16=, 0
	i32.load	$0=, c($pop16)
	i32.load	$push3=, 0($0)
	i32.const	$push15=, 1
	i32.xor 	$push4=, $pop3, $pop15
	i32.store	$discard=, 0($0), $pop4
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	block
	i32.const	$push19=, 0
	i32.load	$push5=, a($pop19)
	i32.const	$push18=, 0
	i32.const	$push17=, 1
	i32.store	$push0=, m($pop18), $pop17
	i32.ne  	$push6=, $pop5, $pop0
	br_if   	0, $pop6        # 0: down to label1
# BB#3:                                 # %bar.exit
	i32.const	$push7=, 0
	i32.load	$1=, c($pop7)
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.store	$0=, e($pop22), $pop21
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 1
	i32.xor 	$push10=, $pop8, $pop9
	i32.store	$discard=, 0($1), $pop10
	i32.load	$1=, a($0)
	i32.load	$push11=, m($0)
	i32.const	$push20=, 1
	i32.or  	$push12=, $pop11, $pop20
	i32.store	$discard=, m($0), $pop12
	br_if   	0, $1           # 0: down to label1
# BB#4:                                 # %if.end11
	return  	$0
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


	.ident	"clang version 3.9.0 "
