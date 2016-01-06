	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58431.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body
	i32.const	$3=, 0
	i32.const	$5=, 1
	i32.load16_u	$push0=, i($3)
	i32.xor 	$push1=, $pop0, $5
	i32.store16	$2=, i($3), $pop1
	i32.store	$discard=, b($3), $3
	i32.load	$0=, k($3)
	i32.load8_s	$1=, a($3)
	i32.const	$4=, 24
	block   	BB0_2
	i32.shl 	$push2=, $2, $4
	i32.shr_s	$4=, $pop2, $4
	i32.load	$push3=, j($3)
	br_if   	$pop3, BB0_2
# BB#1:                                 # %lor.rhs
	i32.load	$push4=, c($3)
	i32.ne  	$5=, $pop4, $3
BB0_2:                                  # %lor.end
	block   	BB0_10
	block   	BB0_8
	block   	BB0_6
	i32.ne  	$push5=, $1, $4
	br_if   	$pop5, BB0_6
# BB#3:                                 # %if.else
	i32.load	$4=, e($3)
	block   	BB0_5
	i32.const	$push9=, 1
	i32.store8	$2=, h($3), $pop9
	i32.const	$push11=, 0
	i32.eq  	$push12=, $4, $pop11
	br_if   	$pop12, BB0_5
# BB#4:                                 # %for.inc17.preheader
	i32.store	$discard=, e($3), $3
	br      	BB0_8
BB0_5:                                  # %for.end22.thread
	i32.store	$discard=, g($3), $0
	i32.store	$discard=, j($3), $5
	i32.store	$discard=, b($3), $2
	br      	BB0_10
BB0_6:                                  # %for.cond10thread-pre-split
	i32.load	$push6=, d($3)
	i32.gt_s	$push7=, $pop6, $3
	br_if   	$pop7, BB0_8
# BB#7:                                 # %for.inc.preheader
	i32.const	$push8=, 1
	i32.store	$discard=, d($3), $pop8
BB0_8:                                  # %for.end22
	i32.store	$discard=, g($3), $0
	i32.load8_u	$4=, h($3)
	i32.store	$discard=, j($3), $5
	i32.const	$push10=, 1
	i32.store	$discard=, b($3), $pop10
	br_if   	$4, BB0_10
# BB#9:                                 # %if.end27
	return  	$3
BB0_10:                                 # %if.then26
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	k,@object               # @k
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.type	g,@object               # @g
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.type	j,@object               # @j
	.globl	j
	.align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	a,@object               # @a
	.globl	a
a:
	.int8	0                       # 0x0
	.size	a, 1

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	h,@object               # @h
	.globl	h
h:
	.int8	0                       # 0x0
	.size	h, 1

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
