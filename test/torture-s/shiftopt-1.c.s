	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/shiftopt-1.c"
	.globl	utest
	.type	utest,@function
utest:                                  # @utest
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	utest, .Lfunc_end0-utest

	.globl	stest
	.type	stest,@function
stest:                                  # @stest
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	stest, .Lfunc_end1-stest

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
