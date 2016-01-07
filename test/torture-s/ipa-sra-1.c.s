	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/ipa-sra-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2000
	i32.gt_s	$push1=, $0, $pop0
	i32.call	$push2=, ox, $pop1
	return  	$pop2
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	ox,@function
ox:                                     # @ox
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	ox, .Lfunc_end1-ox


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
