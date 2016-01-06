	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr7284-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 23
	i32.shr_s	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push0=, x($0)
	i32.const	$push1=, 255
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 128
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	2
x:
	.int32	128                     # 0x80
	.size	x, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
