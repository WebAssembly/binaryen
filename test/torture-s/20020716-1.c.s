	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020716-1.c"
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
func_end0:
	.size	sub1, func_end0-sub1

	.globl	testcond
	.type	testcond,@function
testcond:                               # @testcond
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 5046272
	i32.select	$push2=, $0, $pop1, $pop0
	return  	$pop2
func_end1:
	.size	testcond, func_end1-testcond

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
