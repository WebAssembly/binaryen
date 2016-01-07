	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53160.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$discard=, e($0), $0
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load	$push0=, g($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	$pop7, .LBB1_2
# BB#1:                                 # %if.then
	i32.load	$discard=, b($0)
.LBB1_2:                                  # %if.end
	i32.store	$discard=, e($0), $0
	i32.load8_s	$1=, f($0)
	i32.load	$2=, c($0)
	block   	.LBB1_4
	i32.const	$push2=, -1
	i32.store	$discard=, d($0), $pop2
	i32.store16	$push1=, i($0), $1
	i32.select	$push3=, $2, $pop1, $0
	i32.store	$push4=, h($0), $pop3
	i32.store	$push5=, a($0), $pop4
	br_if   	$pop5, .LBB1_4
# BB#3:                                 # %if.end16
	return  	$0
.LBB1_4:                                  # %if.then15
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	c,@object               # @c
	.data
	.globl	c
	.align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.type	e,@object               # @e
	.bss
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.type	g,@object               # @g
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	f,@object               # @f
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.type	i,@object               # @i
	.globl	i
	.align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.type	h,@object               # @h
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
