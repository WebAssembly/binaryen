	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930111-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	main, func_end0-main

	.globl	wwrite
	.type	wwrite,@function
wwrite:                                 # @wwrite
	.param  	i64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB1_4
	block   	BB1_2
	i64.const	$push0=, 28
	i64.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %entry
	i64.const	$push2=, 1
	i64.shl 	$push3=, $pop2, $0
	i64.const	$push4=, 276825096
	i64.and 	$push5=, $pop3, $pop4
	i64.const	$push6=, 0
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, BB1_4
BB1_2:                                  # %entry
	i64.const	$push8=, 47
	i64.eq  	$push9=, $0, $pop8
	br_if   	$pop9, BB1_4
# BB#3:                                 # %sw.default
	i32.const	$1=, 123
BB1_4:                                  # %return
	return  	$1
func_end1:
	.size	wwrite, func_end1-wwrite


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
