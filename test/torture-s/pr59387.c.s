	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59387.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$2=, c($0)
	i32.const	$push1=, -19
	i32.store	$1=, a($0), $pop1
.LBB0_1:                                  # %for.body2
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.load	$push3=, e($0)
	i32.const	$push4=, f
	i32.store	$discard=, 0($pop3), $pop4
	i32.const	$push2=, -24
	i32.add 	$2=, $2, $pop2
	i32.load	$push5=, d($0)
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop5, $pop8
	br_if   	$pop9, .LBB0_3
# BB#2:                                 # %for.inc4
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$push0=, $1, $pop6
	i32.store	$1=, a($0), $pop0
	br_if   	$1, .LBB0_1
.LBB0_3:                                  # %return
	i32.store8	$discard=, c($0), $2
	i32.const	$push7=, 24
	i32.store	$discard=, b($0), $pop7
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	d,@object               # @d
	.bss
	.globl	d
	.align	2
d:
	.int32	0
	.size	d, 4

	.type	e,@object               # @e
	.data
	.globl	e
	.align	2
e:
	.int32	d
	.size	e, 4

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.zero	4
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

	.type	f,@object               # @f
	.globl	f
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
