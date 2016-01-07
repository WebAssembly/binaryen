	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930622-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$1
.Lfunc_end1:
	.size	h, .Lfunc_end1-h

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$push0=, a($0), $0
	return  	$pop0
.Lfunc_end2:
	.size	f, .Lfunc_end2-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store	$push0=, a($0), $0
	call    	exit, $pop0
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
