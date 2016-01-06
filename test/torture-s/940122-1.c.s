	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/940122-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB0_2
	i32.load	$push0=, a($1)
	i32.ne  	$push1=, $pop0, $1
	i32.load	$push2=, b($1)
	i32.ne  	$push3=, $pop2, $1
	i32.ne  	$push4=, $pop1, $pop3
	br_if   	$pop4, BB0_2
# BB#1:                                 # %if.end
	return  	$1
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	g, func_end0-g

	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB1_2
	i32.load	$push0=, a($1)
	i32.ne  	$push1=, $pop0, $1
	i32.load	$push2=, b($1)
	i32.ne  	$push3=, $pop2, $1
	i32.ne  	$push4=, $pop1, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %g.exit
	return  	$1
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	f, func_end1-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB2_2
	i32.load	$push0=, a($0)
	i32.ne  	$push1=, $pop0, $0
	i32.load	$push2=, b($0)
	i32.ne  	$push3=, $pop2, $0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, BB2_2
# BB#1:                                 # %if.then.i.i
	call    	abort
	unreachable
BB2_2:                                  # %f.exit
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
