	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63659.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push1=, a($0)
	i32.const	$push10=, 0
	i32.eq  	$push11=, $pop1, $pop10
	br_if   	$pop11, .LBB0_2
# BB#1:                                 # %for.cond.preheader
	i32.store	$discard=, a($0), $0
.LBB0_2:                                  # %while.end
	i32.const	$1=, 255
	i32.load8_s	$push2=, c($0)
	i32.load	$push3=, h($0)
	i32.shr_s	$push0=, $pop2, $pop3
	i32.store	$2=, g($0), $pop0
	copy_local	$3=, $1
	block   	.LBB0_4
	i32.const	$push12=, 0
	i32.eq  	$push13=, $2, $pop12
	br_if   	$pop13, .LBB0_4
# BB#3:                                 # %cond.false
	i32.const	$push4=, -1
	i32.rem_s	$3=, $pop4, $2
.LBB0_4:                                  # %cond.end
	i32.load	$2=, d($0)
	block   	.LBB0_6
	i32.store8	$push5=, f($0), $3
	i32.store8	$push6=, e($0), $pop5
	i32.and 	$push7=, $pop6, $1
	i32.store	$discard=, 0($2), $pop7
	i32.load	$push8=, b($0)
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, .LBB0_6
# BB#5:                                 # %if.end23
	return  	$0
.LBB0_6:                                  # %if.then22
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	d,@object               # @d
	.data
	.globl	d
	.align	2
d:
	.int32	b
	.size	d, 4

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	i,@object               # @i
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	h,@object               # @h
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.type	g,@object               # @g
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.type	f,@object               # @f
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.type	e,@object               # @e
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
