	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000121-1.c"
	.globl	big
	.type	big,@function
big:                                    # @big
	.param  	i64
# BB#0:                                 # %entry
	return
func_end0:
	.size	big, func_end0-big

	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	return
func_end1:
	.size	doit, func_end1-doit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
