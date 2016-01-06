	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930702-1.c"
	.globl	fp
	.type	fp,@function
fp:                                     # @fp
	.param  	f64, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_3
	f64.const	$push0=, 0x1.08p5
	f64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 11
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB0_3
# BB#2:                                 # %if.end
	return  	$1
BB0_3:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	fp, func_end0-fp

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
