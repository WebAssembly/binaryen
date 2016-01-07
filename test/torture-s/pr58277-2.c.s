	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store8	$discard=, n($0), $0
	block   	.LBB0_4
	i32.load	$push0=, g($0)
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop0, $pop7
	br_if   	$pop8, .LBB0_4
# BB#1:                                 # %for.end.lr.ph.i.i
	i32.load	$2=, t($0)
.LBB0_2:                                  # %for.end.i.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.load	$discard=, d($0)
	i32.load	$push1=, h($0)
	i32.store	$1=, 0($pop1), $0
	i32.const	$push2=, 1
	i32.add 	$2=, $2, $pop2
	i32.load	$push3=, g($1)
	br_if   	$pop3, .LBB0_2
.LBB0_3:                                  # %fn2.exit.i
	i32.store	$discard=, t($1), $2
.LBB0_4:                                  # %if.end
	i32.load	$push4=, h($0)
	i32.store	$discard=, 0($pop4), $0
	i32.load	$push5=, s($0)
	i32.store	$discard=, 0($pop5), $0
	i32.store8	$push6=, n($0), $0
	return  	$pop6
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	n,@object               # @n
	.bss
	.globl	n
n:
	.int8	0                       # 0x0
	.size	n, 1

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	r,@object               # @r
	.globl	r
	.align	2
r:
	.int32	0
	.size	r, 4

	.type	f,@object               # @f
	.globl	f
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.type	g,@object               # @g
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.type	o,@object               # @o
	.globl	o
	.align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.type	x,@object               # @x
	.globl	x
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.type	h,@object               # @h
	.data
	.align	2
h:
	.int32	f
	.size	h, 4

	.type	s,@object               # @s
	.align	2
s:
	.int32	r
	.size	s, 4

	.type	t,@object               # @t
	.lcomm	t,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
