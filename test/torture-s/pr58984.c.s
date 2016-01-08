	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58984.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 1
	block   	.LBB0_2
	i32.load	$push0=, e($0)
	i32.gt_s	$push1=, $pop0, $1
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %for.body.i
	i32.load	$2=, c($0)
	i32.load	$push2=, 0($2)
	i32.xor 	$push3=, $pop2, $1
	i32.store	$discard=, 0($2), $pop3
.LBB0_2:                                # %foo.exit
	i32.load	$2=, a($0)
	i32.store	$discard=, m($0), $1
	block   	.LBB0_6
	i32.ne  	$push4=, $2, $1
	br_if   	$pop4, .LBB0_6
# BB#3:                                 # %bar.exit
	i32.store	$discard=, e($0), $0
	i32.load	$2=, c($0)
	i32.load	$push5=, 0($2)
	i32.xor 	$push6=, $pop5, $1
	i32.store	$discard=, 0($2), $pop6
	i32.load	$2=, a($0)
	block   	.LBB0_5
	i32.load	$push7=, m($0)
	i32.or  	$push8=, $pop7, $1
	i32.store	$discard=, m($0), $pop8
	br_if   	$2, .LBB0_5
# BB#4:                                 # %if.end11
	return  	$0
.LBB0_5:                                # %if.then10
	call    	abort
	unreachable
.LBB0_6:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	2
c:
	.int32	a
	.size	c, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	m                       # @m
	.type	m,@object
	.section	.bss.m,"aw",@nobits
	.globl	m
	.align	2
m:
	.int32	0                       # 0x0
	.size	m, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
