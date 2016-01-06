	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991202-3.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 13
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 536862720
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	f, func_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	return  	$pop1
func_end1:
	.size	g, func_end1-g

	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.shr_u	$push1=, $0, $pop0
	return  	$pop1
func_end2:
	.size	h, func_end2-h

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end3:
	.size	main, func_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
