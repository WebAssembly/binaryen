	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57861.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load16_u	$0=, a($1)
	i32.store	$discard=, c($1), $1
	i32.const	$2=, 24
	copy_local	$4=, $0
	block   	.LBB0_2
	i32.load	$push3=, e($1)
	i32.shl 	$push1=, $0, $2
	i32.shr_s	$push2=, $pop1, $2
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	$pop4, .LBB0_2
# BB#1:                                 # %if.then.i.1
	i32.load	$push5=, d($1)
	i32.ne  	$push6=, $pop5, $1
	i32.load	$push7=, h($1)
	i32.ne  	$push8=, $pop7, $1
	i32.and 	$push0=, $pop6, $pop8
	i32.store16	$4=, a($1), $pop0
	i32.store16	$discard=, f($1), $1
.LBB0_2:                                  # %for.inc.i.1
	i32.store	$2=, j($1), $1
	i32.load	$3=, g($2)
	i32.const	$push9=, 255
	i32.and 	$push10=, $0, $pop9
	i32.ne  	$push11=, $pop10, $1
	i32.store	$discard=, i($2), $pop11
	i32.const	$push12=, 2
	i32.store	$discard=, c($2), $pop12
	i32.store	$1=, 0($3), $2
	block   	.LBB0_4
	i32.const	$push13=, 65535
	i32.and 	$push14=, $4, $pop13
	br_if   	$pop14, .LBB0_4
# BB#3:                                 # %if.end
	return  	$1
.LBB0_4:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	1
a:
	.int16	1                       # 0x1
	.size	a, 2

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	g,@object               # @g
	.data
	.globl	g
	.align	2
g:
	.int32	b
	.size	g, 4

	.type	f,@object               # @f
	.bss
	.globl	f
	.align	1
f:
	.int16	0                       # 0x0
	.size	f, 2

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	h,@object               # @h
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.type	i,@object               # @i
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	j,@object               # @j
	.globl	j
	.align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
